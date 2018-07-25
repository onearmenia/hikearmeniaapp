package com.hikearmenia.activities;

import android.os.Bundle;
import android.view.View;

import com.hikearmenia.util.SlidingActivity;


public class TransparentStatusBarACtivity extends SlidingActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
    }
}
