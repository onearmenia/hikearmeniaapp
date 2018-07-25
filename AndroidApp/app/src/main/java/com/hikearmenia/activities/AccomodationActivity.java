package com.hikearmenia.activities;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.Toolbar;
import android.view.MotionEvent;
import android.view.View;
import android.webkit.URLUtil;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;

import com.hikearmenia.R;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.models.api.Accomodation;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.SlidingActivity;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.mapbox.mapboxsdk.MapboxAccountManager;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.nineoldandroids.animation.Animator;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.io.IOException;
import java.util.List;

import static com.hikearmenia.activities.TrailDetailActivity.laodTrailFile;

public class AccomodationActivity extends SlidingActivity implements View.OnTouchListener, com.mapbox.mapboxsdk.maps.OnMapReadyCallback {

    private Accomodation mAccomodation;
    MapboxMap mapboxMap;
    MapView mapView;

    public static void initImageLoader(Context context) {
        ImageLoaderConfiguration.Builder config = new ImageLoaderConfiguration.Builder(context);
        config.threadPriority(Thread.NORM_PRIORITY - 2);
        config.denyCacheImageMultipleSizesInMemory();
        config.diskCacheFileNameGenerator(new Md5FileNameGenerator());
        config.diskCacheSize(50 * 1024 * 1024); // 50 MiB
        config.tasksProcessingOrder(QueueProcessingType.LIFO);
        config.writeDebugLogs(); // Remove for release app
        // Initialize ImageLoader with configuration.
        com.nostra13.universalimageloader.core.ImageLoader.getInstance().init(config.build());
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_accomodation);
        ((ScrollView) findViewById(R.id.scroll)).post(new Runnable() {
            public void run() {
                ((ScrollView) findViewById(R.id.scroll)).scrollTo(0, 0);
            }
        });

        initView();
        mapView.onCreate(savedInstanceState);

