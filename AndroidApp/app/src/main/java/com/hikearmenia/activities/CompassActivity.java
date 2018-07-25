package com.hikearmenia.activities;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

public class CompassActivity extends BaseActivity implements SensorEventListener, View.OnTouchListener {
    /*toolbar views*/
    RelativeLayout leftIconLayoutToolbar;
    ImageView leftIconToolbar;
    RelativeLayout rightIconLayoutToolbar;
    ImageView rightIconToolbar;
    private ImageView arrow;
    private float currentDegree = 0f;
    private SensorManager mSensorManager;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_compass);
        arrow = (ImageView) findViewById(R.id.arrow);
        mSensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
        initToolbar();
        initDrawerLayout();
        super.setNavigationLayoutWidht();

    }


    private void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        toolbar.setContentInsetsAbsolute(0, 0);
        setSupportActionBar(toolbar);
//        getSupportActionBar().setDisplayShowTitleEnabled(false);
//        getSupportActionBar().setDisplayShowHomeEnabled(false);
        leftIconLayoutToolbar = (RelativeLayout) findViewById(R.id.toolbar_left_icon_layout);
        leftIconLayoutToolbar.setOnTouchListener(this);
        leftIconToolbar = (ImageView) findViewById(R.id.toolbar_left_icon);
        rightIconLayoutToolbar = (RelativeLayout) findViewById(R.id.toolbar_right_icon_layout);
        rightIconLayoutToolbar.setOnTouchListener(this);
        rightIconToolbar = (ImageView) findViewById(R.id.toolbar_right_icon);
        rightIconToolbar.setImageResource(R.mipmap.stack_trail);
    }

    @Override
    protected void onResume() {
        super.onResume();
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        if (mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) == null) {

            UIUtil.alertDialogShow(this, "Attention", getResources().getString(R.string.not_compass));
        }

        mSensorManager.registerListener(this, mSensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION),
                SensorManager.SENSOR_DELAY_GAME);
        HikeArmeniaApplication.setCurrentActivity(this);

    }

    @Override
    protected void onPause() {
        super.onPause();
        mSensorManager.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent event) {

        float degree = Math.round(event.values[0]);
        RotateAnimation ra = new RotateAnimation(
                currentDegree,
                -degree,
                Animation.RELATIVE_TO_SELF, 0.5f,
                Animation.RELATIVE_TO_SELF,
                0.5f);
        ra.setDuration(210);
        ra.setFillAfter(true);
        arrow.startAnimation(ra);
        currentDegree = -degree;

    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // not in use
    }


    @Override
    public boolean onTouch(View v, MotionEvent event) {

        switch (v.getId()) {
            case R.id.toolbar_left_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        drawerLayout.openDrawer(Gravity.LEFT);
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.toolbar_right_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {

                        setResult(ResultCodes.RESULT_CODE_HOME_OK);
                        finish();
                    }
                }).playOn(v, LONG_DURETION);
                break;
        }
        return false;
    }
}