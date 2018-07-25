package com.hikearmenia.activities;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

public class AboutActivity extends BaseActivity implements View.OnTouchListener {

    /*toolbar views*/
    RelativeLayout leftIconLayoutToolbar;
    ImageView leftIconToolbar;
    RelativeLayout rightIconLayoutToolbar;
    ImageView rightIconToolbar;
    private LinearLayout findLocalGuides;
    private LinearLayout savedTrails;
    private LinearLayout compass;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);
        initToolbar();
        initView();
        findLocalGuides = (LinearLayout) findViewById(R.id.find_local_guides);
        findLocalGuides.setOnTouchListener(this);

        savedTrails = (LinearLayout) findViewById(R.id.bottom_bar_saved_trails);
        savedTrails.setOnTouchListener(this);
        compass = (LinearLayout) findViewById(R.id.bottom_menu_take_photo);
        compass.setOnTouchListener(this);

        initDrawerLayout();
        LinearLayout findLocalGuides = (LinearLayout) findViewById(R.id.find_local_guides);
        findLocalGuides.setOnTouchListener(this);
        LinearLayout savedTrailes = (LinearLayout) findViewById(R.id.bottom_bar_saved_trails);
        savedTrailes.setOnTouchListener(this);
        super.setNavigationLayoutWidht();
    }


    private void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        toolbar.setContentInsetsAbsolute(0, 0);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        leftIconLayoutToolbar = (RelativeLayout) findViewById(R.id.toolbar_left_icon_layout);
        leftIconLayoutToolbar.setOnTouchListener(this);
        leftIconToolbar = (ImageView) findViewById(R.id.toolbar_left_icon);
        rightIconLayoutToolbar = (RelativeLayout) findViewById(R.id.toolbar_right_icon_layout);
        rightIconLayoutToolbar.setOnTouchListener(this);
        rightIconToolbar = (ImageView) findViewById(R.id.toolbar_right_icon);
        rightIconToolbar.setImageResource(R.mipmap.stack_trail);
        findViewById(R.id.toolbar_title_img).setVisibility(View.GONE);
        TextView title = (TextView) findViewById(R.id.toolbar_title);
        title.setText("About");
    }

    private void initView() {
        ImageView fbIcon = (ImageView) findViewById(R.id.fb_icon);
        ImageView inIcon = (ImageView) findViewById(R.id.in_icon);
        final TextView contact = (TextView) findViewById(R.id.contact);
        contact.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent emailIntent = new Intent(Intent.ACTION_SENDTO, Uri.fromParts(
                        "mailto", contact.getText().toString(), null));
                emailIntent.putExtra(Intent.EXTRA_SUBJECT, "Hike Armenia");
                try {
                    startActivity(Intent.createChooser(emailIntent, ""));
                } catch (Exception e) {
                    UIUtil.alertDialogShow(AboutActivity.this, getString(R.string.could_not_send_email_title), getString(R.string.warning_send_email_appinfo_message));
                }
            }
        });
        TextView version = (TextView) findViewById(R.id.version);
        PackageInfo pInfo = null;
        try {
            pInfo = getPackageManager().getPackageInfo(getPackageName(), 0);
            version.setText(String.format(getString(R.string.app_version, pInfo.versionName.toString())));
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        inIcon.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(getString(R.string.hike_armenia_in_link))));
                    }
                }).playOn(view, STANDART_DURETION);
                return false;
            }
        });

        fbIcon.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(getString(R.string.hike_armenia_fb_link))));
                    }
                }).playOn(view, STANDART_DURETION);
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


    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case android.R.id.home:
                if (drawerLayout != null) {
                    drawerLayout.openDrawer(Gravity.LEFT);
                }
                return true;
            case R.id.toolbar_menu_item:
                finish();
                return true;
            default:
                return false;
        }
    }


    @Override
    public boolean onTouch(View v, MotionEvent event) {

        switch (v.getId()) {

            case R.id.find_local_guides:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(AboutActivity.this, true)) {
                            Intent intent = new Intent(AboutActivity.this, FindLocalGuidesActivitiy.class);
                            startActivityForResult(intent, ResultCodes.RESULT_CODE_HOME_OK);
                            finish();
                        }
                    }
                }).playOn(v, STANDART_DURETION);
                break;
            case R.id.bottom_bar_saved_trails:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(AboutActivity.this, true)) {

                            if (getUserServiceManager().getUser() != null && getUserServiceManager().getUser().isGuest()) {
                                Intent i = new Intent(AboutActivity.this, AuthActivity.class);
                                i.putExtra("savTrailse", true);
                                IntentUtils.getInstance().startActivityForResult(AboutActivity.this, 2, i, null, false);
                            } else {
                                setResult(ResultCodes.RESULT_CODE_SAVED_TRAIL);
                                finish();
                            }
                        }
                    }
                }).playOn(v, STANDART_DURETION);
                break;
            case R.id.bottom_menu_take_photo:

                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        Util.dispatchTakePictureIntent(AboutActivity.this);

                    }
                }).playOn(v, STANDART_DURETION);
                break;
            case R.id.toolbar_left_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (drawerLayout != null) {
                            drawerLayout.openDrawer(Gravity.LEFT);
                        }
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.toolbar_right_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        finish();
                    }
                }).playOn(v, LONG_DURETION);
                break;
        }

        return false;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (resultCode) {
            case ResultCodes.RESULT_CODE_HOME_OK:
                finish();
                break;
            case ResultCodes.RESULT_CODE_ALL_TRAIL:
                finish();
                break;
            case -1://ResultCodes.REQUEST_IMAGE_CAPTURE:
                if (resultCode == RESULT_OK) {
                    Bundle extras = data.getExtras();
                    Bitmap imageBitmap = (Bitmap) extras.get("data");
                    Intent takePhotoIntnet = new Intent(AboutActivity.this, TakePhotoActivity.class);
                    takePhotoIntnet.putExtra("image", imageBitmap);
                    startActivity(takePhotoIntnet);
                }
                break;
        }
    }

}
