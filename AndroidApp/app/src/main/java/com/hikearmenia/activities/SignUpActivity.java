package com.hikearmenia.activities;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ScrollView;
import android.widget.TextView;

import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.requests.SignUpRequest;
import com.hikearmenia.ui.widgets.Button;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;

/**
 * Created by robert on 5/11/16.
 */
public class SignUpActivity extends TransparentStatusBarACtivity implements View.OnClickListener, View.OnTouchListener, NetworkRequestListener {

    private Button signUpButton;
    private EditText firstName;
    private EditText lastName;
    private EditText email;
    private EditText password;
    private EditText passwordConfirm;
    private ScrollView scrollView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.sign_up_view);
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().show();
            TextView toolbarTitle = (TextView) findViewById(R.id.toolbar_title);
            toolbarTitle.setText("Sign Up");
            getSupportActionBar().setTitle("");
            getSupportActionBar().setHomeButtonEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setHomeAsUpIndicator(R.drawable.back);
        }

        signUpButton = (Button) findViewById(R.id.sign_up_button);
        firstName = (EditText) findViewById(R.id.sign_up_view_user_name);
        lastName = (EditText) findViewById(R.id.sign_up_view_surname);
        email = (EditText) findViewById(R.id.sign_up_email);
        password = (EditText) findViewById(R.id.sign_up_password);
        passwordConfirm = (EditText) findViewById(R.id.sign_up_password_confirm);
        scrollView = (ScrollView) findViewById(R.id.sign_up_scroll);

        signUpButton.setOnTouchListener(this);

    }


    @Override
    protected void onResume() {
        HikeArmeniaApplication.setCurrentActivity(this);
        super.onResume();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {

            default:
                break;
        }
    }


    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
    }

    public void handleSignUpRequest() {

        String firstNameText = firstName.getText().toString();
        String lastNameText = lastName.getText().toString();
        String passwordText = password.getText().toString();
        String passwordConfirmText = passwordConfirm.getText().toString();
        String emailText = email.getText().toString();

        if (Util.isEmailValid(emailText) && Util.isPasswordValid(passwordText) &&
                passwordText.equals(passwordConfirmText)) {
            SignUpRequest signUpRequest = new SignUpRequest(
                    firstNameText, lastNameText, emailText, passwordText,
                    getDeviceUdid());
            UIUtil.showProgressDialog(this);
            getUserServiceManager().signup(signUpRequest, this);
        } else {
            if (!Util.isEmailValid(emailText)) {
                UIUtil.alertDialogShow(this, getString(R.string.invalid_email_title), getString(R.string.invalid_email_message));
            } else if (!passwordText.equals(passwordConfirmText)) {
                UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.make_sure_passwords_match));
            }
        }
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
            UIUtil.alertDialogShow(this, getString(R.string.signUp_failed), message);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return true;
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
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {

        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                v.setAlpha(0.7f);
                break;
            case MotionEvent.ACTION_UP:
                v.setAlpha(1f);
                if (v.getId() == R.id.sign_up_button) {
                    if (!firstName.getText().toString().isEmpty()
                            && !lastName.getText().toString().isEmpty()
                            && !email.getText().toString().isEmpty()
                            && !password.getText().toString().isEmpty()
                            && !passwordConfirm.getText().toString().isEmpty()) {
                        if (Util.isNetworkAvailable(SignUpActivity.this, true)) {
                            handleSignUpRequest();
                        }
                    } else {
                        UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.fill_empty_fields));
                    }
                }
                break;
        }
        return false;
    }
}
