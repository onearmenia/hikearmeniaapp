package com.hikearmenia.app;

import android.app.Activity;
import android.content.Context;
import android.support.multidex.MultiDex;
import android.support.multidex.MultiDexApplication;

/**
 * Created by jr on 5/19/16.
 */
public class HikeArmeniaApplication extends MultiDexApplication {
    private static Context context;
    private static Activity activity;

    /**
     * setCurrentActivity(null) in onPause() on each activity
     * setCurrentActivity(this) in onResume() on each activity
     */

    public static void setCurrentActivity(Activity currentActivity) {
        activity = currentActivity;
    }

    public synchronized static Context getAppContext() {
        return HikeArmeniaApplication.context;
    }

    public static Activity currentActivity() {
        return activity;
    }

    public void onCreate() {
        super.onCreate();
        HikeArmeniaApplication.context = getApplicationContext();

    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

}