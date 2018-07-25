package com.hikearmenia.ui;

import android.content.Context;
import android.view.View;
import android.view.animation.AccelerateInterpolator;
import android.widget.ProgressBar;

import com.hikearmenia.R;
import com.hikearmenia.util.SmoothProgressDrawable;

/**
 * Created by apple on 6/30/16.
 */

public class ProgressBarUI {
    ProgressBar progressBar1;
    ProgressBar progressBar2;
    ProgressBar progressBar3;
    private Context context;
    private View theInflatedView;

    public ProgressBarUI(Context context, View ratingbar) {
        this.context = context;
        theInflatedView = ratingbar;
        getTheInflatedView();
    }

    public View getTheInflatedView() {
        progressBar1 = (ProgressBar) theInflatedView.findViewById(R.id.progres_1);
        progressBar2 = (ProgressBar) theInflatedView.findViewById(R.id.progres_2);
        progressBar3 = (ProgressBar) theInflatedView.findViewById(R.id.progres_3);
        progressBar1.setIndeterminateDrawable(new SmoothProgressDrawable.Builder(context)
                .interpolator(new AccelerateInterpolator()).build());
        progressBar2.setIndeterminateDrawable(new SmoothProgressDrawable.Builder(context)
                .interpolator(new AccelerateInterpolator()).build());
        progressBar3.setIndeterminateDrawable(new SmoothProgressDrawable.Builder(context)
                .interpolator(new AccelerateInterpolator()).build());


        return theInflatedView;
    }
}
