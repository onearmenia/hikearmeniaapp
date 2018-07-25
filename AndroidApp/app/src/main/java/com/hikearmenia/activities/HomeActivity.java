package com.hikearmenia.activities;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityOptionsCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.util.Pair;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.adapters.SavedTrailsAdapter;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.fragment.LeftSlideMenu;
import com.hikearmenia.listener.LeftSlideMenuOnItemClickListener;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Direction;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.ActivitySwitcher;
import com.hikearmenia.util.GPSTracker;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.SlidingActivity;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.mapbox.mapboxsdk.MapboxAccountManager;
import com.mapbox.mapboxsdk.annotations.Icon;
import com.mapbox.mapboxsdk.annotations.IconFactory;
import com.mapbox.mapboxsdk.camera.CameraPosition;
import com.mapbox.mapboxsdk.camera.CameraUpdateFactory;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.location.LocationServices;
import com.mapbox.mapboxsdk.maps.MapView;
import com.mapbox.mapboxsdk.maps.MapboxMap;
import com.mapbox.mapboxsdk.maps.OnMapReadyCallback;
import com.nineoldandroids.animation.Animator;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.hikearmenia.activities.TrailDetailActivity.KEY;
import static com.hikearmenia.activities.TrailDetailActivity.laodTrailFile;

/**
 * Created by Ani Karapetyan on 4/20/16.
 */

public class HomeActivity extends BaseActivity implements NetworkRequestListener, View.OnTouchListener, OnMapReadyCallback {
    public static int isFromMapACtivity = 0;
    ActivityOptionsCompat options;
    Pair<View, String> imagePair;
    ImageView bottomMenuRightIcon;
    ImageView emptySavedTrailsLayout;
    TextView toolbarTitleText;
    ImageView toolbarTitleImg;
    TextView emptyListText;
    //    List<Direction> directionList;
    /*toolbar views*/
    RelativeLayout leftIconLayoutToolbar;
    ImageView leftIconToolbar;
    RelativeLayout rightIconLayoutToolbar;
    ImageView rightIconToolbar;
    RelativeLayout currentLocation;
    RelativeLayout mapScreen;
    MapView mapView;
    MapboxMap mapboxMap;
    List<com.mapbox.mapboxsdk.geometry.LatLng> points;
    LocationServices locationServices;
    private com.yayandroid.parallaxrecyclerview.ParallaxRecyclerView recyclerViewTrails;
    private RecyclerView.LayoutManager mLayoutManager;
    private SavedTrailsAdapter mAdapter;
    private TextView bottomMenuRightTV;
    /*MAP SCREEN*/
    private SwipeRefreshLayout swipeContainer;
    private boolean isMapScreenVisible = false;
    private boolean isOfflineMode;
    SavedTrailsAdapter.OnItemClickListener savedOnclickListener = new SavedTrailsAdapter.OnItemClickListener() {
        @Override
        public void onItemClick(View view, List<Trail> trailList, int position, Trail trail) {
            if (Util.isNetworkAvailable(HomeActivity.this, true) || isOfflineMode) {

                Intent intent = new Intent(HomeActivity.this, TrailDetailActivity.class);
                intent.putExtra("trail_id", String.valueOf(getTrailServicsManager().filterSavedTrails().get(position).getTrailId()));
                intent.putExtra("trail_first_img_url", String.valueOf(trail.getTrailCover()));
//                }
                imagePair = Pair.create(view, "tImage");
                options = ActivityOptionsCompat.makeSceneTransitionAnimation(HomeActivity.this, imagePair);
                IntentUtils.getInstance().startActivityForResult(HomeActivity.this, 2, intent, options, false);
            }

        }
    };

