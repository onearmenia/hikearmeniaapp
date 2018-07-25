package com.hikearmenia.activities;

import android.os.Bundle;
import android.view.View;

/**
 * Created by anikarapetyan1 on 7/7/16.
 */

public class TransparentStatusBarNotSlidingActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
    }
}

