package com.hikearmenia.dialogs;

import android.app.Dialog;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.CheckBox;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.ui.widgets.Button;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

/**
 * Created by jr on 6/3/16.
 */
public class CustomAlertDialog extends Dialog implements View.OnTouchListener {

    Callback mCallback;
    String mMessage;
    String mMessageTitle;
    BaseActivity mContext;
    TextView messageTV;
    TextView messageTitle;
    Button positiveBtn;
    CheckBox checkBox;
    boolean isVisible;

    public CustomAlertDialog(BaseActivity baseActivity, String messageTitle, String message, Callback callback) {
        super(baseActivity);
        mCallback = callback;
        mMessage = message;
        mContext = baseActivity;
        mMessageTitle = messageTitle;

    }

    public CustomAlertDialog(BaseActivity baseActivity, @Nullable String messageTitle, @Nullable String message) {
        super(baseActivity);
        mMessage = message;
        mContext = baseActivity;
        mMessageTitle = messageTitle;
    }

    public CustomAlertDialog(BaseActivity baseActivity, @Nullable String messageTitle, @Nullable String message, boolean visible) {

        super(baseActivity);
        this.isVisible = visible;
        mMessage = message;
        mContext = baseActivity;
        mMessageTitle = messageTitle;
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                v.setAlpha(0.5f);
                break;
            case MotionEvent.ACTION_UP:
                v.setAlpha(1f);
                switch (v.getId()) {
                    case R.id.btn_positive:
                        if (mCallback == null) {
                            YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                                @Override
                                public void call(Animator animator) {
                                    onPositiveButtonChoosen();
                                }
                            }).playOn(v, 10);

                        } else {
                            YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                                @Override
                                public void call(Animator animator) {
                                    mCallback.onPositiveButtonChoosen();
                                    CustomAlertDialog.this.hide();
                                }
                            }).playOn(v, 10);
                        }
                }
                break;
        }
        return true;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.custom_dialog);
        checkBox = (CheckBox) findViewById(R.id.checkbox);

        this.getWindow().getAttributes().windowAnimations = R.style.dialog_animation;
        setCanceledOnTouchOutside(false);
        messageTV = (TextView) findViewById(R.id.message_text);
        messageTitle = (TextView) findViewById(R.id.message_title);
        if (messageTitle != null) {
            messageTitle.setText(mMessageTitle);
        } else {
            messageTitle.setVisibility(View.INVISIBLE);
        }
        if (mMessage != null) {
            messageTV.setText(mMessage);
        } else {
            messageTV.setVisibility(View.INVISIBLE);
        }
        ;
        positiveBtn = (Button) findViewById(R.id.btn_positive);
        positiveBtn.setOnTouchListener(this);

        this.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));

        View root = (View) findViewById(R.id.root_layout);
        ViewGroup.LayoutParams params = root.getLayoutParams();
        //   params.height=(int) (Util.getDisplayHeight(mContext) * 0.32);
        params.width = (int) (Util.getDisplayWidth(mContext) * 0.64);
        root.setLayoutParams(params);

        if (isVisible) {
            checkBox.setVisibility(View.VISIBLE);
            messageTV.setVisibility(View.GONE);
        }

    }

    public void setmCallback(Callback mCallback) {
        this.mCallback = mCallback;
    }

    public CheckBox getCheckBox() {
        return checkBox;
    }

    public void onPositiveButtonChoosen() {
        dismiss();
    }

    public interface Callback {
        void onPositiveButtonChoosen();
    }


}