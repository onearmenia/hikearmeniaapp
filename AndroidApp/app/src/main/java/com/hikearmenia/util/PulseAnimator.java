package com.hikearmenia.util;

/**
 * Created by Hayk Musheghyan on 7/13/15.
 */

import android.view.View;

import com.nineoldandroids.animation.ObjectAnimator;

public class PulseAnimator extends BaseViewAnimator {
    @Override
    public void prepare(View target) {
        getAnimatorAgent().playTogether(
               /* ObjectAnimator.ofFloat(target, "scaleY", 1, 0.7f, 1),
                ObjectAnimator.ofFloat(target, "scaleX", 1, 0.7f, 1),*/
                ObjectAnimator.ofFloat(target, "alpha", 1, 0f, 1)
        );
    }
}
