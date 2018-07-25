package com.hikearmenia.activities;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.dialogs.CustomAlertDialog;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Direction;
import com.hikearmenia.models.api.Response;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.models.api.TrailRoute;
import com.hikearmenia.ui.RatingBar;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.GPSTracker;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.mapbox.mapboxsdk.MapboxAccountManager;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.annotations.PolylineOptions;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.location.LocationServices;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;
import com.nineoldandroids.animation.Animator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.List;

import static com.hikearmenia.activities.TrailDetailActivity.laodTrailFile;


public class MapsActivity extends BaseActivity implements View.OnTouchListener, MapboxMap.OnMyLocationChangeListener, OnMapReadyCallback {

    private RelativeLayout leftIconLayoutToolbar;
    private ImageView leftIconToolbar;
    private RelativeLayout rightIconLayoutToolbar;
    private ImageView rightIconToolbar;
    //    private MapView mapView;
    private com.mapbox.mapboxsdk.maps.MapView mapView;
    private TextView trailName;
    private RelativeLayout currentLocation;
    private LinearLayout trailDetail;
    private ImageView locatinCurrentTrail;
    private List<com.mapbox.mapboxsdk.geometry.LatLng> points;
    private GPSTracker gps;
    private ImageView appIcon;
    private boolean isRouteMape;
    private boolean isRouting;
    private List<com.mapbox.mapboxsdk.geometry.LatLng> currentRoute;
    String mType;
    boolean isSavedTrail;
    MapboxMap mapboxMap;
    ImageView startPaintRout;
    LocationServices locationServices;
    private SharedPreferences sharedPreferences;
    private final String SAVED_BOOLEAN = "saved boolean";
    private String trailId;
    private boolean isRouteSended;
    private final String KEY = "mykey";
    private final String ROUTING_KEY = "My_routing_key";
    Trail mTrail;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MapboxAccountManager.start(this, getString(R.string.accessToken));
        HikeArmeniaApplication.setCurrentActivity(MapsActivity.this);
        setContentView(R.layout.activity_maps);
//        mTrail = getIntent().getParcelableExtra("trail");

        locationServices = LocationServices.getLocationServices(MapsActivity.this);
        mapView = (com.mapbox.mapboxsdk.maps.MapView) findViewById(R.id.mapview);
        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(this);
        startPaintRout = (ImageView) findViewById(R.id.start_paint_rout);
        startPaintRout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startDrawingRouting();
            }
        });
        isRouteMape = false;
        mType = getIntent().getStringExtra("type");
        trailId = getIntent().getStringExtra("trail_id");
        Util.isNetworkAvailable(this, getIntent().getBooleanExtra("isOffline", false));

