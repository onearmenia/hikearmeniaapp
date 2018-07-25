package com.hikearmenia.util;

import android.animation.Animator;
import android.animation.ObjectAnimator;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.ImageView;
import android.widget.ProgressBar;

import com.hikearmenia.R;

/**
 * Created by anikarapetyan1 on 5/16/16.
 */
public class ProgressFragment extends DialogFragment {

    private static final String KEY_CANCELABLE = "CANCELABLE";
    private static final String KEY_FINISH_ON_CANCEL = "FINISH_ON_CANCEL";
    public boolean secondTime = false;

    public static ProgressFragment newInstance() {
        return newInstance(false);
    }

    public static ProgressFragment newInstance(boolean cancelable) {
        ProgressFragment fragment = new ProgressFragment();

        Bundle args = new Bundle();
        args.putBoolean(KEY_CANCELABLE, cancelable);
        fragment.setArguments(args);

        return fragment;
    }

    public ProgressFragment setFinishOnCalcel() {
        getArguments().putBoolean(KEY_CANCELABLE, true);
        getArguments().putBoolean(KEY_FINISH_ON_CANCEL, true);
        return this;
    }

//    @Override
//    public ProgressFragment setTargetFragment(Fragment fragment) {
//        return (ProgressFragment) super.setTargetFragment(fragment);
//    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle args = getArguments();

        if (savedInstanceState == null) {
            setCancelable(args.getBoolean(KEY_CANCELABLE));
        } else {
            dismiss();
        }
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        FragmentActivity activity = getActivity();

        super.onDetach();
    }


    @Override
    public android.app.Dialog onCreateDialog(android.os.Bundle savedInstanceState) {
        Bundle args = getArguments();

        Dialog dialog = new Dialog(getActivity());
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(0));
        dialog.getWindow().setGravity(Gravity.CENTER);

        LayoutInflater li = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = li.inflate(R.layout.custom_loading_anim, null);
        final ImageView image = (ImageView) view.findViewById(R.id.view);

        ProgressBar progressBar = new ProgressBar(getActivity(), null, android.R.attr.progressBarStyleLargeInverse);
        dialog.setOnShowListener(new DialogInterface.OnShowListener() {
            @Override
            public void onShow(DialogInterface dialog) {
                customLoadingAnim(image, 0);
            }
        });

        dialog.setContentView(view);
        dialog.setCancelable(args.getBoolean(KEY_CANCELABLE));
        dialog.setCanceledOnTouchOutside(false);
        dialog.setOnCancelListener(this);

        return dialog;
    }

    private void customLoadingAnim(final ImageView img, final int numImg) {
        final int imgId[] = {
                R.mipmap.loading_hike_1,
                R.mipmap.loading_hike_2,
                R.mipmap.loading_hike_3,
                R.mipmap.loading_hike_4,
                R.mipmap.loading_hike_5,
                R.mipmap.loading_hike_6,
                R.mipmap.loading_hike_7,
                R.mipmap.loading_hike_8,
                R.mipmap.loading_hike_9,
                R.mipmap.loading_hike_10,
                R.mipmap.loading_hike_11,
                R.mipmap.loading_hike_12,
                R.mipmap.loading_hike_13,
                R.mipmap.loading_hike_14,
                R.mipmap.loading_hike_15,
                R.mipmap.loading_hike_16,
                R.mipmap.loading_hike_17,
                R.mipmap.loading_hike_18,
                R.mipmap.loading_hike_19,
                R.mipmap.loading_hike_20,
                R.mipmap.loading_hike_21,
                R.mipmap.loading_hike_22,
                R.mipmap.loading_hike_23,
                R.mipmap.loading_hike_24,
                R.mipmap.loading_hike_25,
                R.mipmap.loading_hike_26,
                R.mipmap.loading_hike_27,
                R.mipmap.loading_hike_28,
                R.mipmap.loading_hike_29,
                R.mipmap.loading_hike_30,
                R.mipmap.loading_hike_31,
                R.mipmap.loading_hike_32,
                R.mipmap.loading_hike_33,
                R.mipmap.loading_hike_34,
                R.mipmap.loading_hike_35,
                R.mipmap.loading_hike_36,
        };

        img.setImageResource(imgId[numImg]);

        ObjectAnimator animation = ObjectAnimator.ofFloat(img, "alpha", .95f, 1f);
        animation.setDuration(20);
        animation.setRepeatCount(0);
//        animation.setInterpolator(new AccelerateDecelerateInterpolator());
        animation.addListener(new Animator.AnimatorListener() {


            @Override
            public void onAnimationStart(Animator animation) {
                // TODO Auto-generated method stub
            }

            @Override
            public void onAnimationRepeat(Animator animation) {
                // TODO Auto-generated method stub

            }

            @Override
            public void onAnimationEnd(Animator animation) {
                if (imgId.length != numImg + 1) {
                    int tmp = numImg;
                    customLoadingAnim(img, ++tmp);
                } else {
                    if (getDialog() != null && getDialog().isShowing()) {
                        int tmp = 0;
                        customLoadingAnim(img, tmp);
                        secondTime = true;
                    }
                }

            }

            @Override
            public void onAnimationCancel(Animator animation) {
                // TODO Auto-generated method stub

            }
        });
        animation.start();
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        super.onCancel(dialog);

        Fragment fragment = getTargetFragment();
        if (fragment instanceof Callback) {
            ((Callback) fragment).onCancel(this);
        } else {
            FragmentActivity activity = getActivity();
            if (activity instanceof Callback) {
                ((Callback) activity).onCancel(this);
            }
        }

        if (getArguments().getBoolean(KEY_FINISH_ON_CANCEL)) {
            getActivity().finish();
        }
    }


    public interface Callback {
        void onCancel(ProgressFragment fragment);
    }
}
