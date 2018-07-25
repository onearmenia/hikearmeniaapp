package com.hikearmenia.ui.widgets;

import android.content.Context;
import android.support.v4.widget.NestedScrollView;
import android.util.AttributeSet;

import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.util.Util;

/**
 * Created by jr on 6/14/16.
 */
public class CustomScrollView extends NestedScrollView {

    BaseActivity baseActivity;
    boolean showGreenImg;

    public CustomScrollView(Context context) {
        super(context);
        baseActivity = (BaseActivity) context;
    }


    public CustomScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
        baseActivity = (BaseActivity) context;
    }


    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);

        if (t <= Util.getDisplayHeight(baseActivity) / 10) {
            showGreenImg = false;
            baseActivity.getSupportActionBar().show();

        } else {
            if (t <= Util.getDisplayHeight(baseActivity) / 2.4) {
                baseActivity.getSupportActionBar().hide();
                showGreenImg = false;

            } else {
                showGreenImg = true;
                baseActivity.getSupportActionBar().show();


            }

        }


    }

    public boolean showGreenImg() {
        return showGreenImg;
    }
}
