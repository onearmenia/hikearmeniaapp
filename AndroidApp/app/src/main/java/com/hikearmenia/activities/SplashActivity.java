package com.hikearmenia.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.animation.Animation;

import com.hikearmenia.R;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by Martha on 4/7/2016.
 */
public class SplashActivity extends AppCompatActivity {

    Animation animFadeIn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash);
        startTerminationCountDown();
        String toastMsg;

    }

    private void startTerminationCountDown() {
        Timer timer = new Timer();
        long animationDuration = 2000;
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                // check either user exists or not
                Intent homeActivityIntent = new Intent(SplashActivity.this, HomeActivity.class);
               /* homeActivityIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                homeActivityIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                homeActivityIntent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);*/
                startActivity(homeActivityIntent);
                finish();
            }
        }, animationDuration);
    }
}