    SavedTrailsAdapter.OnItemClickListener allTrailsClickListener = new SavedTrailsAdapter.OnItemClickListener() {

        @Override
        public void onItemClick(View view, List<Trail> trailList, int position, Trail trail) {
            if (isOfflineMode || Util.isNetworkAvailable(HomeActivity.this, true)) {
                Intent intent = new Intent(HomeActivity.this, TrailDetailActivity.class);
                intent.putExtra("trail_id", String.valueOf(trail.getTrailId()));
                intent.putExtra("trail_first_img_url", String.valueOf(trail.getTrailCover()));
                imagePair = Pair.create(view, "tImage");
                options = ActivityOptionsCompat.makeSceneTransitionAnimation(HomeActivity.this,
                        imagePair);
                IntentUtils.getInstance().startActivityForResult(HomeActivity.this, 2, intent, options, false);
            } else if (trailList != null) {
                if (!Util.isNetworkAvailable(HomeActivity.this, false)) {
                    if (TrailDetailActivity.offlineTrails != null)
                        for (int i = 0; i < TrailDetailActivity.offlineTrails.size(); i++) {
                            if (trail != null && TrailDetailActivity.offlineTrails.get(i) != null)
                                if (trail.getTrailId() == TrailDetailActivity.offlineTrails.get(i).getTrailId()) {
                                    trail = TrailDetailActivity.offlineTrails.get(i);
                                    Intent intent = new Intent(HomeActivity.this, TrailDetailActivity.class);
                                    intent.putExtra("trail_id", String.valueOf(trail.getTrailId()));
                                    intent.putExtra("trail_first_img_url", String.valueOf(trail.getTrailCover()));
                                    imagePair = Pair.create(view, "tImage");
                                    options = ActivityOptionsCompat.makeSceneTransitionAnimation(HomeActivity.this,
                                            imagePair);
                                    IntentUtils.getInstance().startActivityForResult(HomeActivity.this, 2, intent, options, false);

                                }
                        }
                }
            }

        }
    };
    private boolean isSavedOn;
    private FrameLayout homeContent;
    private GPSTracker gps;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize the SDK before executing any other operations,
        MapboxAccountManager.start(this, getString(R.string.accessToken));

        setContentView(R.layout.activity_home);
        locationServices = LocationServices.getLocationServices(HomeActivity.this);
        mapView = (MapView) findViewById(R.id.mapview);
        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(this);
        mapScreen = (RelativeLayout) findViewById(R.id.map_screen);
        mapScreen.setVisibility(View.GONE);

        homeContent = (FrameLayout) findViewById(R.id.home_content);
        initDrawerLayout();
        getTrailServicsManager().getListOfTrails(this);
        initToolbar();
        // savedTrails(false);
        Util.isNetworkAvailable(this, true);
        emptyListText = (TextView) findViewById(R.id.does_not_have_saved_trails);

