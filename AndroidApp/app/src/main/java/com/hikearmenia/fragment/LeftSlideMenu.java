package com.hikearmenia.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.DrawerLayout;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.hikearmenia.R;
import com.hikearmenia.activities.AboutActivity;
import com.hikearmenia.activities.AuthActivity;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.activities.CompassActivity;
import com.hikearmenia.activities.FindLocalGuidesActivitiy;
import com.hikearmenia.activities.HomeActivity;
import com.hikearmenia.activities.MapsActivity;
import com.hikearmenia.activities.ProfileActivity;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.listener.DrawerLayoutListener;
import com.hikearmenia.listener.LeftSlideMenuOnItemClickListener;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.models.api.User;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;

import java.util.ArrayList;
import java.util.List;

public class LeftSlideMenu extends Fragment implements View.OnTouchListener, NetworkRequestListener, DrawerLayoutListener {
    static DrawerLayout mDrawerLayout;
    static BaseActivity mBaseActivity;
    static LeftSlideMenuOnItemClickListener mLeftSlideMenuOnItemClickListener;
    private LinearLayout signInLayout;
    private TextView userSignInTv;
    private ImageView signInImg;
    private LinearLayout allTrailsLayout;
    private LinearLayout appInfoLayout;
    private LinearLayout findLocalGuidesLayout;
    private LinearLayout savedTrailsLayout;
    private LinearLayout offlineTrailsLayout;
    private LinearLayout compassLayout;

    public LeftSlideMenu() {
    }

    public static void setmLeftSlideMenuOnItemClickListener(LeftSlideMenuOnItemClickListener mLeftSlideMenuOnItemClickListener) {
        LeftSlideMenu.mLeftSlideMenuOnItemClickListener = mLeftSlideMenuOnItemClickListener;
    }

    // TODO: Rename and change types and number of parameters
    public static LeftSlideMenu newInstance(BaseActivity baseActivity, DrawerLayout drawerLayout, LeftSlideMenuOnItemClickListener leftSlideMenuOnItemClickListener) {
        mBaseActivity = baseActivity;
        mLeftSlideMenuOnItemClickListener = leftSlideMenuOnItemClickListener;
        mDrawerLayout = drawerLayout;
        LeftSlideMenu fragment = new LeftSlideMenu();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_left_slide_menu, container, false);
        signInLayout = (LinearLayout) view.findViewById(R.id.sign_in);
        signInLayout.setOnTouchListener(this);
        mBaseActivity.drawerLayout = (DrawerLayout) mBaseActivity.findViewById(R.id.drawer_layout);
        findLocalGuidesLayout = (LinearLayout) view.findViewById(R.id.find_local_guides);
        appInfoLayout = (LinearLayout) view.findViewById(R.id.app_info);
        allTrailsLayout = (LinearLayout) view.findViewById(R.id.all_trails);
        savedTrailsLayout = (LinearLayout) view.findViewById(R.id.saved_trails);
        compassLayout = (LinearLayout) view.findViewById(R.id.compass);
        offlineTrailsLayout = (LinearLayout) view.findViewById(R.id.offline_trails);
        offlineTrailsLayout.setOnTouchListener(this);
        compassLayout.setOnTouchListener(this);
        appInfoLayout.setOnTouchListener(this);
        findLocalGuidesLayout.setOnTouchListener(this);
        savedTrailsLayout.setOnTouchListener(this);
        allTrailsLayout.setOnTouchListener(this);

        userSignInTv = (TextView) view.findViewById(R.id.user_sign_in_tv);
        signInImg = (ImageView) view.findViewById(R.id.sign_in_img);

        if (mBaseActivity != null && mBaseActivity.getUserServiceManager() != null) {
            User user = mBaseActivity.getUserServiceManager().getUser();
            if (user != null && !user.isGuest()) {
                userSignInTv.setText(getResources().getString(R.string.my_profile));
            }
        }

