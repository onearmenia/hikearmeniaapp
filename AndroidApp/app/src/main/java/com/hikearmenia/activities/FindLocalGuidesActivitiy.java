package com.hikearmenia.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.adapters.LocalGuidesListAdapter;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Guide;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class FindLocalGuidesActivitiy extends BaseActivity implements NetworkRequestListener, View.OnTouchListener {
    private final int RESULT_CODE = 2;
    TextView title;
    RecyclerView recyclerView;
    List<Guide> guideArrayList;
    TextView saveBtn;
    String type;
    int REQUEST_CODE = 2;

    /*toolbar Views*/
    RelativeLayout leftIconLayoutToolbar;
    ImageView leftIconToolbar;
    RelativeLayout rightIconLayoutToolbar;
    ImageView rightIconToolbar;
    ImageView toolbarTitleImg;
    Trail trail;
    private boolean isOfflineOn;
    LocalGuidesListAdapter.OnItemClickListener onItemClickListener = new LocalGuidesListAdapter.OnItemClickListener() {
        public void onItemClick(View v, int position) {
            if (isOfflineOn) {
                Intent intent = new Intent(FindLocalGuidesActivitiy.this, GuideReviewActivity.class);
                intent.putExtra("guideId", guideArrayList.get(position).getGuideId());
                intent.putExtra("type", "guidReview");
                IntentUtils.getInstance().startActivityPendingTransition(FindLocalGuidesActivitiy.this, REQUEST_CODE, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);
            } else if (Util.isNetworkAvailable(FindLocalGuidesActivitiy.this, true)) {
                Intent intent = new Intent(FindLocalGuidesActivitiy.this, GuideReviewActivity.class);
                intent.putExtra("guideId", guideArrayList.get(position).getGuideId());
                intent.putExtra("type", "guidReview");
                IntentUtils.getInstance().startActivityPendingTransition(FindLocalGuidesActivitiy.this, REQUEST_CODE, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);

            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_find_local_guides);
        initDrawerLayout();
        isOfflineOn = getIntent().getBooleanExtra("isOfflineOn", false);

        saveBtn = (TextView) findViewById(R.id.save);
        title = (TextView) findViewById(R.id.toolbar_title);
        type = getIntent().getStringExtra("From");
        initToolbar();
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
        toolbarTitleImg = (ImageView) findViewById(R.id.toolbar_title_img);
        toolbarTitleImg.setVisibility(View.GONE);
        if (isOfflineOn && !Util.isNetworkAvailable(this, false)) {
            String trailId = String.valueOf(getIntent().getIntExtra("TrailId", 3));

            try {
                trail = getTrailById(TrailDetailActivity.laodTrailFile(this, TrailDetailActivity.KEY), trailId);
                guideArrayList = trail.getGuides();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
            leftIconToolbar.setImageResource(R.mipmap.back_trails);
            title.setText(trail.getTrailName() + " Guides");
            UIUtil.hideProgressDialog(this);
            recyclerView = (RecyclerView) findViewById(R.id.local_guides_list);
            LinearLayoutManager mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
            LocalGuidesListAdapter mAdapter = new LocalGuidesListAdapter(this, guideArrayList);
            mAdapter.setOnItemClickListener(onItemClickListener);
            recyclerView.setAdapter(mAdapter);
            recyclerView.setLayoutManager(mLayoutManager);
        } else if (Util.isNetworkAvailable(this, true)) {
            UIUtil.showProgressDialog(this);
            if (getIntent().hasExtra("From") && type.equals("TrailDetail")) {
                leftIconToolbar.setImageResource(R.mipmap.back_trails);
                title.setText(getTrailServicsManager().getmTrail().getTrailName() + " Guides");
                guideArrayList = TrailDetailActivity.guides;
                getListOfGuideByTrailID(this, String.valueOf(getIntent().getIntExtra("TrailId", 0)));
            } else {
                setResult(ResultCodes.RESULT_CODE_HOME_OK);
                getListOfGuide(this);
                title.setText(getString(R.string.local_guides));
            }
        }
        title.setTextColor(getResources().getColor(R.color.toolbar_title_color));
    }

    @Override
    protected void onResume() {
        super.onResume();
        HikeArmeniaApplication.setCurrentActivity(this);
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.toolbar_menu, menu);

        MenuItem item = menu.findItem(R.id.toolbar_menu_item);
        item.setIcon(R.mipmap.stack_trail);
        item.setVisible(false);
        return true;
    }

    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case android.R.id.home:
                if (getIntent().hasExtra("From") && type.equals("TrailDetail")) {
                    onBackPressed();
                } else if (drawerLayout != null) {
                    if (getIntent().hasExtra("From") && type.equals("TrailDetail")) {
                        onBackPressed();
                        overridePendingTransition(R.anim.slide_right_exit, R.anim.slide_left_exit);
                    } else if (drawerLayout != null) {
                        drawerLayout.openDrawer(Gravity.LEFT);
                    }

                }
                return true;
            case R.id.toolbar_menu_item:
                setResult(ResultCodes.RESULT_CODE_HOME_OK);
                finish();
                return true;
            default:
                return false;
        }
    }

    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode != ResultCodes.RESULT_CODE_IGNORE) {
            if (resultCode == ResultCodes.RESULT_CODE_ALL_TRAIL || resultCode == ResultCodes.RESULT_CODE_SAVED_TRAIL) {
                finish();
            }
            setResult(resultCode);

        }
    }

    @Override
    public void onResponseReceive(Object obj) {
        guideArrayList = (ArrayList<Guide>) obj;
        UIUtil.hideProgressDialog(this);
        recyclerView = (RecyclerView) findViewById(R.id.local_guides_list);
        LinearLayoutManager mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        LocalGuidesListAdapter mAdapter = new LocalGuidesListAdapter(this, guideArrayList);
        mAdapter.setOnItemClickListener(onItemClickListener);
        recyclerView.setAdapter(mAdapter);
        recyclerView.setLayoutManager(mLayoutManager);
    }

    @Override
    public void onError(String message) {
        UIUtil.hideProgressDialog(this);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        if (getIntent().hasExtra("From") && type.equals("TrailDetail")) {
            overridePendingTransition(R.anim.slide_right_exit, R.anim.slide_left_exit);
        }
    }


    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (v.getId()) {
            case R.id.toolbar_left_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (getIntent().hasExtra("From") && type.equals("TrailDetail")) {
                            onBackPressed();
                            overridePendingTransition(R.anim.slide_right_exit, R.anim.slide_left_exit);
                        } else if (drawerLayout != null) {
                            drawerLayout.openDrawer(Gravity.LEFT);
                        }
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.toolbar_right_icon_layout:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        setResult(ResultCodes.RESULT_CODE_HOME_OK);
                        finish();
                    }
                }).playOn(v, LONG_DURETION);
                break;
        }
        return false;
    }

    private Trail getTrailById(List<Trail> trails, String trailId) {
        for (Trail trail :
                trails) {
            if (trailId.equals(String.valueOf(trail.getTrailId()))) {
                return trail;
            }
        }
        return null;
    }

}