        recyclerViewTrails = (com.yayandroid.parallaxrecyclerview.ParallaxRecyclerView) findViewById(R.id.recycler_saved_trails);
        mAdapter = new SavedTrailsAdapter(this, new ArrayList<Trail>(), false);
        recyclerViewTrails.setAdapter(mAdapter);
        mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        savedTrails(false);
        isSavedTrails = isSavedTrails();
        toolbarTitleImg = (ImageView) findViewById(R.id.toolbar_title_img);
        toolbarTitleText = (TextView) findViewById(R.id.toolbar_title_text);
        emptySavedTrailsLayout = (ImageView) findViewById(R.id.empty_saved_trails_layout);
        LinearLayout findLocalGuides = (LinearLayout) findViewById(R.id.find_local_guides);
        findLocalGuides.setOnTouchListener(this);
        bottomMenuRightIcon = (ImageView) findViewById(R.id.bottom_menu_right_icon);
        bottomMenuRightTV = (TextView) findViewById(R.id.bottom_menu_right_text);
        LinearLayout savedTrailes = (LinearLayout) findViewById(R.id.bottom_bar_saved_trails);
        savedTrailes.setOnTouchListener(this);
        LinearLayout takePhoto = (LinearLayout) findViewById(R.id.bottom_menu_take_photo);
        takePhoto.setOnTouchListener(this);
        recyclerViewTrails.setLayoutManager(mLayoutManager);
        currentLocation = (RelativeLayout) findViewById(R.id.current_location);
        currentLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showUserLocation();
            }
        });
        setStatusBarColor();

        super.setNavigationLayoutWidht();

        if (handleOfflineFromMapScreen()) {
            showOfflineTrails();
        }
        swipeContainer = (SwipeRefreshLayout) findViewById(R.id.swipeContainer);
        // Setup refresh listener which triggers new data loading
        swipeContainer.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                // Your code to refresh the list here.
                // Make sure you call swipeContainer.setRefreshing(false)
                // once the network request has completed successfully.
                if (Util.isNetworkAvailable(HomeActivity.this, true) && !isOfflineMode) {

                    fetchTimelineAsync();
                } else {

                    swipeContainer.setRefreshing(false);

                }
            }
        });
        // Configure the refreshing colors
        swipeContainer.setColorSchemeResources(android.R.color.holo_green_light);

    }

    private void initToolbar() {
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
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.toolbar_menu, menu);

        MenuItem item = menu.findItem(R.id.toolbar_menu_item);
        item.setIcon(R.mipmap.map_trails);
        item.setVisible(false);
        return true;
    }

    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
        mapView.onPause();
    }

    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {

            case android.R.id.home:
                drawerLayout.openDrawer(Gravity.LEFT);
                return true;
            case R.id.toolbar_menu_item:
                final Intent map = new Intent(getApplicationContext(), MapsActivity.class);
                map.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
                map.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                ActivitySwitcher.animationOut(findViewById(R.id.root_content), getWindowManager(), new ActivitySwitcher.AnimationFinishedListener() {
                    @Override
                    public void onAnimationFinished() {
                        map.putExtra("type", MapsActivity.DrawRouteType.DrawFlags.name());
                        startActivityForResult(map, 2);
                    }
                });
                return true;
            default:
                return false;
        }
    }

    private void setStatusBarColor() {
       /* if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(getResources().getColor(R.color.status_bar_green_color));
        }*/
    }

    @Override
    public void onResponseReceive(Object obj) {
        final List<Trail> trailsList = (ArrayList<Trail>) obj;
        if (getIntent().hasExtra("map") && getIntent().getStringExtra("map") != null) {
            if (getIntent().getStringExtra("map").equals("save")) {
                showSavedTrails();

            }
        } else if (!handleOfflineFromMapScreen()) {
            showAllTrails();
        }
    }

    @Override
    public void onError(String message) {

    }

    public void setIconToSavedTrails(boolean savedTrails) {
        if (savedTrails) {
            bottomMenuRightTV.setText(getString(R.string.favorite_trails));
            bottomMenuRightIcon.setImageResource(R.mipmap.saved_trails_menu);
        } else {
            bottomMenuRightTV.setText(getString(R.string.all_trails));
            bottomMenuRightIcon.setImageResource(R.mipmap.all_menu);
        }
    }

    public void showAllTrails() {
        toolbarTitleText.setVisibility(View.GONE);
        toolbarTitleImg.setVisibility(View.VISIBLE);
        emptyListText.setVisibility(View.GONE);
        mAdapter.setOnItemClickListener(allTrailsClickListener);
        mAdapter.swap(getTrailServicsManager().getTrailsList(), false);
        setIconToSavedTrails(true);
        isSavedOn = false;
        savedTrails(false);
        isSavedTrails = isSavedTrails();

        emptySavedTrailsLayout.setVisibility(View.GONE);
        emptyListText.setVisibility(View.GONE);

        recyclerViewTrails.setVisibility(View.VISIBLE);
        if (isMapScreenVisible) {
            showTrailListScreen();
        }

    }

    public void showSavedTrails() {
        setIconToSavedTrails(false);
        savedTrails(true);
        isOfflineMode = false;
        isSavedOn = true;
        isSavedTrails = isSavedTrails();
        toolbarTitleText.setText(getResources().getString(R.string.saved_trails));
        toolbarTitleText.setVisibility(View.VISIBLE);
        toolbarTitleImg.setVisibility(View.GONE);
        if (getTrailServicsManager().filterSavedTrails().size() == 0) {
            emptySavedTrailsLayout.setVisibility(View.VISIBLE);
            emptyListText.setVisibility(View.VISIBLE);
            recyclerViewTrails.setVisibility(View.GONE);
        } else {
            mAdapter.setOnItemClickListener(savedOnclickListener);
            mAdapter.swap(getTrailServicsManager().filterSavedTrails(), true);
            emptySavedTrailsLayout.setVisibility(View.GONE);
            emptyListText.setVisibility(View.GONE);
            recyclerViewTrails.setVisibility(View.VISIBLE);
        }
        if (isMapScreenVisible) {
            showTrailListScreen();
        }
        if (getTrailServicsManager().filterSavedTrails().isEmpty()) {
            showEmptyText(false);
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (homeContent.getVisibility() == View.GONE) {
            rightIconToolbar.setImageResource(R.mipmap.map_trails);
            mapScreen.setVisibility(View.GONE);
            homeContent.setVisibility(View.VISIBLE);
        }

        switch (resultCode) {
            case ResultCodes.SAVED_TRAIL_CODE:
                showSavedTrails();
                break;
            case ResultCodes.RESULT_CODE_ALL_TRAIL:
                showAllTrails();
                break;
            case ResultCodes.RESULT_CODE_IGNORE:
                break;

            default:
                isSavedTrails = isSavedTrails();
                if (isSavedTrails) {
                    showSavedTrails();
                } else {
                    showAllTrails();
                }
        }
        drawerLayout.closeDrawers();
        isNavBarOpened = false;

    }

    @Override
    protected void onResume() {
        super.onResume();
        mapView.onResume();
        SlidingActivity.resultCode = ResultCodes.RESULT_CODE_IGNORE;
        isSavedTrails = isSavedTrails();
        HikeArmeniaApplication.setCurrentActivity(this);
        drawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        leftSlideMenu = LeftSlideMenu.newInstance(this, drawerLayout, this);
        LeftSlideMenu.setmLeftSlideMenuOnItemClickListener(new LeftSlideMenuOnItemClickListener() {
            @Override
            public void getSelectedItem(LeftSlideItems anEnum) {
                switch (anEnum) {
                    case OFFLINE_TRAILS:
                        showOfflineTrails();
                        isOfflineMode = true;
                        break;
                    case ALL_TRAILS:
                        showAllTrails();
                        isOfflineMode = false;
                        break;
                    case SAVED_TRAILS:
                        showSavedTrails();
                        break;
                }
            }
        });
        if (isOfflineMode) {
            showOfflineTrails();
        }

        drawerLayout.closeDrawers();

        android.support.v4.app.FragmentTransaction fragmentTransaction = getSupportFragmentManager().beginTransaction();
        fragmentTransaction.replace(R.id.nav_view, leftSlideMenu);
        fragmentTransaction.commit();
        Log.d("log", "home  onReaume");

    }

    @Override
    public void closeDrawer() {
        // drawerLayout.closeDrawer(Gravity.LEFT);
    }

    public void updateData(List<Trail> updatetrailsList) {
        mAdapter.swap(updatetrailsList);

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mapView.onDestroy();
        IntentUtils.getInstance().clear();
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (v.getId()) {
            case R.id.find_local_guides:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(HomeActivity.this, true)) {

                            Intent intent = new Intent(HomeActivity.this, FindLocalGuidesActivitiy.class);
                            startActivityForResult(intent, 2);
                        }
                    }
                }).playOn(v, STANDART_DURETION);
                break;
            case R.id.bottom_bar_saved_trails:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(HomeActivity.this, true)) {

                            if (getUserServiceManager().getUser() != null && getUserServiceManager().getUser().isGuest()) {
                                Intent i = new Intent(HomeActivity.this, AuthActivity.class);
                                IntentUtils.getInstance().startActivityForResult(HomeActivity.this, 2, i, null, false);
                            } else {
                                toolbarTitleText.setVisibility(View.VISIBLE);
                                toolbarTitleText.setText(getResources().getString(R.string.saved_trails));
                                if (!isSavedTrails) {
                                    setIconToSavedTrails(false);
                                    savedTrails(true);
                                    showSavedTrails();
                                    isSavedTrails = isSavedTrails();
                                } else {
                                    setIconToSavedTrails(true);
                                    showAllTrails();
                                    savedTrails(false);
                                    isSavedTrails = isSavedTrails();
                                }
                            }
                        }
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.bottom_menu_take_photo:
                Intent intent = new Intent(this, TakePhotoActivity.class);
                startActivity(intent);

                break;
            case R.id.toolbar_left_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        isNavBarOpened = true;
                        drawerLayout.openDrawer(Gravity.LEFT);
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.toolbar_right_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (isMapScreenVisible) {
                            showTrailListScreen();
                        } else {
                            showMapScreen();
                            updateMapScreen();
                        }
                    }
                }).playOn(v, LONG_DURETION);
