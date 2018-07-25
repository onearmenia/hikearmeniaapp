package com.hikearmenia.activities;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.LinearLayout;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApp;
import com.hikearmenia.fragment.LeftSlideMenu;
import com.hikearmenia.listener.DrawerLayoutListener;
import com.hikearmenia.listener.LeftSlideMenuOnItemClickListener;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.listener.OnAccountChangeListener;
import com.hikearmenia.manager.GuideReviewsManager;
import com.hikearmenia.manager.TrailServicsManager;
import com.hikearmenia.manager.UserServiceManager;
import com.hikearmenia.models.api.Guide;
import com.hikearmenia.models.api.Response;
import com.hikearmenia.models.requests.ApiRequest;
import com.hikearmenia.models.requests.ReviewRequest;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;

import java.util.List;
import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by Martha on 4/7/2016.
 */

public class BaseActivity extends AppCompatActivity implements LeftSlideMenuOnItemClickListener {

    public static int STANDART_DURETION = 100;
    public static int LONG_DURETION = 100;
    public final String BASE_URL = "http://api.hikearmenia.com";
    public DrawerLayout drawerLayout;
    public boolean isSavedTrails;
    public boolean isNavBarOpened;
    public Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
    public Retrofit retrofit = new Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .build();
    protected boolean drawerLayoutIsOpen;
    protected LeftSlideMenu leftSlideMenu;
    protected ActionBarDrawerToggle drawerToggle;
    Toolbar toolbar;
    SharedPreferences sPref;
    String SAVED_TRAILS = "savedTrails";
    DrawerLayoutListener listener;
    View view;
    private HikeArmeniaApp mHikeArmeniaApp;
    private OnAccountChangeListener mListener;

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

    public TrailServicsManager getTrailServicsManager() {
        return mHikeArmeniaApp.getTrailServiceManager();
    }

    public HikeArmeniaApp getHikeArmeniaApp() {

        return mHikeArmeniaApp;
    }

    public GuideReviewsManager getGuideReviewsManager() {
        return mHikeArmeniaApp.getGuidesReviewsManager();
    }

    public UserServiceManager getUserServiceManager() {
        return mHikeArmeniaApp.getUserServiceManager();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        mHikeArmeniaApp = HikeArmeniaApp.getInstance(this);
        if (savedInstanceState != null) {
            mHikeArmeniaApp.loadState(savedInstanceState);
        }
        initImageLoader(this);
        super.onCreate(savedInstanceState);
        getDeviceUdid();

    }

    public void getListOfGuide(final NetworkRequestListener listener) {
        ApiRequest service = retrofit.create(ApiRequest.class);
        Call<Response<List<Guide>>> call = service.listOfGuide(Locale.getDefault().getLanguage());
        call.enqueue(new Callback<Response<List<Guide>>>() {
            @Override
            public void onResponse(Call<Response<List<Guide>>> call, retrofit2.Response<Response<List<Guide>>> response) {
                if (response != null) {
                    listener.onResponseReceive(response.body().getResult());
                } else {
                    listener.onError("Error");
                }
            }

            @Override
            public void onFailure(Call<Response<List<Guide>>> call, Throwable t) {

            }
        });
    }

    @Override
    protected void onResume() {
        drawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        leftSlideMenu = LeftSlideMenu.newInstance(this, drawerLayout, this);

        super.onResume();
    }

    public void getListOfGuideByTrailID(final NetworkRequestListener listener, String trailID) {
        ApiRequest service = retrofit.create(ApiRequest.class);
        Call<Response<List<Guide>>> call = service.listOfGuideByTrailID(trailID, Locale.getDefault().getLanguage());
        call.enqueue(new Callback<Response<List<Guide>>>() {
            @Override
            public void onResponse(Call<Response<List<Guide>>> call, retrofit2.Response<Response<List<Guide>>> response) {
                if (response != null) {
                    listener.onResponseReceive(response.body().getResult());
                } else {
                    listener.onError("Error");
                }
            }

            @Override
            public void onFailure(Call<Response<List<Guide>>> call, Throwable t) {

            }
        });
    }

