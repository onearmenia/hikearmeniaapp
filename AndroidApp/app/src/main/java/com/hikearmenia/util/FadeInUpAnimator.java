package com.hikearmenia.util;

/**
 * Created by HaykMusheghyan on 7/14/15.
 */

import android.view.View;

import com.nineoldandroids.animation.ObjectAnimator;

public class FadeInUpAnimator extends BaseViewAnimator {
    @Override
    public void prepare(View target) {
        getAnimatorAgent().playTogether(
                ObjectAnimator.ofFloat(target, "alpha", 0, 1)
                //  ObjectAnimator.ofFloat(target, "translationY", Util.getDisplayHeight()/6, 0)
        );
    }
}