//                mapScreen.setVisibility(View.VISIBLE);

                break;
        }
        return false;
    }

    private void showTrailListScreen() {
        isMapScreenVisible = false;
        Animation anim = AnimationUtils.loadAnimation(this, R.anim.to_visible);
        anim.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                if (isOfflineMode) {
                    toolbarTitleText.setVisibility(View.VISIBLE);
                    toolbarTitleImg.setVisibility(View.GONE);
                }

            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        homeContent.startAnimation(anim);

        ActivitySwitcher.animationOutRigth(findViewById(R.id.root_content), getWindowManager(), new ActivitySwitcher.AnimationFinishedListener() {
            @Override
            public void onAnimationFinished() {

                mapScreen.setVisibility(View.GONE);
                homeContent.setVisibility(View.VISIBLE);

                ActivitySwitcher.animationOnBAck(findViewById(R.id.root_content), getWindowManager(), new ActivitySwitcher.AnimationFinishedListener() {
                    @Override
                    public void onAnimationFinished() {
                        if (emptyListText.getVisibility() != View.VISIBLE) {
                            recyclerViewTrails.setVisibility(View.VISIBLE);
                        }
                    }
                });
                rightIconToolbar.setImageResource(R.mipmap.map_trails);
            }
        });
    }

    private void showMapScreen() {
        isMapScreenVisible = true;
        Util.isNetworkAvailable(this, isOfflineMode);
        recyclerViewTrails.setVisibility(View.GONE);
        Animation anim = AnimationUtils.loadAnimation(this, R.anim.to_gone);
        anim.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                mapScreen.setVisibility(View.VISIBLE);
                if (isOfflineMode) {
                    toolbarTitleText.setVisibility(View.GONE);
                    toolbarTitleImg.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        homeContent.startAnimation(anim);
        ActivitySwitcher.animationOutRigth(findViewById(R.id.root_content), getWindowManager(), new ActivitySwitcher.AnimationFinishedListener() {
            @Override
            public void onAnimationFinished() {
                rightIconToolbar.setImageResource(R.mipmap.stack_trail);
                homeContent.setVisibility(View.GONE);
                ActivitySwitcher.animationOnBAck(findViewById(R.id.root_content), getWindowManager(), new ActivitySwitcher.AnimationFinishedListener() {
                    @Override
                    public void onAnimationFinished() {
                    }
                });
            }
        });
    }

    private void startTrailActivity(com.mapbox.mapboxsdk.annotations.Marker marker) {
        Intent intent = new Intent(HomeActivity.this, TrailDetailActivity.class);
        intent.putExtra("trail_first_img_url", String.valueOf(getTrailServicsManager().getCurrentTrail(marker.getTitle()).getTrailCover()));
        IntentUtils.getInstance().startActivity(HomeActivity.this, intent);
        intent.putExtra("trail_id", String.valueOf(getTrailServicsManager().getCurrentTrail(marker.getTitle()).getTrailId()));
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mapView.onLowMemory();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        mapView.onSaveInstanceState(outState);
    }

    @Override
    public void onMapReady(MapboxMap mapboxMap) {
        this.mapboxMap = mapboxMap;
        drawMarkers();
    }

    private void showUserLocation() {
        gps = new GPSTracker(HomeActivity.this);
        mapboxMap.setMyLocationEnabled(true);
        if (gps.canGetLocation()) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED) {
                mapboxMap.setMyLocationEnabled(true);
                com.mapbox.mapboxsdk.geometry.LatLng location = new com.mapbox.mapboxsdk.geometry.LatLng(gps.getLatitude(), gps.getLongitude());
                IconFactory iconFactory = IconFactory.getInstance(HomeActivity.this);
                Drawable iconDrawable = ContextCompat.getDrawable(HomeActivity.this, R.drawable.empty);
                Icon icon = iconFactory.fromDrawable(iconDrawable);
                points.add(location);
                mapboxMap.addMarker(new com.mapbox.mapboxsdk.annotations.MarkerOptions()
                        .icon(icon)
                        .position(location)

                );
                if (points.size() == 1) {
                    points.add(new LatLng(location.getLongitude() + 0.1, location.getLatitude() + 0.1));
                }
                com.mapbox.mapboxsdk.geometry.LatLngBounds latLngBounds = new com.mapbox.mapboxsdk.geometry.LatLngBounds.Builder()
                        .includes(points)
                        .build();

                mapboxMap.easeCamera(CameraUpdateFactory
                        .newLatLngBounds(latLngBounds, 110), 500);
            }

        } else {
            UIUtil.showLocationSettingsAlert(this);
        }
    }

    private void showOfflineTrails() {
        toolbarTitleText.setVisibility(View.VISIBLE);
        toolbarTitleImg.setVisibility(View.GONE);
        toolbarTitleText.setText(getResources().getString(R.string.offline_trails));
        emptySavedTrailsLayout.setVisibility(View.GONE);
        isSavedOn = false;

        mAdapter.setOnItemClickListener(allTrailsClickListener);
        emptySavedTrailsLayout.setVisibility(View.GONE);
        recyclerViewTrails.setVisibility(View.VISIBLE);
        List<Trail> offlineTrailsList = null;

        try {
            offlineTrailsList = laodTrailFile(HomeActivity.this, KEY);
        } catch (IOException e) {
            e.printStackTrace();
            showEmptyText(true);

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            showEmptyText(true);

        }
        if (offlineTrailsList != null && !offlineTrailsList.isEmpty()) {
            mAdapter.swap(offlineTrailsList, false);

        } else {
            showEmptyText(true);
        }
        if (isMapScreenVisible) {
            showTrailListScreen();
        }


    }

    public void showEmptyText(boolean isOfflineMode) {
        if (isOfflineMode) {
            emptyListText.setText(R.string.empty_offline_trails);

        } else {
            emptyListText.setText(R.string.empty_saved_trails);

        }
        emptySavedTrailsLayout.setVisibility(View.VISIBLE);

        emptyListText.setVisibility(View.VISIBLE);
        recyclerViewTrails.setVisibility(View.GONE);
    }

    private boolean handleOfflineFromMapScreen() {
        if (getIntent().getBooleanExtra("offlinemode", false)) {
            return true;
        }
        return false;
    }

    public void fetchTimelineAsync() {
        // Send the network request to fetch the updated data
        // `client` here is an instance of Android Async HTTP
        getTrailServicsManager().getListOfTrails(new NetworkRequestListener() {
            @Override
            public void onResponseReceive(Object obj) {
                ArrayList<Trail> trailArrayList = (ArrayList<Trail>) obj;
                mAdapter.clear();
                mAdapter.addAll(trailArrayList);
                swipeContainer.setRefreshing(false);
                if (isSavedTrails) {
                    setIconToSavedTrails(false);
                    savedTrails(true);
                    showSavedTrails();
                    isSavedTrails = isSavedTrails();
                } else {
                    setIconToSavedTrails(true);
                    showAllTrails();
                    savedTrails(false);
                    isSavedTrails = isSavedTrails();
                }

            }

            @Override
            public void onError(String message) {

            }
        });

    }

    private void updateMapScreen() {
        if (mapboxMap != null) {
            mapboxMap.clear();
            drawMarkers();
        }

    }

    private void drawMarkers() {
        List<Direction> directionList = new ArrayList<>();
        mapboxMap.clear();
        IconFactory iconFactory = IconFactory.getInstance(HomeActivity.this);
        Drawable iconDrawable = ContextCompat.getDrawable(HomeActivity.this, R.drawable.flag_icon);
        Icon icon = iconFactory.fromDrawable(iconDrawable);
        points = new ArrayList<>();
        mapboxMap.setInfoWindowAdapter(new MapboxMap.InfoWindowAdapter() {
            @Nullable
            @Override
            public View getInfoWindow(@NonNull final com.mapbox.mapboxsdk.annotations.Marker marker) {
                View customMarker = getLayoutInflater().inflate(R.layout.map_info_window_layout, null);
                android.widget.TextView trailDistance = (android.widget.TextView) customMarker.findViewById(R.id.map_trail_distance);
                android.widget.TextView hoursTextView = (android.widget.TextView) customMarker.findViewById(R.id.map_hours_tv);
                android.widget.TextView trailDifficulty = (android.widget.TextView) customMarker.findViewById(R.id.map_trail_difficulty);
                android.widget.TextView trailName = (android.widget.TextView) customMarker.findViewById(R.id.map_trail_name);
                Trail currentTrail = getTrailServicsManager().getCurrentTrail(marker.getTitle());
                trailName.setText(currentTrail.getTrailName());
                trailDistance.setText(currentTrail.getTrailDistance() + " / ");
                trailDifficulty.setText(currentTrail.getTrailDifficulty() + " / ");
                hoursTextView.setText(currentTrail.getTrailTime());
                return customMarker;
            }
        });

        mapboxMap.setOnInfoWindowClickListener(new MapboxMap.OnInfoWindowClickListener() {
            @Override
            public boolean onInfoWindowClick(@NonNull com.mapbox.mapboxsdk.annotations.Marker marker) {
                startTrailActivity(marker);
                return true;
            }
        });

        if (isSavedOn) {
            directionList = getTrailServicsManager().getSavedTrailsDirections();
        } else if (isOfflineMode) {
            List<Trail> offlineTrailsList = null;
            try {
                offlineTrailsList = laodTrailFile(HomeActivity.this, KEY);
            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
            List<Direction> listDir = new ArrayList<>();
            if (offlineTrailsList != null) {
                if (!offlineTrailsList.isEmpty()) {
                    for (Trail t : offlineTrailsList
                            ) {
                        Direction d = new Direction(t.getTrailName(), t.getLatitudeStart(), t.getLatitudeEnd(), t.getLongitudeStart(), t.getLongitudeEnd());
                        listDir.add(d);
                    }
                    directionList = listDir;
                }

            }

        } else {
            directionList = getTrailServicsManager().getTrailsDirections();

        }
        if (!directionList.isEmpty()) {
            for (final Direction direction : directionList) {
                final com.mapbox.mapboxsdk.geometry.LatLng trail = new com.mapbox.mapboxsdk.geometry.LatLng(direction.getLatitudeStart(),
                        direction.getLongitudeStart());
                points.add(trail);
                mapboxMap.addMarker(new com.mapbox.mapboxsdk.annotations.MarkerOptions()
                        .position(new com.mapbox.mapboxsdk.geometry.LatLng(trail.getLatitude(), trail.getLongitude()))
                        .title(direction.getmTrailName())
                        .icon(icon))
                ;
            }
        }
        if (points.size() > 1) {
            com.mapbox.mapboxsdk.geometry.LatLngBounds latLngBounds = new com.mapbox.mapboxsdk.geometry.LatLngBounds.Builder()
                    .includes(points)
                    .build();

            mapboxMap.easeCamera(CameraUpdateFactory
                    .newLatLngBounds(latLngBounds, 110), 0);
        } else if (points.size() == 1) {
            points.add(new LatLng(points.get(0).getLatitude() + 0.5, points.get(0).getLongitude() + 0.5));
            com.mapbox.mapboxsdk.geometry.LatLngBounds latLngBounds = new com.mapbox.mapboxsdk.geometry.LatLngBounds.Builder()
                    .includes(points)
                    .build();

            mapboxMap.easeCamera(CameraUpdateFactory
                    .newLatLngBounds(latLngBounds, 110), 0);

        } else {
            mapboxMap.setCameraPosition(new CameraPosition.Builder()
                    .target(new LatLng(40, 45))
                    .zoom(6)
                    .build());
        }

    }


}