        initImageLoader(this);
        initToolbar();
    }


    @Override
    protected void onResume() {
        super.onResume();
        mapView.onResume();
        ((ScrollView) findViewById(R.id.scroll)).post(new Runnable() {
            public void run() {
                ((ScrollView) findViewById(R.id.scroll)).scrollTo(0, 0);
            }
        });

    }

    private void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        getSupportActionBar().setHomeButtonEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        getSupportActionBar().setDisplayHomeAsUpEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        getSupportActionBar().setDisplayShowCustomEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        toolbar.setContentInsetsAbsolute(0, 0);
        ImageView leftIconToolbar = (ImageView) findViewById(R.id.home);
        leftIconToolbar.setImageResource(R.mipmap.back_trails);
        RelativeLayout leftIconLayoutToolbar = (RelativeLayout) findViewById(R.id.home_icon);
        leftIconLayoutToolbar.setOnTouchListener(this);
        ImageView rightIconToolbar = (ImageView) findViewById(R.id.home_screen);
        rightIconToolbar.setVisibility(View.VISIBLE);
        rightIconToolbar.setOnTouchListener(this);
        TextView saveBtn = (TextView) findViewById(R.id.save);
        saveBtn.setVisibility(View.GONE);
    }


    @Override
    public boolean onTouch(View v, MotionEvent event) {


        switch (v.getId()) {
            case R.id.home_icon:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        onBackPressed();
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.home_screen:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        setResult(ResultCodes.RESULT_CODE_HOME_OK);
                        Intent homeIntent = new Intent(AccomodationActivity.this, HomeActivity.class);
                        startActivity(homeIntent);
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.call_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        Intent intent = new Intent(Intent.ACTION_DIAL);
                        intent.setData(Uri.parse("tel:" + mAccomodation.getAccomodationPhone()));
                        startActivity(intent);
                    }
                }).playOn(v, STANDART_DURETION);
                break;
            case R.id.web_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(mAccomodation.getAccomodationUrl()));
                        startActivity(browserIntent);
                    }
                }).playOn(v, STANDART_DURETION);

                break;
            case R.id.email_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        Intent emailIntent = new Intent(Intent.ACTION_SENDTO, Uri.fromParts(
                                "mailto", mAccomodation.getAccomodationEmail(), null));
                        emailIntent.putExtra(Intent.EXTRA_SUBJECT, mAccomodation.getAccomodationName());
                        try {
                            startActivity(Intent.createChooser(emailIntent, "Send email..."));
                        } catch (Exception e) {
                            UIUtil.alertDialogShow(AccomodationActivity.this, getString(R.string.could_not_send_email), getString(R.string.could_not_send_email_message));
                        }

                    }
                }).playOn(v, STANDART_DURETION);
                break;
        }
        return false;
    }

    private void initView() {
        final LinearLayout mapContainer = (LinearLayout) findViewById(R.id.map_container);
        mapView = (MapView) findViewById(R.id.map_image);
        MapboxAccountManager.start(this, getString(R.string.accessToken));
        mapView.getLayoutParams().height = (int) (Util.getDisplayWidth(this) / 1.4);
        if (!Util.isNetworkAvailable(this, false)) {
            try {
                if (getTrailById(initTrailData(), getIntent().getStringExtra("trail_Id")) != null)
                    mAccomodation = getTrailById(initTrailData(), getIntent().getStringExtra("trail_Id")).getAccomodations().get(getIntent().getIntExtra("position", 0));

            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        } else {
            mAccomodation = getTrailServicsManager().getmTrail().getAccomodations().get(getIntent().getIntExtra("position", 0));

        }
        TextView facilitieText = (TextView) findViewById(R.id.zip);
        EditText toolbarTitle = (EditText) findViewById(R.id.toolbar_title);


        mapView.getMapAsync(this);

        if (mAccomodation != null) {
            TextView accomodationPrice = (TextView) findViewById(R.id.accomodation_price);
            TextView descriptionText = (TextView) findViewById(R.id.description_text);
            RelativeLayout accomodationLayout = (RelativeLayout) findViewById(R.id.accomodation_layout);
            accomodationLayout.getLayoutParams().height = (int) (Util.getDisplayHeight(this) * 0.36);
            ImageView accomodationImg = (ImageView) findViewById(R.id.accomodation);
            LinearLayout callLayout = (LinearLayout) findViewById(R.id.call_layout);
            LinearLayout webLayout = (LinearLayout) findViewById(R.id.web_layout);
            LinearLayout emailLayout = (LinearLayout) findViewById(R.id.email_layout);
            facilitieText.setText(mAccomodation.getAccomodationFacilities());
            descriptionText.setText(mAccomodation.getAccomodationDescription());
            accomodationPrice.setText(mAccomodation.getAccomodationPrice());
            ImageView callIcon = (ImageView) findViewById(R.id.call_icon);
            ImageView webIcon = (ImageView) findViewById(R.id.web_icon);
            ImageView mailIcon = (ImageView) findViewById(R.id.email_icon);
            TextView mailText = (TextView) findViewById(R.id.email_text);
            TextView callText = (TextView) findViewById(R.id.call_text);
            TextView webText = (TextView) findViewById(R.id.web_text);
            if (mAccomodation.getAccomodationName() != null) {
                toolbarTitle.setText(mAccomodation.getAccomodationName());
            }

            if (mAccomodation.getAccomodationCover() != null) {

                DisplayImageOptions mOptions = new DisplayImageOptions.Builder()
                        .cacheInMemory(true)
                        .cacheOnDisk(true)
                        .showImageForEmptyUri(R.mipmap.placeholder)
                        .showImageOnLoading(R.mipmap.placeholder)
                        .showImageOnFail(R.mipmap.placeholder)
                        .imageScaleType(ImageScaleType.NONE)
                        .bitmapConfig(Bitmap.Config.RGB_565)
                        .build();

                com.nostra13.universalimageloader.core.ImageLoader.getInstance().displayImage(mAccomodation.getAccomodationCover(),
                        accomodationImg, mOptions, new ImageLoadingListener() {
                            @Override
                            public void onLoadingStarted(String imageUri, View view) {

                            }

                            @Override
                            public void onLoadingFailed(String imageUri, View view, FailReason failReason) {
                                mapContainer.setVisibility(View.VISIBLE);

                            }

                            @Override
                            public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {

                                mapContainer.setVisibility(View.VISIBLE);

                            }

                            @Override
                            public void onLoadingCancelled(String imageUri, View view) {
                                mapContainer.setVisibility(View.VISIBLE);

                            }
                        });


            }
//            ScaleAnimation animation = new ScaleAnimation(1.2f, 1.0f, 1.2f, 1.0f);//Animation.RELATIVE_TO_PARENT, (float) (imageView.getX() + 45 * ssu) / width, Animation.RELATIVE_TO_PARENT, (float) (imageView.getY() + 45 * ssu) / (4 * height));
//            animation.setDuration(500);
//            accomodationImg.setAnimation(animation);
            if (mAccomodation.getAccomodationUrl() != null) {
                if (!URLUtil.isValidUrl(mAccomodation.getAccomodationUrl())) {
                    webIcon.setAlpha(0.5f);
                    webText.setAlpha(0.5f);
                } else {
                    webLayout.setOnTouchListener(this);
                }
            }
            if (mAccomodation.getAccomodationPhone() != null) {
                if (mAccomodation.getAccomodationPhone().isEmpty()) {
                    callIcon.setAlpha(0.5f);
                    callText.setAlpha(0.5f);
                } else {
                    callLayout.setOnTouchListener(this);
                }
            }
            if (mAccomodation.getAccomodationEmail() != null) {
                if (mAccomodation.getAccomodationEmail().isEmpty()) {
                    mailIcon.setAlpha(0.5f);
                    mailText.setAlpha(0.5f);
                } else {
                    emailLayout.setOnTouchListener(this);
                }
            }
        }

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

    @Override
    public void onMapReady(MapboxMap mapboxMap) {
        this.mapboxMap = mapboxMap;
        double lat = 0;
        double lng = 0;
        if (!mAccomodation.getAccommodationLat().equals("")) {
            lat = Double.parseDouble(mAccomodation.getAccommodationLat());
        }
        if (!mAccomodation.getAccommodationLong().equals("")) {
            lng = Double.parseDouble(mAccomodation.getAccommodationLong());

        }
        com.mapbox.mapboxsdk.geometry.LatLng mapLatLng = new com.mapbox.mapboxsdk.geometry.LatLng(lat, lng);
        IconFactory iconFactory = IconFactory.getInstance(this);
        Drawable iconDrawable = ContextCompat.getDrawable(this, R.mipmap.start_roout_icon);
        Icon icon = iconFactory.fromDrawable(iconDrawable);
        mapboxMap.invalidate();

        if (mapLatLng.getLatitude() != 0 && mapLatLng.getLongitude() != 0) {
            mapboxMap.addMarker(new com.mapbox.mapboxsdk.annotations.MarkerOptions()
                    .icon(icon)
                    .position(mapLatLng));
            mapboxMap.easeCamera(com.mapbox.mapboxsdk.camera.CameraUpdateFactory
                    .newLatLngZoom(mapLatLng, 10), 0);
        } else {
            mapLatLng = new com.mapbox.mapboxsdk.geometry.LatLng(40.1792, 44.4991);
            mapboxMap.easeCamera(com.mapbox.mapboxsdk.camera.CameraUpdateFactory
                    .newLatLngZoom(mapLatLng, 6), 0);
        }
        mapboxMap.setInfoWindowAdapter(new MapboxMap.InfoWindowAdapter() {
            @Nullable
            @Override
            public View getInfoWindow(@NonNull final com.mapbox.mapboxsdk.annotations.Marker marker) {
                View customMarker = getLayoutInflater().inflate(R.layout.acc_info_window, null);
                android.widget.TextView accName = (android.widget.TextView) customMarker.findViewById(R.id.map_acc_name);
                accName.setText(mAccomodation.getAccomodationName());
                return customMarker;
            }
        });

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
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        mapView.onSaveInstanceState(outState);
    }
}
