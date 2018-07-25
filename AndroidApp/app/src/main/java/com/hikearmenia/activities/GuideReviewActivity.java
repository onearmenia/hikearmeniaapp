package com.hikearmenia.activities;

import android.annotation.TargetApi;
import android.content.Intent;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.widget.CardView;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.hikearmenia.R;
import com.hikearmenia.adapters.GuideLanguagesAdapter;
import com.hikearmenia.adapters.GuideReviewAdapter;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.fragment.WriteReviewFragment;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Guide;
import com.hikearmenia.models.api.GuideReview;
import com.hikearmenia.ui.RatingBar;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.SlidingActivity;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

import java.util.List;

public class GuideReviewActivity extends SlidingActivity implements NetworkRequestListener, View.OnTouchListener {

    int guideId;
    WriteReviewFragment writeReviewFragment;
    boolean isOpenWriteReview = false;
    private RecyclerView recyclerView;
    private EditText title;
    private LinearLayoutManager mLayoutManager;
    private CardView contentItem;
    private RelativeLayout addAnotherGuideLayout;
    private ImageView homePage;
    private TextView saveBtn;
    private RelativeLayout leftIconLayoutToolbar;
    private RelativeLayout guideReviewLayout;
    private ImageView leftIconToolbar;
    private String type = "";
    private String from = "";
    private Guide guide;
    private TextView bottomBtnText;
    private ImageView addReviewIcon;
    private ImageView sendEmail;
    private ImageView callImage;

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_guide_review);
        title = (EditText) findViewById(R.id.toolbar_title);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            title.setLetterSpacing(0.15f);
        }

        title.setTextColor(getResources().getColor(R.color.toolbar_title_color));
        saveBtn = (TextView) findViewById(R.id.save);
        saveBtn.setVisibility(View.GONE);
        homePage = (ImageView) findViewById(R.id.home_screen);
        homePage.setVisibility(View.VISIBLE);
        saveBtn.setOnTouchListener(this);
        guideId = getIntent().getIntExtra("guideId", 0);
        type = getIntent().getStringExtra("type");
        bottomBtnText = (TextView) findViewById(R.id.view);
        addReviewIcon = (ImageView) findViewById(R.id.add_review_icon);
        contentItem = (CardView) findViewById(R.id.content_item);
        contentItem.setVisibility(View.GONE);
        leftIconLayoutToolbar = (RelativeLayout) findViewById(R.id.home_icon);
        leftIconLayoutToolbar.setOnTouchListener(this);
        leftIconToolbar = (ImageView) findViewById(R.id.home);
        leftIconToolbar.setImageResource(R.mipmap.back_trails);
        homePage.setOnTouchListener(this);
        guideReviewLayout = (RelativeLayout) findViewById(R.id.guide_review_layout);

        if (Util.isNetworkAvailable(this, true)) {
            UIUtil.showProgressDialog(this);
            getGuideReviewsManager().getGuidDetailInfo(this, guideId);
        }

        recyclerView = (RecyclerView) findViewById(R.id.reviews_guides_list);
        mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        addAnotherGuideLayout = (RelativeLayout) findViewById(R.id.add_another_guide_layout);
        addAnotherGuideLayout.setAlpha(1f);
        initToolbar();
        title.setText(getString(R.string.guide_info));
        addAnotherGuideLayout.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        v.setAlpha(0.7f);
                        break;
                    case MotionEvent.ACTION_UP:
                        v.setAlpha(1f);
                        if (Util.isNetworkAvailable(GuideReviewActivity.this, true)) {
                            if (getUserServiceManager().getUser().isGuest()) {
                                Intent intnet = new Intent(GuideReviewActivity.this, AuthActivity.class);
                                IntentUtils.getInstance().startActivityForResult(GuideReviewActivity.this, 2, intnet, null, false);
                            } else {
                                setFragment(GuideReviewActivity.this, writeReviewFragment, R.id.root_content);
                                if (guide != null) {
                                    title.setText(guide.getGuideFirstname() + " " + guide.getGuideLastName());
                                }
                                homePage.setVisibility(View.GONE);
                                saveBtn.setVisibility(View.VISIBLE);
                            }
                        }
                        break;
                }
                return true;
            }
        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (resultCode) {
            case ResultCodes.RESULT_CODE_ALL_TRAIL:
                setResult(ResultCodes.RESULT_CODE_ALL_TRAIL);
                finish();
                break;
            case ResultCodes.RESULT_CODE_SAVED_TRAIL:
                setResult(ResultCodes.RESULT_CODE_SAVED_TRAIL);
                finish();
                break;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        HikeArmeniaApplication.setCurrentActivity(this);
    }

    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
    }

    private void initGuide() {
        int width = Util.getDisplayWidth(this);
        ImageView guideImage = (ImageView) findViewById(R.id.guide_image);
        TextView guideName = (TextView) findViewById(R.id.guid_name);
        TextView reviewCount = (TextView) findViewById(R.id.reViews);
        RelativeLayout ratinBar = (RelativeLayout) findViewById(R.id.rating_bar);
        RecyclerView flagView = (RecyclerView) findViewById(R.id.flag_recycler);
        sendEmail = (ImageView) findViewById(R.id.send_email);
        callImage = (ImageView) findViewById(R.id.call_img);
        if (guide.getGuidePhone().isEmpty() || guide.getGuidePhone() == null) {
            callImage.setColorFilter(new
                    PorterDuffColorFilter(getResources().getColor(R.color.black_40_percent), PorterDuff.Mode.MULTIPLY));
        }
        if (TextUtils.isEmpty(guide.getGuideEmail())) {
            sendEmail.setColorFilter(new
                    PorterDuffColorFilter(getResources().getColor(R.color.black_40_percent), PorterDuff.Mode.MULTIPLY));
        }
        View underView = (View) findViewById(R.id.under_view);
        underView.setVisibility(View.GONE);
        TextView desc = (TextView) findViewById(R.id.text_gide_desc);
        desc.setText(guide.getDescription());
        if (guide.getReviewCount() == 1) {
            reviewCount.setText(String.format(getString(R.string.one_review_guides), guide.getReviewCount()));
        } else {
            reviewCount.setText(String.format(getString(R.string.reviews_guides), guide.getReviewCount()));
        }
        guideName.setText(guide.getGuideFirstname() + " " + guide.getGuideLastName());
        Glide.with(this)
                .load(guide.getGuideImage())
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .centerCrop()
                .into(guideImage);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        GuideLanguagesAdapter adapter = new GuideLanguagesAdapter(this, guide);
        flagView.setAdapter(adapter);
        flagView.setLayoutManager(layoutManager);
        RatingBar ratingBar = new RatingBar(this, ratinBar);
        ratingBar.getParams(((int) (width * 0.04)), ((int) (width * 0.04)), guide.getAverageRating(), false);
        assert sendEmail != null;
        sendEmail.setOnTouchListener(this);

        assert callImage != null;
        callImage.setOnTouchListener(this);
    }

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

        toolbar.setContentInsetsAbsolute(0, 0);
        EditText toolbarTitleText = (EditText) findViewById(R.id.toolbar_title);
        toolbarTitleText.setVisibility(View.VISIBLE);
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        return false;
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onResponseReceive(Object obj) {
        guide = (Guide) obj;
        initGuide();
        writeReviewFragment = WriteReviewFragment.getInstance(this, guide.getGuideId(), "addGuidReview");
        List<GuideReview> guideReviewList = guide.getGuideReviews();
        if (type.equals("guidReview")) {
            title.setText(getString(R.string.guide_info));
            contentItem.setVisibility(View.VISIBLE);
        }

        if (guideReviewList.size() > 0) {
            GuideReviewAdapter mAdapter = new GuideReviewAdapter(this, guideReviewList);
            UIUtil.hideProgressDialog(this);
            contentItem.setVisibility(View.VISIBLE);
            recyclerView.setAdapter(mAdapter);
            guideReviewLayout.setVisibility(View.VISIBLE);
            recyclerView.setLayoutManager(mLayoutManager);
        } else {
            String text = guide.getGuideFirstname() + " " + guide.getGuideLastName() + " " + getString(R.string.empty_review_text);
            TextView textView = (TextView) findViewById(R.id.does_not_have_reviews_tv);
            textView.setText(text);
            textView.setVisibility(View.VISIBLE);
            bottomBtnText.setText(R.string.add_guide_review);
            UIUtil.hideProgressDialog(this);
        }

        addReviewIcon.setVisibility(View.VISIBLE);
        bottomBtnText.setVisibility(View.VISIBLE);
    }

    @Override
    public void onError(String message) {
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_right_exit, R.anim.slide_left_exit);
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (v.getId()) {
            case R.id.save:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(GuideReviewActivity.this, true)) {
                            if (!writeReviewFragment.getReviewText().equals("") && writeReviewFragment.getRetingBarValue() > 0) {
                                writeReviewFragment.sendData("addGuidReview");
                                saveBtn.setVisibility(View.GONE);
                                homePage.setVisibility(View.VISIBLE);
                            } else {
                                UIUtil.alertDialogShow(GuideReviewActivity.this, getString(R.string.warning), getString(R.string.review_screen_warning_message));
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
                        Intent intent = new Intent(GuideReviewActivity.this, HomeActivity.class);
                        startActivity(intent);
//                        finish();
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.home_icon:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (writeReviewFragment != null) {
                            if (writeReviewFragment.isVisible()) {
                                title.setText(getString(R.string.guide_info));
                                saveBtn.setVisibility(View.GONE);
                                homePage.setVisibility(View.VISIBLE);
                                getSupportFragmentManager().beginTransaction()
                                        .setCustomAnimations(R.anim.slide_out_left, R.anim.slide_out_right)
                                        .remove(writeReviewFragment)
                                        .commit();
                            } else {
                                onBackPressed();
                                overridePendingTransition(R.anim.slide_right_exit, R.anim.slide_left_exit);
                            }
                        } else {
                            finish();
                        }

                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.send_email:

                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (!guide.getGuideEmail().isEmpty() && guide.getGuideEmail() != null) {
                            Intent emailIntent = new Intent(Intent.ACTION_SENDTO, Uri.fromParts(
                                    "mailto", guide.getGuideEmail(), null));
                            emailIntent.putExtra(Intent.EXTRA_SUBJECT, "Hike Armenia");
                            try {
                                startActivity(Intent.createChooser(emailIntent, "Send email..."));
                            } catch (Exception e) {
                                UIUtil.alertDialogShow(GuideReviewActivity.this, getString(R.string.could_not_send_email), getString(R.string.could_not_send_email_message));
                            }
                        }
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.call_img:
                if (!guide.getGuidePhone().isEmpty() && guide.getGuidePhone() != null) {

                    Intent intent = new Intent(Intent.ACTION_DIAL);
                    intent.setData(Uri.parse("tel:" + guide.getGuidePhone()));
                    startActivity(intent);
                }
                break;


        }
        return false;
    }
}
