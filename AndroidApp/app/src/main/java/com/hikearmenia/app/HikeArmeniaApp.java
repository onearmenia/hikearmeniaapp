package com.hikearmenia.app;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;

import com.hikearmenia.manager.BaseManager;
import com.hikearmenia.manager.GuideReviewsManager;
import com.hikearmenia.manager.TrailServicsManager;
import com.hikearmenia.manager.UserServiceManager;

/**
 * Created by anikarapetyan1 on 5/13/16.
 */
public class HikeArmeniaApp implements ManagerContext {

    private static HikeArmeniaApp sInstance;
    TrailServicsManager trailServicsManager;
    private UserServiceManager mUserServiceManager;

    private GuideReviewsManager guideReviewsManager;
    private boolean mInitialized;
    private Context mAppContext;
    private Context mBaseActivity;

    public static synchronized HikeArmeniaApp getInstance(Context context) {
        if (sInstance == null) {
            Bundle metaData;
            try {
                ApplicationInfo ai = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
                metaData = ai.metaData;
            } catch (PackageManager.NameNotFoundException e) {
                throw new RuntimeException(e);
            }

            String appClassName = metaData.getString("com.hikearmenia.app.HikeArmeniaApp");
            try {
                Class<?> appClass = HikeArmeniaApp.class.getClassLoader().loadClass(appClassName);
                sInstance = (HikeArmeniaApp) appClass.newInstance();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }

            sInstance.mAppContext = context.getApplicationContext();
            sInstance.mBaseActivity = context;
            try {
                sInstance.initialize();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return sInstance;
    }

    public synchronized void initialize() {
        if (mInitialized) {
            return;
        }

        // Manager initialization

        mUserServiceManager = new UserServiceManager(this, mBaseActivity);

        guideReviewsManager = new GuideReviewsManager(this, mBaseActivity);

        trailServicsManager = new TrailServicsManager(this, mBaseActivity);


        initManagers(mUserServiceManager, guideReviewsManager, trailServicsManager);


        mInitialized = true;
    }

    private void initManagers(BaseManager... managers) {
        for (BaseManager manager : managers) {
            manager.getInitializer().init();
        }
    }


    public synchronized boolean isInitialized() {
        return mInitialized;
    }


    @Override
    public Context getAppContext() {
        return mAppContext;
    }


    @Override
    public UserServiceManager getUserServiceManager() {
        return mUserServiceManager;
    }

    @Override
    public GuideReviewsManager getGuidesReviewsManager() {
        return guideReviewsManager;
    }

    @Override
    public TrailServicsManager getTrailServiceManager() {
        return trailServicsManager;
    }


    @Override
    public void registerLocalReceiver(BroadcastReceiver receiver, IntentFilter filter) {
        LocalBroadcastManager.getInstance(getAppContext()).registerReceiver(receiver, filter);
    }

    @Override
    public void unregisterLocalReceiver(BroadcastReceiver receiver) {
        LocalBroadcastManager.getInstance(getAppContext()).unregisterReceiver(receiver);
    }

    @Override
    public void sendLocalBroadcast(Intent intent) {
        LocalBroadcastManager.getInstance(getAppContext()).sendBroadcast(intent);
    }

    @Override
    public void saveState(Bundle state) {
        mUserServiceManager.onSaveInstanceState(state);
        trailServicsManager.onSaveInstanceState(state);
        guideReviewsManager.onSaveInstanceState(state);
    }

    @Override
    public void loadState(Bundle state) {
        mUserServiceManager.onRestoreInstanceState(state);
        trailServicsManager.onRestoreInstanceState(state);
        guideReviewsManager.onRestoreInstanceState(state);
    }


}