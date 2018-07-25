package com.hikearmenia.activities;

import android.annotation.TargetApi;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.adapters.TrailTipsAdapter;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.fragment.WriteReviewFragment;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.TrailReview;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.SlidingActivity;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by anikarapetyan1 on 5/23/16.
 */
public class TrailTipsActivity extends SlidingActivity implements NetworkRequestListener, View.OnTouchListener {
    EditText title;
    RecyclerView recyclerView;
    List<TrailReview> trailReviewList;
    TextView trailNameTV;
    RelativeLayout leftIconLayoutToolbar;
    RelativeLayout addAnotherGuideLayout;
    WriteReviewFragment writeReviewFragment;
    String type = "";
    private ImageView homePage;
    private TextView saveBtn;
    private ImageView leftIconToolbar;
    private boolean isOfflineTrail;
    private String trailName;
    private int trailId;

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_trail_reviews);
        isOfflineTrail = getIntent().getBooleanExtra("isOfflineTrail", false);
        trailId = getIntent().getIntExtra("trailId", 0);
        if (!isOfflineTrail) {
            Util.isNetworkAvailable(this, true);
            writeReviewFragment = WriteReviewFragment.getInstance(this, getTrailServicsManager().getmTrail().getTrailId(), "addTrailReview");
        } else {
            writeReviewFragment = WriteReviewFragment.getInstance(this, trailId, "addTrailReview");
        }
        trailName = getIntent().getStringExtra("trailName");
        type = getIntent().getStringExtra("type");
        initToolbar();

        leftIconLayoutToolbar = (RelativeLayout) findViewById(R.id.home_icon);
        leftIconLayoutToolbar.setOnTouchListener(this);
        leftIconToolbar = (ImageView) findViewById(R.id.home);
        leftIconToolbar.setImageResource(R.mipmap.back_trails);
        saveBtn = (TextView) findViewById(R.id.save);
        saveBtn.setText(getString(R.string.send));
        saveBtn.setTypeface(null, Typeface.BOLD);
        saveBtn.setOnTouchListener(this);
        homePage = (ImageView) findViewById(R.id.home_screen);
        homePage.setOnTouchListener(this);
        homePage.setVisibility(View.VISIBLE);
        saveBtn.setVisibility(View.GONE);


        if (getIntent().hasExtra("type") && type.equals("addTrailReview")) {
            if (isOfflineTrail) {
                title.setText(trailName);
            } else {
                title.setText(getTrailServicsManager().getmTrail().getTrailName());
            }
            android.support.v4.app.FragmentTransaction fragmentTransaction = getSupportFragmentManager().beginTransaction();
            fragmentTransaction.replace(R.id.root_content, writeReviewFragment);
            fragmentTransaction.commit();
            homePage.setVisibility(View.GONE);
            saveBtn.setVisibility(View.VISIBLE);
        } else {
            if (isOfflineTrail) {
                recyclerView = (RecyclerView) findViewById(R.id.trail_tips_list);
                trailReviewList = getIntent().getParcelableArrayListExtra("trailReview");
                LinearLayoutManager mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
                TrailTipsAdapter mAdapter = new TrailTipsAdapter(this, trailReviewList);
                recyclerView.setAdapter(mAdapter);
                recyclerView.setLayoutManager(mLayoutManager);
            } else {
                getTrailServicsManager().loadTrailReviews(getTrailServicsManager().getmTrail().getTrailId(), this);
                UIUtil.showProgressDialog(this);
            }
        }

        addAnotherGuideLayout = (RelativeLayout) findViewById(R.id.add_another_guide_layout);
        addAnotherGuideLayout.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        v.setAlpha(0.7f);
                        break;
                    case MotionEvent.ACTION_UP:
                        v.setAlpha(1f);
                        if (getUserServiceManager().getUser().isGuest()) {
                            Intent intnet = new Intent(TrailTipsActivity.this, AuthActivity.class);
                            IntentUtils.getInstance().startActivity(TrailTipsActivity.this, intnet);
                        } else {
                            if (isOfflineTrail) {
                                title.setText(trailName);
                            } else {
                                title.setText(getTrailServicsManager().getmTrail().getTrailName());
                            }
                            setTitleTextSize();
                            setFragment(TrailTipsActivity.this, writeReviewFragment, R.id.root_content);
                            homePage.setVisibility(View.GONE);
                            saveBtn.setVisibility(View.VISIBLE);
                            break;
                        }
                }
                return true;
            }
        });
        trailNameTV = (TextView) findViewById(R.id.trail_name_tv);
        Intent intent = getIntent();
        if (isOfflineTrail) {
            trailNameTV.setText(trailName);
        } else {
            trailNameTV.setText(getTrailServicsManager().getmTrail().getTrailName());
        }
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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        /*if (requestCode == REQUEST_CODE) {
            if(resultCode == Activity.RESULT_OK){
                finish();
            }
            if (resultCode == Activity.RESULT_CANCELED) {
                //Write your code if there's no result
            }
        }*/
    }//onActivityResult

    @Override
    public void onResponseReceive(Object obj) {
        UIUtil.hideProgressDialog(this);
        if (obj != null) {
            trailReviewList = (ArrayList<TrailReview>) obj;
            recyclerView = (RecyclerView) findViewById(R.id.trail_tips_list);
            LinearLayoutManager mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
            TrailTipsAdapter mAdapter = new TrailTipsAdapter(this, trailReviewList);
            // TrailTipsAdapter mAdapter.setOnItemClickListener(onItemClickListener);
            recyclerView.setAdapter(mAdapter);
            recyclerView.setLayoutManager(mLayoutManager);
        }

    }

    @Override
    public void onError(String message) {

    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        getSupportActionBar().setHomeButtonEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        getSupportActionBar().setDisplayHomeAsUpEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        getSupportActionBar().setDisplayShowCustomEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        title = (EditText) findViewById(R.id.toolbar_title);
        title.measure(0, 0);
        title.setWidth((int) (Util.getDisplayWidth(this) / 1.33));
        title.setText(getString(R.string.trail_tips));
        setTitleTextSize();
        toolbar.setContentInsetsAbsolute(0, 0);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            title.setLetterSpacing(0.15f);
        }
        title.setTextColor(getResources().getColor(R.color.toolbar_title_color));

    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_right_exit, R.anim.slide_left_exit);

    }

    private void setTitleTextSize() {
        if (!isOfflineTrail) {
            trailName = getTrailServicsManager().getmTrail().getTrailName();
        }
        if (trailName.length() >= 23) {
            title.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18);
        } else {
            title.setTextSize(TypedValue.COMPLEX_UNIT_SP, 23);
        }
    }


    @Override
    public boolean onTouch(View v, MotionEvent event) {

        switch (v.getId()) {
            case R.id.save:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(TrailTipsActivity.this, true)) {
                            if (!writeReviewFragment.getReviewText().equals("") && writeReviewFragment.getRetingBarValue() > 0) {
                                writeReviewFragment.sendData("addTrailReview");
                                homePage.setVisibility(View.VISIBLE);
                                saveBtn.setVisibility(View.GONE);
                                getSupportFragmentManager().beginTransaction()
                                        .setCustomAnimations(R.anim.slide_out_left, R.anim.slide_out_right)
                                        .remove(writeReviewFragment)
                                        .commit();
                            } else {
                                UIUtil.alertDialogShow(TrailTipsActivity.this, getString(R.string.warning), getString(R.string.warning_please_fill_trail_tip));
                            }
                        }
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.home_screen:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        setResult(ResultCodes.RESULT_CODE_HOME_OK);
                        finish();
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.home_icon:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (getIntent().hasExtra("type") && getIntent().getStringExtra("type").equals("addTrailReview")) {
                            onBackPressed();
                        } else if (writeReviewFragment.isVisible()) {
                            saveBtn.setVisibility(View.GONE);
                            homePage.setVisibility(View.VISIBLE);
                            getSupportFragmentManager().beginTransaction()
                                    .setCustomAnimations(R.anim.slide_out_left, R.anim.slide_out_right)
                                    .remove(writeReviewFragment)
                                    .commit();
                        } else {
                            onBackPressed();
                        }
                        onBackPressed();
                        overridePendingTransition(R.anim.slide_right_exit, R.anim.slide_left_exit);
                    }
                }).playOn(v, LONG_DURETION);
                break;
        }
        return false;
    }
}
