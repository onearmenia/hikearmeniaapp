package com.hikearmenia.activities;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.requests.SignInRequest;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

import java.util.Arrays;
import java.util.List;


/**
 * Created by Ani Karapetyan on 4/7/2016.
 */

public class AuthActivity extends TransparentStatusBarNotSlidingActivity implements View.OnTouchListener,
        NetworkRequestListener {

    private Button loginButton;
    private TextView signUpButton;
    private TextView passwordRecoveryButton;
    private EditText mailView;
    private EditText passwordView;
    private Button connectWithFbButton;
    private List<String> fbPermissionNeeds;
    private CallbackManager fbCallbackManager;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.login_view);
        HikeArmeniaApplication.setCurrentActivity(this);
        initDrawerLayout();
        loginButton = (com.hikearmenia.ui.widgets.Button) findViewById(R.id.login_button);
        loginButton.setAlpha(1f);
        signUpButton = (com.hikearmenia.ui.widgets.TextView) findViewById(R.id.login_view_sign_up_suggestion);
        passwordRecoveryButton = (com.hikearmenia.ui.widgets.TextView) findViewById(R.id.login_view_forgot);
        connectWithFbButton = (Button) findViewById(R.id.login_view_facebook_button);

        connectWithFbButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(AuthActivity.this, true)) {
                            initFacebook();
                            LoginManager.getInstance().logInWithReadPermissions(AuthActivity.this, fbPermissionNeeds);
                        }
                    }
                }).playOn(v, STANDART_DURETION);
            }
        });


        if (getIntent().hasExtra("savTrailse") && getIntent().getBooleanExtra("update", false)) {
            setResult(ResultCodes.RESULT_CODE_HOME_OK);
        }


        loginButton.setOnTouchListener(this);
        signUpButton.setOnTouchListener(this);
        passwordRecoveryButton.setOnTouchListener(this);
        mailView = (com.hikearmenia.ui.widgets.EditText) findViewById(R.id.login_view_email_input);
        passwordView = (com.hikearmenia.ui.widgets.EditText) findViewById(R.id.login_view_password);

    }


    @Override
    protected void onResume() {
        super.onResume();
        HikeArmeniaApplication.setCurrentActivity(this);
    }

    public void handleLoginRequest() {
        if (!validate()) {
            return;
        }
        String mail = mailView.getText().toString();
        String password = passwordView.getText().toString();
        if (Util.isEmailValid(mail) && Util.isPasswordValid(password)) {
            UIUtil.showProgressDialog(this);
            getUserServiceManager().loginRequest(new SignInRequest(mail, password, getDeviceUdid()), this);
        }
    }


    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
    }

    public boolean validate() {
        boolean valid = true;
        String email = mailView.getText().toString();
        String password = passwordView.getText().toString();
        if (Util.isEmailValid(email) && !password.isEmpty()) {
            mailView.setError(null);
            passwordView.setError(null);
            return valid;

        } else if (!email.isEmpty() && !Util.isEmailValid(email)) {
            UIUtil.alertDialogShow(this, getString(R.string.invalid_email_title), getString(R.string.invalid_email_message));
        } else {
            UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.fill_empty_fields));
            valid = false;
        }

        return valid;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem menuItem) {
        if (menuItem.getItemId() == android.R.id.home) {
            View view = this.getCurrentFocus();

            // on back click close keyboard
            if (view != null) {
                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
            }
        }
        return super.onOptionsItemSelected(menuItem);
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.toolbar_menu, menu);
        MenuItem item = menu.findItem(R.id.toolbar_menu_item);
        item.setVisible(false);
        return true;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == ResultCodes.RESULT_CODE_DIALOG_OK) {
            finish();
        } else {
            super.onActivityResult(requestCode, resultCode, data);
            if (fbCallbackManager != null) {
                fbCallbackManager.onActivityResult(requestCode, resultCode, data);
            }
        }
    }

    @Override
    public void onResponseReceive(Object obj) {

        if (getOnAccountChangeListener() != null) {
            getOnAccountChangeListener().onAccountChanged(true);
        }
        getTrailServicsManager().getListOfTrails(new NetworkRequestListener() {
            @Override
            public void onResponseReceive(Object obj) {
                getTrailServicsManager().filterSavedTrails();
                UIUtil.hideProgressDialog(AuthActivity.this);
                setResult(ResultCodes.RESULT_CODE_UPDATE_DATA);
                finish();
            }

            @Override
            public void onError(String message) {
                UIUtil.hideProgressDialog(AuthActivity.this);
                UIUtil.alertDialogShow(AuthActivity.this, getString(R.string.warning), getString(R.string.could_not_login));
            }
        });
    }

    @Override
    public void onError(String message) {
        UIUtil.hideProgressDialog(this);
        UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.could_not_login));
    }

    private void initFacebook() {
        FacebookSdk.sdkInitialize(getApplicationContext());
        FacebookCallback<LoginResult> fbCallback = new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                final AccessToken accessToken = loginResult.getAccessToken();
                Log.d("logWithFb", accessToken.getToken() + "");
                if (accessToken != null && !accessToken.getToken().isEmpty()) {
                    SignInRequest request = new SignInRequest(accessToken.getToken(), getDeviceUdid());
                    getUserServiceManager().loginWithFacebook(request, AuthActivity.this);

                }
            }

            @Override
            public void onCancel() {
                UIUtil.alertDialogShow(AuthActivity.this, "Error", "Facebook Login canceled");
            }

            @Override
            public void onError(FacebookException error) {
                if (error != null) {
                    UIUtil.alertDialogShow(AuthActivity.this, "Error", error.getMessage());
                }
            }
        };
        fbCallbackManager = CallbackManager.Factory.create();
        LoginManager.getInstance().registerCallback(fbCallbackManager, fbCallback);
        fbPermissionNeeds = Arrays.asList("user_photos", "email", "user_birthday", "public_profile", "user_friends",
                "user_status", "user_location", "user_work_history");

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
                    case R.id.login_view_sign_up_suggestion:
                        IntentUtils.getInstance().startActivityPendingTransition(AuthActivity.this, 0, new Intent(this, SignUpActivity.class), R.anim.slide_left_enter, R.anim.slide_right_enter);
                        break;
                    case R.id.login_view_forgot:
                        Intent intent = new Intent(this, ForgotPasswordActivity.class);
                        IntentUtils.getInstance().startActivityPendingTransition(AuthActivity.this, 0, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);
                        break;
                    case R.id.login_button:
                        if (Util.isNetworkAvailable(this, true)) {
                            handleLoginRequest();
                        }
                        break;
                }
                break;
        }
        return false;
    }
}