package com.hikearmenia.manager;

/**
 * Created by anikarapetyan1 on 5/13/16.
 */


import android.content.Context;
import android.os.Bundle;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hikearmenia.app.ManagerContext;

public abstract class BaseManager {

    public static final int MANAGER_STATE_UNINITIALIZED = 0;
    public static final int MANAGER_STATE_INITIALIZING = 1;
    public static final int MANAGER_STATE_INITIALIZED = 2;
    private static Gson gson = new GsonBuilder().setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES)
            .excludeFieldsWithoutExposeAnnotation()
            .create();
    private final ManagerContext mManagerContext;
    private final Context context;
    private int mState;

    public BaseManager(ManagerContext mManagerContext, Context context) {
        this.mManagerContext = mManagerContext;
        this.context = context;
    }

    protected static String toJson(Object obj) {
        return gson.toJson(obj);
    }

    protected void request(String uri, String body, RequestMethod method, String... args) {
        if (args == null) {
            request(uri, body, method);
        }
    }

    protected void request(String uri, String body, RequestMethod method) {

    }

    protected ManagerContext getManagerContext() {
        return mManagerContext;
    }

    protected Context getAppContext() {
        return mManagerContext.getAppContext();
    }

    public synchronized int getState() {
        return mState;
    }

    private synchronized void setState(int state) {
        mState = state;
    }

    public synchronized boolean isInitializing() {
        return getState() == MANAGER_STATE_INITIALIZING;
    }

    protected boolean init() {
        return true;
    }

    public Initializer getInitializer() {
        return new InlineInitializer();
    }

    public void onSaveInstanceState(Bundle outState) {
        //
    }

    public void onRestoreInstanceState(Bundle inState) {
        //
    }

    public enum RequestMethod {
        GET,
        POST,
        DELETE
    }

    public interface Initializer {

        void init();

    }

    class InlineInitializer implements Initializer {

        @Override
        public void init() {
            try {
                setState(MANAGER_STATE_INITIALIZING);
                BaseManager.this.init();
                setState(MANAGER_STATE_INITIALIZED);
            } catch (RuntimeException e) {
                setState(MANAGER_STATE_UNINITIALIZED);
                throw e;
            }
        }
    }

    class AsyncInitializer implements Initializer {

        @Override
        public void init() {

            //TODO
        }
    }
}