    public void getListOfTips(final NetworkRequestListener listener) {
        ApiRequest service = retrofit.create(ApiRequest.class);
        Call<Response<List<Guide>>> call = service.listOfGuide(Locale.getDefault().getDisplayLanguage());
        call.enqueue(new Callback<Response<List<Guide>>>() {
            @Override
            public void onResponse(Call<Response<List<Guide>>> call, retrofit2.Response<Response<List<Guide>>> response) {
                if (response != null) {
                    listener.onResponseReceive(response.body().getResult());
                } else {
                    listener.onError("Error");
                }
            }

            @Override
            public void onFailure(Call<Response<List<Guide>>> call, Throwable t) {

            }
        });
    }

    public void guideReview(final NetworkRequestListener listener, int guidID, ReviewRequest guideReviewRequest) {
        ApiRequest service = retrofit.create(ApiRequest.class);
        Call<Response> call = service.guideReview(guidID, guideReviewRequest, getUserServiceManager().getUser().getToken());
        call.enqueue(new Callback<Response>() {
            @Override
            public void onResponse(Call<Response> call, retrofit2.Response<Response> response) {
                if (response != null) {
                    listener.onResponseReceive(response);
                } else {
                    listener.onError("Error");
                }
            }

            @Override
            public void onFailure(Call<Response> call, Throwable t) {

            }
        });
    }

    public void traileReview(final NetworkRequestListener listener, int trailID, ReviewRequest trailReviewRequest) {
        ApiRequest service = retrofit.create(ApiRequest.class);

        Call<Response> call = service.trailReview(trailID, trailReviewRequest, getUserServiceManager().getUser().getToken());
        call.enqueue(new Callback<Response>() {
            @Override
            public void onResponse(Call<Response> call, retrofit2.Response<Response> response) {
                if (response != null) {
                    listener.onResponseReceive(response);
                } else {
                    listener.onError("Error");
                }
            }

            @Override
            public void onFailure(Call<Response> call, Throwable t) {
                Log.e("ERROR", t.getMessage());
            }
        });
    }

    public String getDeviceUdid() {
        String id = android.provider.Settings.System.getString(super.getContentResolver(),
                android.provider.Settings.Secure.ANDROID_ID);
        return id;

    }

    public void setFragment(BaseActivity activity, Fragment fragment, int id) {
        android.support.v4.app.FragmentTransaction fragmentTransaction = activity.getSupportFragmentManager().beginTransaction();
        fragmentTransaction.setCustomAnimations(R.anim.slide_left_enter, R.anim.slide_right_enter);
        fragmentTransaction.replace(id, fragment);
        fragmentTransaction.commit();
    }

    public void initDrawerLayout() {
        drawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawerToggle = new CustomDrawerToggle(this, drawerLayout, toolbar, R.string.drawer_open, R.string.drawer_close);
        drawerLayout.addDrawerListener(drawerToggle);
        leftSlideMenu = LeftSlideMenu.newInstance(this, drawerLayout, this);
        drawerLayout.setScrimColor(ContextCompat.getColor(getApplicationContext(), android.R.color.transparent));
        android.support.v4.app.FragmentTransaction fragmentTransaction = getSupportFragmentManager().beginTransaction();
        fragmentTransaction.replace(R.id.nav_view, leftSlideMenu);
        fragmentTransaction.commit();
    }

    public void closeDrawer(DrawerLayoutListener listener, View v) {
        this.listener = listener;
        view = v;
        if (drawerLayout != null) {
            // drawerLayout.closeDrawer(Gravity.LEFT);
        }
    }

    public void closeDrawer() {
        if (drawerLayout != null) {

        }
    }

