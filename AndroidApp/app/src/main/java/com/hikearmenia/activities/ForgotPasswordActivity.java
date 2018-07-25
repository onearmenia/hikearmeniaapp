package com.hikearmenia.activities;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;

import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.dialogs.CustomAlertDialog;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.ui.widgets.Button;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;

/**
 * Created by Ani Karapetyan on 5/11/16.
 */

public class ForgotPasswordActivity extends TransparentStatusBarACtivity implements NetworkRequestListener {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.password_recovery_view);
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().show();
            TextView toolbarTitle = (TextView) findViewById(R.id.toolbar_title);
            toolbarTitle.setText(getResources().getString(R.string.password_rec_title));
            getSupportActionBar().setTitle("");
            getSupportActionBar().setHomeButtonEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setHomeAsUpIndicator(R.drawable.back);
        }

        Button recovery = (Button) findViewById(R.id.password_rec_view_recover_button);
        final EditText email = (EditText) findViewById(R.id.password_rec_view_email);

        assert recovery != null;
        recovery.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        v.setAlpha(0.7f);
                        break;
                    case MotionEvent.ACTION_UP:
                        v.setAlpha(1f);
                        if (Util.isEmailValid(email.getText().toString())) {
                            if (Util.isNetworkAvailable(ForgotPasswordActivity.this, true)) {
                                UIUtil.showProgressDialog(ForgotPasswordActivity.this);
                                getUserServiceManager().recoverPassword(email.getText().toString(), ForgotPasswordActivity.this);

                            }

                        } else if (email.getText().toString().isEmpty()) {
                            UIUtil.alertDialogShow(ForgotPasswordActivity.this, getString(R.string.warning), getString(R.string.please_fill_email));

                        } else {
                            UIUtil.alertDialogShow(ForgotPasswordActivity.this, getString(R.string.invalid_email_title), getString(R.string.invalid_email_message));
                        }
                        break;
                }
                return false;
            }
        });
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        HikeArmeniaApplication.setCurrentActivity(this);
    }

    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
            overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return true;
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        //finish();
        //activityStarter.overridePendingTransition(R.anim.slide_in_right, R.anim.shift_out_left);

        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    @Override
    public void onResponseReceive(Object obj) {
        // need to be changed
        UIUtil.hideProgressDialog(ForgotPasswordActivity.this);
        UIUtil.alertDialogShow(this, getString(R.string.sucses), getString(R.string.check_your_email), new CustomAlertDialog.Callback() {
            @Override
            public void onPositiveButtonChoosen() {
                setResult(ResultCodes.RESULT_CODE_DIALOG_OK);
                onBackPressed();
            }
        });
    }

    @Override
    public void onError(String message) {
        UIUtil.hideProgressDialog(ForgotPasswordActivity.this);
        UIUtil.alertDialogShow(this, getString(R.string.password_recovery_railed), getString(R.string.recover_password_please_try_again_later));
    }
}
