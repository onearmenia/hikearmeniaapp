package com.hikearmenia.app;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import com.hikearmenia.manager.GuideReviewsManager;
import com.hikearmenia.manager.TrailServicsManager;
import com.hikearmenia.manager.UserServiceManager;

/**
 * Created by anikarapetyan1 on 5/13/16.
 */
public interface ManagerContext {

    Context getAppContext();


    UserServiceManager getUserServiceManager();

    GuideReviewsManager getGuidesReviewsManager();

    TrailServicsManager getTrailServiceManager();

    void registerLocalReceiver(BroadcastReceiver receiver, IntentFilter filter);

    void unregisterLocalReceiver(BroadcastReceiver receiver);

    void sendLocalBroadcast(Intent intent);

    void saveState(Bundle state);

    void loadState(Bundle state);

}