    public OnAccountChangeListener getOnAccountChangeListener() {
        return mListener;
    }

    public void setOnAccountChangeListener(OnAccountChangeListener listener) {
        mListener = listener;
    }

    public void savedTrails(boolean isSavedTrailes) {
        sPref = getSharedPreferences(SAVED_TRAILS, MODE_PRIVATE);
        SharedPreferences.Editor ed = sPref.edit();
        ed.putBoolean(SAVED_TRAILS, isSavedTrailes);
        ed.commit();
    }

    public boolean isSavedTrails() {
        sPref = getSharedPreferences(SAVED_TRAILS, MODE_PRIVATE);
        return sPref.getBoolean(SAVED_TRAILS, false);
    }

    @Override
    public void getSelectedItem(LeftSlideItems anEnum) {
        // drawerLayout.closeDrawers();
    }

    void setNavigationLayoutWidht() {
        DisplayMetrics displaymetrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
        int height = displaymetrics.heightPixels;
        int width = displaymetrics.widthPixels;

        LinearLayout leftNavigationLayout = (LinearLayout) findViewById(R.id.nav_view);
        DrawerLayout.LayoutParams params = new DrawerLayout.LayoutParams((int) (width * 0.8), height, Gravity.START
        );

        leftNavigationLayout.setLayoutParams(params);
    }

    @Override
    public void onBackPressed() {

        if (isNavBarOpened) {
            drawerLayout.closeDrawers();
            isNavBarOpened = false;
        } else {
            super.onBackPressed();
        }
    }

    public enum LeftSlideItems {
        SIGN_IN, MY_PROFILE, ALL_TRAILS, OFFLINE_TRAILS, COMPASS, FIND_LOCAL_GUIDES, SAVED_TRAILS, APP_INFO,
    }

    public class CustomDrawerToggle extends ActionBarDrawerToggle {
        Animation shakeAnimation;
        private Runnable runnable;

        public CustomDrawerToggle(Activity activity, DrawerLayout drawerLayout, int openDrawerContentDescRes, int closeDrawerContentDescRes) {
            super(activity, drawerLayout, openDrawerContentDescRes, closeDrawerContentDescRes);
            shakeAnimation = AnimationUtils.loadAnimation(activity, R.anim.shake_anim);
        }

        public CustomDrawerToggle(Activity activity, DrawerLayout drawerLayout, Toolbar toolbar, int openDrawerContentDescRes, int closeDrawerContentDescRes) {
            super(activity, drawerLayout, toolbar, openDrawerContentDescRes, closeDrawerContentDescRes);
            shakeAnimation = AnimationUtils.loadAnimation(activity, R.anim.shake_anim);
        }

        @Override
        public void onDrawerClosed(View drawerView) {
            super.onDrawerClosed(drawerView);
            drawerLayoutIsOpen = false;
            if (listener != null) {
                listener.onDrawerLayoutClosed(view);
            }
        }

        @Override
        public void onDrawerOpened(View drawerView) {
            super.onDrawerOpened(drawerView);
            drawerLayoutIsOpen = true;
        }

        @Override
        public void onDrawerSlide(View drawerView, float slideOffset) {
            View view = findViewById(R.id.root_content);
            View viewLayout = findViewById(R.id.nav_view);
            float xPositionOpenDrawer = viewLayout.getLayoutParams().width;
            float xPositionWindowContent = (float) (slideOffset * (xPositionOpenDrawer));

            if (view.getX() >= -viewLayout.getLayoutParams().width || xPositionWindowContent <= viewLayout.getLayoutParams().width) {
                view.setX(xPositionWindowContent);
            }
            super.onDrawerSlide(drawerView, slideOffset);
        }

       /* public void runWhenIdle(Runnable runnable) {
            Handler handler = new Handler();
            this.runnable = runnable;
            handler.postDelayed( this.runnable,1);
           // this.runnable.run();
            this.runnable = null;
        }*/
    }


}