        return view;
    }

    private void closeCurrentActivity() {
        if (!(HikeArmeniaApplication.currentActivity() instanceof HomeActivity)) {
//            mBaseActivity.overridePendingTransition(R.anim.slide_out_right,R.anim.slide_in_left);
            mBaseActivity.finish();

        }

    }

    @Override
    public void onResponseReceive(Object obj) {
        List<Trail> trailsList = (ArrayList<Trail>) obj;
        ((HomeActivity) mBaseActivity).updateData(trailsList);
        UIUtil.hideProgressDialog(mBaseActivity);
    }

    @Override
    public void onError(String message) {

    }

    @Override
    public void onDrawerLayoutClosed(View v) {
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if (v == null) {
            return false;
        }
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            v.setAlpha(0.5f);
            switch (v.getId()) {
                case R.id.sign_in:
                    if (!(HikeArmeniaApplication.currentActivity() instanceof AuthActivity) && !(HikeArmeniaApplication.currentActivity() instanceof ProfileActivity)) {
                        if (mBaseActivity.getUserServiceManager().getUser() != null && mBaseActivity.getUserServiceManager().getUser().isGuest()) {
                            Intent intent = new Intent(mBaseActivity, AuthActivity.class);
                            mBaseActivity.startActivityForResult(intent, 2);
                            mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
                            mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.SIGN_IN);
                        } else {
                            Intent intent = new Intent(mBaseActivity, ProfileActivity.class);
                            mBaseActivity.startActivityForResult(intent, 2);
                            mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
                            mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.MY_PROFILE);
                        }
                        closeCurrentActivity();
                    } else {
                        mBaseActivity.drawerLayout.closeDrawers();
                    }
                    mBaseActivity.drawerLayout.closeDrawers();
                    break;
                case R.id.compass:
                    mBaseActivity.drawerLayout.closeDrawers();

                    if (!(HikeArmeniaApplication.currentActivity() instanceof CompassActivity)) {
                        Intent intentCompass = new Intent(mBaseActivity, CompassActivity.class);
                        mBaseActivity.startActivityForResult(intentCompass, 2);
                        mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);

                    }
                    mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.COMPASS);
                    break;
                case R.id.offline_trails:
                    if (HikeArmeniaApplication.currentActivity() instanceof MapsActivity ||
                            HikeArmeniaApplication.currentActivity() instanceof CompassActivity ||
                            HikeArmeniaApplication.currentActivity() instanceof FindLocalGuidesActivitiy ||
                            HikeArmeniaApplication.currentActivity() instanceof AboutActivity ||
                            HikeArmeniaApplication.currentActivity() instanceof ProfileActivity ||
                            HikeArmeniaApplication.currentActivity() instanceof AuthActivity) {
                        Intent intent = new Intent(mBaseActivity, HomeActivity.class);
                        intent.putExtra("offlinemode", true);
                        startActivity(intent);
                        mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);

                    } else {
                        mBaseActivity.drawerLayout.closeDrawers();

                    }
                    mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.OFFLINE_TRAILS);

                    break;
                case R.id.find_local_guides:
                    Intent intent;
                    if (!(HikeArmeniaApplication.currentActivity() instanceof FindLocalGuidesActivitiy)) {
                        intent = new Intent(mBaseActivity, FindLocalGuidesActivitiy.class);
                        mBaseActivity.startActivityForResult(intent, 2);
                        mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
                        closeCurrentActivity();
                    } else {
                        mBaseActivity.drawerLayout.closeDrawers();
                    }
                    mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.FIND_LOCAL_GUIDES);
                    break;
                case R.id.app_info:
                    if (!(HikeArmeniaApplication.currentActivity() instanceof AboutActivity)) {
                        mBaseActivity.startActivityForResult(new Intent(mBaseActivity, AboutActivity.class), 2);
                        mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);

                    } else {
                        mBaseActivity.drawerLayout.closeDrawers();
                    }
                    mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.APP_INFO);
                    break;
                case R.id.all_trails:
                    mBaseActivity.savedTrails(false);
                    mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.ALL_TRAILS);
                    if (!(HikeArmeniaApplication.currentActivity() instanceof HomeActivity)) {
                        if (HikeArmeniaApplication.currentActivity() instanceof MapsActivity) {

                            HomeActivity.isFromMapACtivity = 0;
                            Intent intnet = new Intent(mBaseActivity, HomeActivity.class);
                            intnet.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                            startActivity(intnet);
                            mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
                        }
                        mBaseActivity.setResult(ResultCodes.RESULT_CODE_ALL_TRAIL);
                        mBaseActivity.drawerLayout.closeDrawers();
                        closeCurrentActivity();

                    } else {
                        mBaseActivity.drawerLayout.closeDrawers();
                        if (Util.isNetworkAvailable(mBaseActivity, true)) {
                            mBaseActivity.getTrailServicsManager().getListOfTrails(this);
                            UIUtil.showProgressDialog(mBaseActivity);
                        }

                    }
                    mBaseActivity.drawerLayout.closeDrawers();
                    break;
                case R.id.saved_trails:
                    if (mBaseActivity.getUserServiceManager().getUser() != null && mBaseActivity.getUserServiceManager().getUser().getToken() != null) {
                        mBaseActivity.savedTrails(true);
                        mLeftSlideMenuOnItemClickListener.getSelectedItem(BaseActivity.LeftSlideItems.SAVED_TRAILS);
                        if (!(HikeArmeniaApplication.currentActivity() instanceof HomeActivity)) {
                            if (HikeArmeniaApplication.currentActivity() instanceof MapsActivity) {

                                HomeActivity.isFromMapACtivity = 0;
                                Intent intnet = new Intent(mBaseActivity, HomeActivity.class);
                                intnet.putExtra("map", "save");
                                intnet.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                                startActivity(intnet);
                                mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);

                            } else {
                                mBaseActivity.setResult(ResultCodes.SAVED_TRAIL_CODE);
                            }
                        } else {
                            mBaseActivity.drawerLayout.closeDrawers();
                        }
                    } else {
                        if (!(HikeArmeniaApplication.currentActivity() instanceof AuthActivity)) {
                            intent = new Intent(mBaseActivity, AuthActivity.class);
                            mBaseActivity.startActivityForResult(intent, 2);
                            mBaseActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
                        } else {
                            mBaseActivity.drawerLayout.closeDrawers();
                        }

                    }
                    if (!(HikeArmeniaApplication.currentActivity() instanceof AuthActivity)) {
                        closeCurrentActivity();
                    }
                    mBaseActivity.closeDrawer();
                    break;
            }
        } else if (event.getAction() == MotionEvent.ACTION_UP) {
            v.setAlpha(1f);
        }
        return true;
    }
}