//        isSavedTrail = getIntent().getBooleanExtra("isSavedTrail", false);
        isSavedTrail = isSavedTrails();
        trailName = (TextView) findViewById(R.id.trail_name);
        currentLocation = (RelativeLayout) findViewById(R.id.current_location);
        trailDetail = (LinearLayout) findViewById(R.id.maps_trail_detail);
        locatinCurrentTrail = (ImageView) findViewById(R.id.location_current_trail);
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(toolbar);
        appIcon = (ImageView) findViewById(R.id.toolbar_title_img);
        appIcon.setVisibility(View.VISIBLE);
        initDrawerLayout();
        initPlayButton();
        super.setNavigationLayoutWidht();

    }

    public void trailLayoutClick(View view) throws IOException {
        onBackPressed();
    }

    public void initToolbar(boolean isRouteMape) {

        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        toolbar.setContentInsetsAbsolute(0, 0);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        leftIconLayoutToolbar = (RelativeLayout) findViewById(R.id.toolbar_left_icon_layout);
        leftIconLayoutToolbar.setOnTouchListener(this);
        leftIconToolbar = (ImageView) findViewById(R.id.toolbar_left_icon);
        rightIconLayoutToolbar = (RelativeLayout) findViewById(R.id.toolbar_right_icon_layout);
        rightIconLayoutToolbar.setOnTouchListener(this);
        rightIconToolbar = (ImageView) findViewById(R.id.toolbar_right_icon);
        rightIconToolbar.setImageResource(R.mipmap.stack_trail);

        if (!isRouteMape) {
            leftIconToolbar.setImageResource(R.mipmap.hamburger_trails);
            TextView title = (TextView) findViewById(R.id.toolbar_title_text);

            if (isSavedTrail) {
                title.setVisibility(View.VISIBLE);
                title.setText(getResources().getString(R.string.saved_trails));
                appIcon.setVisibility(View.GONE);
            }

        } else {
            leftIconToolbar.setImageResource(R.mipmap.back_trails);
            showCurrentTrailRoute();
            appIcon.setVisibility(View.VISIBLE);
        }
    }

    public void locationTrailClick(View view) {
        getCurrentLocation();
    }

    public void getCurrentLocationClick(View view) {
        getCurrentLocation();
    }

    private void showCurrentTrailRoute() {
        if (!Util.isNetworkAvailable(this, false)) {
            try {
                if (getTrailById(initTrailData(), getIntent().getStringExtra("trail_id")) != null) {
                    showCurrentView(getTrailById(initTrailData(), getIntent().getStringExtra("trail_id")));

                }

            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        } else {
            showCurrentView(getTrailServicsManager().getmTrail());

        }

    }

    @Override
    protected void onResume() {
        super.onResume();
        mapView.onResume();
        getRequestResponse(trailId);

        try {
            if (loadCurrentRoute(this, KEY) != null) {
                currentRoute = loadCurrentRoute(this, KEY);
                if (currentRoute != null) {
                    if (!currentRoute.isEmpty())
                        addPolyline(currentRoute);
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

    }

    @Override
    protected void onStop() {
        super.onStop();

    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {

        switch (v.getId()) {
            case R.id.toolbar_left_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (!isRouteMape) {
                            if (drawerLayout != null) {
                                drawerLayout.openDrawer(Gravity.LEFT);
                            }
                        } else {
                            onBackPressed();
                        }
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.toolbar_right_icon_layout:
                setResult(ResultCodes.RESULT_CODE_HOME_OK);
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        onBackPressed();
                    }
                }).playOn(v, LONG_DURETION);
                break;
        }
        return false;
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();  // optional depending on your needs
        if (mType.startsWith(DrawRouteType.DrawFlags.name())) {
            HomeActivity.isFromMapACtivity = 1;
        }
        finish();
    }

    @Override
    public void onMapReady(MapboxMap mapboxMap) {
        this.mapboxMap = mapboxMap;

        isRouteMape = true;
        initToolbar(isRouteMape);
        IconFactory iconFactory = IconFactory.getInstance(MapsActivity.this);
        Drawable iconDrawable = ContextCompat.getDrawable(MapsActivity.this, R.mipmap.start_roout_icon);
        Icon icon = iconFactory.fromDrawable(iconDrawable);
        List<TrailRoute> list1 = null;
        if (!Util.isNetworkAvailable(this, false)) {
            try {
                if (getTrailById(initTrailData(), getIntent().getStringExtra("trail_id")) != null) {
                    list1 = getTrailById(initTrailData(), getIntent().getStringExtra("trail_id")).getTrailRoute();
                }
            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        } else {
            list1 = getTrailServicsManager().getmTrail().getTrailRoute();

        }

        if (list1 != null && !list1.isEmpty()) {
            PolylineOptions options = new PolylineOptions();
            points = new ArrayList<>();
            for (TrailRoute r : list1) {
                com.mapbox.mapboxsdk.geometry.LatLng l = new com.mapbox.mapboxsdk.geometry.LatLng(r.getLatitude(), r.getLongitude());
                options.add(l);
                points.add(l);
            }
            if (points.size() > 0) {

                mapboxMap.addMarker(new com.mapbox.mapboxsdk.annotations.MarkerOptions()
                        .icon(icon)
                        .position(new com.mapbox.mapboxsdk.geometry.LatLng(points.get(0).getLatitude(), points.get(0).getLongitude())));
                mapboxMap.addMarker(new com.mapbox.mapboxsdk.annotations.MarkerOptions()
                        .icon(icon)
                        .position(new com.mapbox.mapboxsdk.geometry.LatLng(points.get(points.size() - 1).getLatitude(), points.get(points.size() - 1).getLongitude())));

                mapboxMap.invalidate();

            }
            mapboxMap.addPolyline(
                    options.color(Color.parseColor("#427607")).width(3));

            com.mapbox.mapboxsdk.geometry.LatLngBounds latLngBounds = new com.mapbox.mapboxsdk.geometry.LatLngBounds.Builder()
                    .includes(points)
                    .build();

            mapboxMap.easeCamera(com.mapbox.mapboxsdk.camera.CameraUpdateFactory
                    .newLatLngBounds(latLngBounds, 110), 0);
//            }
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        mapView.onPause();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mapView.onLowMemory();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mapView.onDestroy();
        if (!getUserServiceManager().getUser().isGuest()) {
            if (!isRouteSended) {
                sendrequest(trailId);
                saveBoolean(ROUTING_KEY, false);
            }
        } else {
            if (currentRoute != null && !currentRoute.isEmpty()) {
                try {
                    saveCurrentRoute(this, KEY, currentRoute);
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
        }
        if (!isRouteSended && isRouting) {
            saveBoolean(ROUTING_KEY, true);

        } else {
            saveBoolean(ROUTING_KEY, false);

        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        mapView.onSaveInstanceState(outState);
    }

    private void getCurrentLocation() {
        gps = new GPSTracker(this);
        mapboxMap.setMyLocationEnabled(true);
        if (gps.canGetLocation()) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED) {
                mapboxMap.setMyLocationEnabled(true);
                com.mapbox.mapboxsdk.geometry.LatLng location = new com.mapbox.mapboxsdk.geometry.LatLng(gps.getLatitude(), gps.getLongitude());
                if (isRouteMape) {
                    points.add(location);
                    com.mapbox.mapboxsdk.geometry.LatLngBounds latLngBounds = new com.mapbox.mapboxsdk.geometry.LatLngBounds.Builder()
                            .includes(points)
                            .build();

                    mapboxMap.easeCamera(com.mapbox.mapboxsdk.camera.CameraUpdateFactory
                            .newLatLngBounds(latLngBounds, 110), 500);

                }
            }
        } else {
            UIUtil.showLocationSettingsAlert(this);
        }
    }


    private void showDialog() {
        if (!getBoolean(SAVED_BOOLEAN)) {
            final CustomAlertDialog dialog = UIUtil.routeAccesDialog(MapsActivity.this, "Start tracking your route", "", true);
            dialog.setmCallback(new CustomAlertDialog.Callback() {
                @Override
                public void onPositiveButtonChoosen() {
                    if (dialog.getCheckBox().isChecked()) {
                        saveBoolean(SAVED_BOOLEAN, true);
                    }
                }
            });
        }
    }

    private void startDrawingRouting() {

        gps = new GPSTracker(MapsActivity.this);

        if (gps.canGetLocation()) {
            if (!Util.isNetworkAvailable(this, false)) {
                UIUtil.alertDialogShow(MapsActivity.this, getApplicationContext().getString(R.string.error_dialog), getString(R.string.please_check_your_network_connectivity));
            } else {

                if (!isRouting) {
                    showDialog();
                    mapboxMap.setOnMyLocationChangeListener(MapsActivity.this);
                    currentRoute = new ArrayList<>();
                    startPaintRout.setImageDrawable(getResources().getDrawable(R.mipmap.stop_routing_trail));
                    isRouting = true;
                    mapboxMap.setMyLocationEnabled(true);
                    com.mapbox.mapboxsdk.geometry.LatLng location = new com.mapbox.mapboxsdk.geometry.LatLng(gps.getLatitude(), gps.getLongitude());
                    Log.d("location", location + "");
                    currentRoute.add(location);

                } else {
                    isRouting = false;
                    startPaintRout.setImageDrawable(getResources().getDrawable(R.mipmap.get_location_icon));
                    if (!getUserServiceManager().getUser().isGuest()) {
                        sendrequest(trailId);
                        saveBoolean(ROUTING_KEY, false);
                    } else {
                        Intent intentLogin = new Intent(MapsActivity.this, AuthActivity.class);
                        IntentUtils.getInstance().startActivityForResult(MapsActivity.this, 3, intentLogin, null, false);
                    }
                }
            }
        } else {
            UIUtil.showLocationSettingsAlert(this);
        }

    }

    @Override
    public void onMyLocationChange(@Nullable Location location) {
        com.mapbox.mapboxsdk.geometry.LatLng point = new com.mapbox.mapboxsdk.geometry.LatLng(location.getLatitude(), location.getLongitude());
        currentRoute.add(point);

        PolylineOptions options = new PolylineOptions();
        for (int i = 0; i < currentRoute.size(); i++) {
            options.add(currentRoute.get(i));
        }
        mapboxMap.addPolyline(options.color(Color.RED).width(3));
        mapboxMap.invalidate();

    }


    private List<TrailRoute> initTrailRoute() {
        List<TrailRoute> result = new ArrayList<>();
        if (currentRoute != null && !currentRoute.isEmpty()) {
            for (LatLng latlng : currentRoute) {
                result.add(new TrailRoute(latlng.getLatitude(), latlng.getLongitude()));

            }
        }

        return result;
    }

    private void sendrequest(String key) {
        getUserServiceManager().sendUserRoute(initTrailRoute(), Integer.parseInt(key), new NetworkRequestListener() {
            @Override
            public void onResponseReceive(Object obj) {
            }

            @Override
            public void onError(String message) {
            }
        });
        isRouteSended = true;
    }

    private List<TrailRoute> getRequestResponse(String trailId) {
        final List<TrailRoute> list = new ArrayList<>();
        getUserServiceManager().getUserRoute(Integer.parseInt(trailId), new NetworkRequestListener() {
            @Override
            public void onResponseReceive(Object obj) {
                try {
                    if (obj != null) {
                        JSONObject jsonObject = new JSONObject(((Response) obj).result.toString());
                        JSONArray arr = jsonObject.getJSONArray("location");
                        if (arr != null) {
                            for (int i = 0; i < arr.length(); i++) {
                                list.add(new TrailRoute(arr.getJSONObject(i).getDouble("latitude"), arr.getJSONObject(i).getDouble("longitude")));
                            }
                            if (list != null && !list.isEmpty()) {
                                addPolyline(initUserSavedRout(list));
                            }
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onError(String message) {

            }
        });
        return list;
    }

    private List<LatLng> initUserSavedRout(List<TrailRoute> list) {
        List<LatLng> result = new ArrayList<>();
        if (list != null && !list.isEmpty()) {
            for (TrailRoute trail : list) {
                result.add(new LatLng(trail.getLatitude(), trail.getLongitude()));
            }
            return result;
        }

        return null;
    }

    private void saveCurrentRoute(Context context, String key, List<LatLng> route) throws IOException {
        FileOutputStream fos = context.openFileOutput(key, Context.MODE_PRIVATE);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(route);
        oos.close();
        fos.close();
    }

    private boolean deleteCurrentRoute() {
        return new File(getFilesDir() + "/" + KEY).delete();
    }

    private List<LatLng> loadCurrentRoute(Context context, String key) throws IOException, ClassNotFoundException {
        FileInputStream fis = context.openFileInput(key);
        ObjectInputStream ois = new ObjectInputStream(fis);
        return (List<LatLng>) ois.readObject();
    }

    private void addPolyline(List<LatLng> list) {
        PolylineOptions options = new PolylineOptions();
        options.addAll(list);
        mapboxMap.addPolyline(options.color(Color.RED).width(3));
        mapboxMap.invalidate();
    }

    private void saveBoolean(String key, boolean istrue) {
        sharedPreferences = getSharedPreferences(key, MODE_PRIVATE);
        SharedPreferences.Editor ed = sharedPreferences.edit();
        ed.putBoolean(key, istrue);
        ed.commit();
    }

    private boolean getBoolean(String key) {
        sharedPreferences = getSharedPreferences(key, MODE_PRIVATE);
        return sharedPreferences.getBoolean(key, false);
    }

    public enum DrawRouteType {DrawRoute, DrawFlags}

    private void initPlayButton() {

        if (getBoolean(ROUTING_KEY)) {
            startPaintRout.setImageDrawable(getResources().getDrawable(R.mipmap.stop_routing_trail));
            isRouting = true;
        }
    }

    private void showCurrentView(Trail trail) {
        trailDetail.setVisibility(View.VISIBLE);
        currentLocation.setVisibility(View.GONE);
        trailName.setText(trail.getTrailName());
        int width = Util.getDisplayWidth(this);
        trailName.setWidth((int) (Util.getDisplayWidth(this) * 0.8));
        TextView currentTrailDifficulty = (TextView) findViewById(R.id.size);
        currentTrailDifficulty.setText(trail.getTrailDifficulty());

        RelativeLayout ratingBar = (RelativeLayout) findViewById(R.id.rating_bar);
        RatingBar mRatingBar = new RatingBar(this, ratingBar);
        mRatingBar.getParams(((int) (width * 0.04)), ((int) (width * 0.04)), trail.getAverageRating(), true);
    }

    private List<Trail> initTrailData() throws IOException, ClassNotFoundException {
        List<Trail> trails = laodTrailFile(this, TrailDetailActivity.KEY);
        return trails;
    }


    private Trail getTrailById(List<Trail> trails, String trailId) {
        if (trails != null && !trails.isEmpty()) {
            for (Trail trail : trails) {
                if (trailId.equals("" + trail.getTrailId())) {
                    return trail;
                }
            }
        }
        return null;
    }


}
