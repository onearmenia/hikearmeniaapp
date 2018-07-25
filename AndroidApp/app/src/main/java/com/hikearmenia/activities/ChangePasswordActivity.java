package com.hikearmenia.activities;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.requests.ChangePasswordRequest;
import com.hikearmenia.ui.widgets.Button;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;

public class ChangePasswordActivity extends BaseActivity implements View.OnTouchListener, NetworkRequestListener {

    EditText oldPAss;
    EditText newPass;
    EditText confirmPass;
    Button saveBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_password);
        initToolbar();
        initViews();
        setResult(ResultCodes.RESULT_CODE_IGNORE);
    }

    private void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(toolbar);

        getSupportActionBar().setDisplayShowTitleEnabled(false);

        toolbar.setContentInsetsAbsolute(0, 0);
        EditText toolbarTitleText = (EditText) findViewById(R.id.toolbar_title);
        toolbarTitleText.setVisibility(View.VISIBLE);
        toolbarTitleText.setText(getString(R.string.change_password));
        ImageView backIcon = (ImageView) findViewById(R.id.home);
        assert backIcon != null;
        backIcon.setImageResource(R.mipmap.back_trails);
        RelativeLayout leftLayout = (RelativeLayout) findViewById(R.id.home_icon);
        assert leftLayout != null;
        leftLayout.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                onBackPressed();
                return false;
            }
        });

        findViewById(R.id.save).setVisibility(View.GONE);
    }


    private void initViews() {
        oldPAss = (EditText) findViewById(R.id.old_pass);
        newPass = (EditText) findViewById(R.id.new_pass);
        confirmPass = (EditText) findViewById(R.id.confirm_pas);
        saveBtn = (Button) findViewById(R.id.save_btn);
        saveBtn.setOnTouchListener(this);
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private boolean isCorrectPassword(String oldPass, String newPass, String confirmPass) {
        if (!Util.isPasswordValid(oldPass) || !Util.isPasswordValid(newPass) || !Util.isPasswordValid(confirmPass)) {
            UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.please_fill_empty_fields));
            return false;
        }
        if (!newPass.equals(confirmPass)) {
            UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.check_password_fields));
            return false;
        }
        return true;
    }

    @Override
    public void onResponseReceive(Object obj) {
        UIUtil.hideProgressDialog(this);
        setResult(ResultCodes.RESULT_CODE_DIALOG_OK);
        onBackPressed();

    }

    @Override
    public void onError(String message) {
        UIUtil.hideProgressDialog(this);
        if (message != null && !message.isEmpty()) {
            UIUtil.alertDialogShow(this, getString(R.string.warning), message);

        }
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                v.setAlpha(0.7f);
                break;
            case MotionEvent.ACTION_UP:
                v.setAlpha(1f);
                switch (v.getId()) {
                    case R.id.save_btn:
                        if (isCorrectPassword(oldPAss.getText().toString(), newPass.getText().toString(), confirmPass.getText().toString())) {
                            ChangePasswordRequest changePasswordRequest = new ChangePasswordRequest(oldPAss.getText().toString(), newPass.getText().toString());
                            getUserServiceManager().changePassword(changePasswordRequest, this);
                            UIUtil.showProgressDialog(this);
                        }
                        break;
                }
                break;
        }

        return true;
    }
}
