package com.hikearmenia.activities;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.transition.Slide;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.view.animation.ScaleAnimation;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Switch;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.google.common.base.CharMatcher;
import com.hikearmenia.R;
import com.hikearmenia.adapters.CaruselPagerAdapter;
import com.hikearmenia.adapters.EndLessAdapter;
import com.hikearmenia.adapters.LocalGuidesListAdapter;
import com.hikearmenia.adapters.TrailTipsAdapter;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.fragment.AccomodationFragment;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Accomodation;
import com.hikearmenia.models.api.Guide;
import com.hikearmenia.models.api.Response;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.ui.ProgressBarUI;
import com.hikearmenia.ui.RatingBar;
import com.hikearmenia.ui.widgets.CirclePageIndicator;
import com.hikearmenia.ui.widgets.CustomScrollView;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.ui.widgets.InfinitePageIndicator;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.SlidingActivity;
import com.hikearmenia.util.SlidingLayout;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;
import com.nineoldandroids.animation.ValueAnimator;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Ani Karapetyan on 5/16/16.
 */

public class TrailDetailActivity extends SlidingActivity implements
        NetworkRequestListener<Trail>, View.OnTouchListener, View.OnClickListener {


    public static final String KEY = "my_key_for_save";
    private static final String EXTRA_IMAGE = "com.antonioleiva.materializeyourapp.extraImage";
    public static int PAGES;
    public static int LOOPS = 1000;
    public static int FIRST_PAGE;
    public static String trailId;
    public static List<Guide> guides;
    private static int REQUEST_CODE_BACK = 119;
    public ViewPager accomodationSlider;
    /* private AppBarLayout appbar;*/
    public ImageView blurToolbarImage;
    LinearLayout offlinemodetextView;
    private int resultCode;
    /* CollapsingToolbarLayout collapsingToolbarLayout;*/
    private ViewPager mImageSlider;
    private Trail mTrail;
    private int RESULTST_CODE = 2;
    private RecyclerView trailTipsRecyclerView;
    private RelativeLayout addAnotherTrailTip;
    private LinearLayout savedTrailsLayout;
    private LinearLayout takePhotoLayout;
    private LinearLayout weaterInfo;
    private RelativeLayout leftIconLayoutToolbar;
    private RelativeLayout mZoomMap;
    private TextView weather;
    private RelativeLayout trailDetailImage;
    private ImageView savedTrailIcon;
    private ImageView mapUrlImage;
    private ImageView shareIcon;
    private ImageView weatherImage;
    private TextView addTrailTip;
    private TextView trailName;
    private EditText collapsedTitile;
    private TextView LocalGuideTitle;
    private int width;
    private LinearLayout colapsContent;
    private EndLessAdapter endLessAdapter;
    private List<Bitmap> bitmapList;
    private RelativeLayout back;
    /*private RelativeLayout contentViews;*/
    private CustomScrollView nestedScrollView;
    private LinearLayout descProgress;
    private LinearLayout infoProgress;
    private TextView information;
    private TextView description;
    private Switch offlineSwitcher;
    public boolean isOfflineModeOn;
    public static List<Trail> offlineTrails;
    private boolean isSwitchChecked;
    private SharedPreferences sharedPreferences;

    public static void initImageLoader(Context context) {

        ImageLoaderConfiguration.Builder config = new ImageLoaderConfiguration.Builder(context);
        config.threadPriority(Thread.NORM_PRIORITY - 2);
        config.denyCacheImageMultipleSizesInMemory();
        config.diskCacheFileNameGenerator(new Md5FileNameGenerator());
        config.diskCacheSize(50 * 1024 * 1024); // 50 MiB
        config.tasksProcessingOrder(QueueProcessingType.LIFO);
        config.writeDebugLogs(); // Remove for release app

        // Initialize ImageLoader with configuration.
        com.nostra13.universalimageloader.core.ImageLoader.getInstance().init(config.build());
    }

    public static List<Trail> laodTrailFile(Context context, String key) throws IOException, ClassNotFoundException {
        FileInputStream fis = context.openFileInput(key);
        ObjectInputStream ois = new ObjectInputStream(fis);
        return (List<Trail>) ois.readObject();
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initActivityTransitions();
        try {
            initOfflineTrailList();
        } catch (IOException e) {
            offlineTrails = new ArrayList<>();
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            offlineTrails = new ArrayList<>();
            e.printStackTrace();
        }
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        bitmapList = new ArrayList<>();
        setContentView(R.layout.activity_trail_detail);
        nestedScrollView = (CustomScrollView) findViewById(R.id.scroll);
        int height = Util.getDisplayHeight(this);
        initProgressItems();
        initImageLoader(this);
        Toolbar tb = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(tb);

        RelativeLayout trailDetailLayout = (RelativeLayout) findViewById(R.id.trail_detail_layout);
        mImageSlider = (ViewPager) findViewById(R.id.image_pager);
        mImageSlider.getLayoutParams().height = (int) (height * 0.4);
        trailDetailLayout.getLayoutParams().height = (int) (height * 0.4);
        ScaleAnimation animation = new ScaleAnimation(1.2f, 1.0f, 1.2f, 1.0f);//Animation.RELATIVE_TO_PARENT, (float) (imageView.getX() + 45 * ssu) / width, Animation.RELATIVE_TO_PARENT, (float) (imageView.getY() + 45 * ssu) / (4 * height));
        animation.setDuration(800);
        mImageSlider.startAnimation(animation);
//        UIUtil.scaleView(trailDetailLayout, 0f, 2f);
        trailTipsRecyclerView = (RecyclerView) findViewById(R.id.trail_tips_list);

        accomodationSlider = (ViewPager) findViewById(R.id.accomodation_pager);
        setAccomPagerHeight();
        weaterInfo = (LinearLayout) findViewById(R.id.weater_info);
        takePhotoLayout = (LinearLayout) findViewById(R.id.bottom_menu_take_photo);
        takePhotoLayout.setOnTouchListener(this);
        savedTrailsLayout = (LinearLayout) findViewById(R.id.bottom_bar_saved_trails);
        savedTrailsLayout.setOnTouchListener(this);

        mZoomMap = (RelativeLayout) findViewById(R.id.full_screen_map);
        mZoomMap.setOnClickListener(this);

        colapsContent = (LinearLayout) findViewById(R.id.colaps_content);
        colapsContent.setVisibility(View.GONE);

        if (getIntent().hasExtra("trail_id") && getIntent().getStringExtra("trail_id") != null) {
            trailId = getIntent().getStringExtra("trail_id");
        }
        LocalGuideTitle = (TextView) findViewById(R.id.local_guides_title);
        LinearLayout findLocalGuides = (LinearLayout) findViewById(R.id.find_local_guides);
        findLocalGuides.setOnTouchListener(this);
        leftIconLayoutToolbar = (RelativeLayout) findViewById(R.id.home_icon);
        savedTrailIcon = (ImageView) findViewById(R.id.like_icon);

        collapsedTitile = (EditText) findViewById(R.id.collapsed_titile);
        collapsedTitile.setWidth((int) (Util.getDisplayWidth(this) / 1.6));
        shareIcon = (ImageView) findViewById(R.id.share_icon);
        shareIcon.setOnTouchListener(this);
        back = (RelativeLayout) findViewById(R.id.back_icon);
        back.setOnTouchListener(this);
        offlinemodetextView = (LinearLayout) findViewById(R.id.offline_mode_textview);

        List<String> fragment = new ArrayList<>();
        if (getIntent().getStringExtra("trail_first_img_url") != null) {
            fragment.add(getIntent().getStringExtra("trail_first_img_url"));
            endLessAdapter = new EndLessAdapter(this, fragment);

            mImageSlider.setAdapter(endLessAdapter);
            mImageSlider.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    doNotSlideActivity(event);
                    return false;
                }
            });
            CirclePageIndicator pageIndicator = (CirclePageIndicator) findViewById(R.id.pageIndicator);

            pageIndicator.setVisibility(View.INVISIBLE);
            //   mImageSlider.setCurrentItem(0);
            mImageSlider.setHorizontalFadingEdgeEnabled(false);

        }
        offlineSwitcher = (Switch) findViewById(R.id.offline_trails_switch);
        offlineSwitcher.setChecked(containsTrail(offlineTrails, trailId));
        if (!offlineSwitcher.isChecked()) {
            offlineSwitcher.setEnabled(false);

        } else {
            isOfflineModeOn = true;
            isSwitchChecked = true;
        }
        offlineSwitcher.setOnCheckedChangeListener(initCheckecedChangeListener());
        if (offlineSwitcher.isChecked() && !Util.isNetworkAvailable(this, false)) {
            try {
                initTrailData();
                initView();
                hideProgresDialogs();
                loadImages();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }

        } else {
            loadData();
        }

        colapsContent.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (!Util.isNetworkAvailable(TrailDetailActivity.this, false) && isSwitchChecked) {

                    Util.isNetworkAvailable(TrailDetailActivity.this, true);
                }
                return false;
            }

        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        HikeArmeniaApplication.setCurrentActivity(this);
        if (getBoolean()) {
            offlinemodetextView.setVisibility(View.VISIBLE);
        } else {
            offlinemodetextView.setVisibility(View.GONE);
        }
    }

    private void setAccomPagerHeight() {
        accomodationSlider.getLayoutParams().height = (int) (Util.getDisplayHeight(this) * 0.39);

    }

    private void loadData() {
        if (Util.isNetworkAvailable(this, true)) {
            getTrailServicsManager().loadDetailTrail(trailId, this);
        }

    }

    private void doNotSlideActivity(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN || event.getAction() == MotionEvent.ACTION_BUTTON_PRESS) {
            SlidingLayout.isSlid = false;
        } else if (event.getAction() == MotionEvent.ACTION_UP || event.getAction() == MotionEvent.ACTION_CANCEL) {
            SlidingLayout.isSlid = true;
        }
    }

    private void initView() {

        width = Util.getDisplayWidth(this);
        trailName = (TextView) findViewById(R.id.trail_name);
        weather = (TextView) findViewById(R.id.weather);
        weatherImage = (ImageView) findViewById(R.id.weather_image);
        mapUrlImage = (ImageView) findViewById(R.id.map_url_image);

        trailDetailImage = (RelativeLayout) findViewById(R.id.trail_detail_image);
        description = (TextView) findViewById(R.id.description);
        information = (TextView) findViewById(R.id.info_text);
        addAnotherTrailTip = (RelativeLayout) findViewById(R.id.add_another_trail_tip);
        addAnotherTrailTip.setOnTouchListener(this);
        RelativeLayout guidesLayout = (RelativeLayout) findViewById(R.id.local_guides_lay);
        RecyclerView guidesRecyclerView = (RecyclerView) findViewById(R.id.local_guides_list);
        TextView seeMoreGuide = (TextView) findViewById(R.id.see_more);
        TextView seeMoreTips = (TextView) findViewById(R.id.see_more_tips);
        TextView maxHeight = (TextView) findViewById(R.id.max_height);
        TextView minHeigth = (TextView) findViewById(R.id.min_height);
        TextView trailDifficulty = (TextView) findViewById(R.id.size);
        trailDifficulty.setText(mTrail.getTrailDifficulty());
        TextView trailDistance = (TextView) findViewById(R.id.trail_distance);
        trailDistance.setText(mTrail.getTrailDistance());

        if (!mTrail.getTrailMinHeight().equals("")) {
            String minText = CharMatcher.is('-').or(CharMatcher.DIGIT).retainFrom(mTrail.getTrailMaxHeight());
            String maxText = CharMatcher.is('-').or(CharMatcher.DIGIT).retainFrom(mTrail.getTrailMinHeight());
            maxHeight.setText(Util.setNumberFormat(minText));
            minHeigth.setText(Util.setNumberFormat(maxText));

        }
        if (mTrail.isSaved()) {
            savedTrailIcon.setImageResource(R.mipmap.heartred_trails);
        }
        addTrailTip = (TextView) findViewById(R.id.add_another_trail_tip_text);
        RelativeLayout ratingBar = (RelativeLayout) findViewById(R.id.rating_bar);
        RatingBar mRatingBar = new RatingBar(this, ratingBar);

        mRatingBar.getParams(((int) (width * 0.04)), ((int) (width * 0.04)), mTrail.getAverageRating(), true);

        if (mTrail.getReviews().size() > 0) {
            seeMoreTips.setVisibility(View.VISIBLE);
            trailTipsRecyclerView.setVisibility(View.VISIBLE);
        }
        if (mTrail.getReviewCount() > 0) {
            seeMoreTips.setVisibility(View.VISIBLE);
        }
        assert seeMoreTips != null;
        seeMoreTips.setOnTouchListener(new View.OnTouchListener() {
                                           @Override
                                           public boolean onTouch(View v, MotionEvent event) {
                                               YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                                                   @Override
                                                   public void call(Animator animator) {
                                                       if (isOfflineModeOn) {
                                                           if (Util.isNetworkAvailable(TrailDetailActivity.this, false)) {
                                                               Intent intent = new Intent(TrailDetailActivity.this, TrailTipsActivity.class);
                                                               intent.putExtra("trailId", getTrailServicsManager().getmTrail().getTrailId());
                                                               intent.putExtra("trailName", getTrailServicsManager().getmTrail().getTrailName());
                                                               intent.putExtra("type", TrailDetailActivity.class.getName());
                                                               intent.putExtra("isOfflineTrail", true);
                                                               IntentUtils.getInstance().startActivityPendingTransition(TrailDetailActivity.this, RESULTST_CODE, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);

                                                           } else
                                                               for (int i = 0; i < TrailDetailActivity.offlineTrails.size(); i++) {
                                                                   if (mTrail.getTrailId() == TrailDetailActivity.offlineTrails.get(i).getTrailId()) {
                                                                       Trail trail = TrailDetailActivity.offlineTrails.get(i);
                                                                       Intent intent = new Intent(TrailDetailActivity.this, TrailTipsActivity.class);
                                                                       intent.putExtra("trailId", trail.getTrailId());
                                                                       intent.putExtra("trailName", trail.getTrailName());
                                                                       intent.putExtra("type", TrailDetailActivity.class.getName());
                                                                       intent.putExtra("isOfflineTrail", true);
                                                                       intent.putParcelableArrayListExtra("trailReview", trail.getReviews());
                                                                       IntentUtils.getInstance().startActivityPendingTransition(TrailDetailActivity.this, RESULTST_CODE, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);

                                                                   }
                                                               }
                                                       } else if (Util.isNetworkAvailable(TrailDetailActivity.this, true)) {
                                                           Intent intent = new Intent(TrailDetailActivity.this, TrailTipsActivity.class);
                                                           intent.putExtra("trailId", getTrailServicsManager().getmTrail().getTrailId());
                                                           intent.putExtra("trailName", getTrailServicsManager().getmTrail().getTrailName());
                                                           intent.putExtra("type", TrailDetailActivity.class.getName());
                                                           intent.putExtra("isOfflineTrail", false);
                                                           IntentUtils.getInstance().startActivityPendingTransition(TrailDetailActivity.this, RESULTST_CODE, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);
                                                       }

                                                   }
                                               }).playOn(v, STANDART_DURETION);
                                               return false;
                                           }
                                       }


        );
        description.setText(mTrail.getTrailThingsToDo());
        information.setText(mTrail.getTrailInformation());
        trailName.setText(mTrail.getTrailName());
        if (mTrail.getWeather() != null) {
            weather.setText(mTrail.getWeather() + "°C");

            if (!mTrail.getweatherImageIcon().isEmpty() && mTrail.getweatherImageIcon() != null) {
                Glide.with(this)
                        .load(mTrail.getweatherImageIcon())
                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                        .centerCrop()
                        .into(weatherImage);
            }
        } else {
            weather.setVisibility(View.GONE);
            weatherImage.setVisibility(View.GONE);
        }

        if (mTrail.getMapUrl() != null) {
            DisplayImageOptions mOptions = new DisplayImageOptions.Builder()
                    .cacheInMemory(true)
                    .cacheOnDisk(true)
                    .showImageForEmptyUri(R.mipmap.placeholder)
                    .showImageOnLoading(R.mipmap.placeholder)
                    .showImageOnFail(R.mipmap.placeholder)
                    .imageScaleType(ImageScaleType.NONE)
                    .bitmapConfig(Bitmap.Config.RGB_565)
                    .build();
            com.nostra13.universalimageloader.core.ImageLoader.getInstance().displayImage(mTrail.getMapUrl(), mapUrlImage, mOptions);
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            startPostponedEnterTransition();
        }
        guidesLayout.setVisibility(View.VISIBLE);
        List<Guide> sendList = mTrail.getGuides();
        LinearLayoutManager mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        if (mTrail.getGuides().size() > 2) {
            sendList = new ArrayList<>();
            sendList.add(mTrail.getGuides().get(0));
            sendList.add(mTrail.getGuides().get(1));
        }

        LocalGuidesListAdapter mAdapter = new LocalGuidesListAdapter(this, sendList);
        mAdapter.setOnItemClickListener(new LocalGuidesListAdapter.OnItemClickListener() {
            @Override
            public void
            onItemClick(View view, int position) {
                if (Util.isNetworkAvailable(TrailDetailActivity.this, true) || isOfflineModeOn) {
                    Intent intent = new Intent(TrailDetailActivity.this, GuideReviewActivity.class);
                    intent.putExtra("guideId", mTrail.getGuides().get(position).getGuideId());
                    intent.putExtra("type", "TrailDetail");
                    IntentUtils.getInstance().startActivityPendingTransition(TrailDetailActivity.this, REQUEST_CODE_BACK, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);

                }
            }
        });
        final ImageView transparentGreen = (ImageView) findViewById(R.id.green_view);
        nestedScrollView.getViewTreeObserver().addOnScrollChangedListener(new ViewTreeObserver.OnScrollChangedListener() {
            @Override
            public void onScrollChanged() {

                if (nestedScrollView.showGreenImg()) {
                    transparentGreen.setVisibility(View.VISIBLE);
                    collapsedTitile.setVisibility(View.VISIBLE);
                } else {
                    transparentGreen.setVisibility(View.GONE);
                    collapsedTitile.setVisibility(View.GONE);
                }
            }
        });
        nestedScrollView.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);


        if (mAdapter.getItemCount() > 0) {
            guidesRecyclerView.setAdapter(mAdapter);
            guidesRecyclerView.setLayoutManager(mLayoutManager);
            assert seeMoreGuide != null;
            seeMoreGuide.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {

                    YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                        @Override
                        public void call(Animator animator) {
                            if (isOfflineModeOn || Util.isNetworkAvailable(TrailDetailActivity.this, true)) {
                                Intent intent = new Intent(TrailDetailActivity.this, FindLocalGuidesActivitiy.class);
                                intent.putExtra("From", "TrailDetail");
                                intent.putExtra("isOfflineOn", isOfflineModeOn);
                                intent.putExtra("TrailId", mTrail.getTrailId());
                                IntentUtils.getInstance().startActivityPendingTransition(TrailDetailActivity.this, REQUEST_CODE_BACK, intent, R.anim.slide_left_enter, R.anim.slide_right_enter);
//
                            }
                        }
                    }).playOn(v, STANDART_DURETION);
                    return false;
                }
            });
        } else {
            LocalGuideTitle.setVisibility(View.GONE);
        }
        if (mTrail.getGuideCount() <= 2) {
            seeMoreGuide.setVisibility(View.GONE);
        }
    }

    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
    }

    private void initImageSlider() {
        final List<String> trailCovers = new ArrayList<>();
        if (mTrail.getTrailCovers().size() > 1) {
            for (int i = 0; i < mTrail.getTrailCovers().size() - 1; i++) {
                trailCovers.add(mTrail.getTrailCovers().get(i));
            }
            endLessAdapter.swap(trailCovers);
            if (trailCovers.size() > 0) {
                mImageSlider.setCurrentItem(trailCovers.size() + 1, false);
            }
        }
        InfinitePageIndicator pageIndicator = (InfinitePageIndicator) findViewById(R.id.pageIndicator);
        if (trailCovers != null && trailCovers.size() > 0) {
            pageIndicator.setVisibility(View.VISIBLE);
            pageIndicator.setFillColor(getResources().getColor(R.color.option_selected_dot_color));
            pageIndicator.setPageColor(getResources().getColor(R.color.option_unselected_dot_color));
            pageIndicator.setViewPager(mImageSlider);
            pageIndicator.setRadius(Util.dpToPx(this, 4));
        } else {
            assert pageIndicator != null;
            pageIndicator.setVisibility(View.INVISIBLE);
        }
        mImageSlider.addOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

                if (position == 0) {
                    mImageSlider.setCurrentItem(trailCovers.size() + 2, false);
                }

            }

        });
        mImageSlider.setHorizontalFadingEdgeEnabled(false);
    }

    private void initAccomodationSlider(boolean isOfflineModeOn) {
        List<Accomodation> accomodationList = mTrail.getAccomodations();
        List<Fragment> fragments = new ArrayList<>();
        for (int i = 0; i < mTrail.getAccomodations().size(); i++) {
            AccomodationFragment fragment = AccomodationFragment.getInstance(accomodationList.get(i), this, i, String.valueOf(mTrail.getTrailId()));

            fragments.add(fragment);
        }

        PAGES = accomodationList.size();
        LOOPS = 1000;
        FIRST_PAGE = PAGES * LOOPS / 2;
        // PagerAdapter pagerAdapter = new PagerAdapter(getSupportFragmentManager(), fragments);
        ArrayList<Accomodation> accomodations = (ArrayList<Accomodation>) mTrail.getAccomodations();
        CaruselPagerAdapter pagerAdapter = new CaruselPagerAdapter(this, getSupportFragmentManager(), accomodations);
        accomodationSlider.setAdapter(pagerAdapter);
        accomodationSlider.addOnPageChangeListener(pagerAdapter);
        accomodationSlider.setCurrentItem(FIRST_PAGE);
        accomodationSlider.setHorizontalFadingEdgeEnabled(false);
    }

    @Override
    public void onResponseReceive(Trail obj) {
        mTrail = getTrailServicsManager().getmTrail();
        if (mTrail != null) {
            savedTrailIcon.setOnTouchListener(this);
            colapsContent.setVisibility(View.VISIBLE);
            initImageSlider();
            if (!mTrail.getAccomodations().isEmpty() && mTrail.getAccomodations() != null) {
                initAccomodationSlider(false);
            } else {
                RelativeLayout accomodationLayout = (RelativeLayout) findViewById(R.id.accomodation_layout);
                accomodationLayout.setVisibility(View.GONE);
            }
            initView();
            TrailTipsAdapter mAdapter = new TrailTipsAdapter(this, mTrail.getReviews());
            trailTipsRecyclerView.setAdapter(mAdapter);
            collapsedTitile.setText(mTrail.getTrailName());
            setCollapsedToolbarTitle();
            nestedScrollView.setScrollbarFadingEnabled(true);
            LinearLayoutManager mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
            trailTipsRecyclerView.setLayoutManager(mLayoutManager);
            if (mAdapter.getItemCount() > 0) {
                addTrailTip.setText(getResources().getString(R.string.add_trail_tip));
            }
        }

        offlineSwitcher.setEnabled(true);

        hideProgresDialogs();
//        UIUtil.hideProgressDialog(this);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (resultCode) {
            case ResultCodes.RESULT_CODE_ALL_TRAIL:
                setResult(ResultCodes.RESULT_CODE_ALL_TRAIL);
                supportFinishAfterTransition();
                break;
            case ResultCodes.SAVED_TRAIL_CODE:
                setResult(ResultCodes.SAVED_TRAIL_CODE);
                supportFinishAfterTransition();
                break;
            case ResultCodes.RESULT_CODE_HOME_OK:
//                finish();
                break;
            case ResultCodes.RESULT_TRAIL_TIPS_POSTED_OK:
                UIUtil.alertDialogShow(this, getString(R.string.sucses), getString(R.string.trail_tips_posted_message));
                break;
            case ResultCodes.RESULT_CODE_UPDATE_DATA:
                savedTrailIcon.setImageResource(R.mipmap.heartred_trails);
                saveingTrail();
                break;

        }
    }

    private void saveingTrail() {
        getTrailServicsManager().saveTrail(String.valueOf(mTrail.getTrailId()), getUserServiceManager().getUser().getToken(), new NetworkRequestListener<Response>() {
                    @Override
                    public void onResponseReceive(Response obj) {
                        if (obj != null && obj.getResult() != null) {
                            savedTrailIcon.setImageResource(R.mipmap.heartred_trails);
                            mTrail.setIsSaved(true);
                            getTrailServicsManager().addtoSavedTrail(mTrail.getTrailId());

                        }
                    }

                    @Override
                    public void onError(String message) {

                    }
                }
        );
    }

    @Override
    public void onError(String message) {
        UIUtil.hideProgressDialog(this);
    }

    private void initActivityTransitions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Slide transition = new Slide();
            transition.excludeTarget(android.R.id.statusBarBackground, true);
            getWindow().setEnterTransition(transition);
            getWindow().setReturnTransition(transition);
        }
    }

    private void setCollapsedToolbarTitle() {

        double deviceScreenWidth = Util.getDisplayWidth(this);
        collapsedTitile.measure(0, 0);
        savedTrailIcon.measure(0, 0);
        shareIcon.measure(0, 0);
        back.measure(0, 0);
        double titleWidth = collapsedTitile.getMeasuredWidth();
        int newTextSize = (int) collapsedTitile.getTextSize();
        while (titleWidth / deviceScreenWidth > 0.6 && newTextSize >= 23) {
            newTextSize -= 1;
            collapsedTitile.measure(0, 0);
            savedTrailIcon.measure(0, 0);
            collapsedTitile.setTextSize(TypedValue.COMPLEX_UNIT_SP, newTextSize);
            titleWidth = collapsedTitile.getMeasuredWidth();
        }
    }

    @Override
    protected void onDestroy() {
        getTrailServicsManager().cancelRequest();
        super.onDestroy();
        IntentUtils.getInstance().clear();
        try {
            offlineTrails = laodTrailFile(TrailDetailActivity.this, KEY);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (v.getId()) {
            case R.id.find_local_guides:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(TrailDetailActivity.this, true)) {

                            Intent intent = new Intent(TrailDetailActivity.this, FindLocalGuidesActivitiy.class);
                            startActivityForResult(intent, ResultCodes.RESULT_CODE_HOME_OK);
                        }
                    }
                }).playOn(v, STANDART_DURETION);
                break;
            case R.id.add_another_trail_tip:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(TrailDetailActivity.this, true)) {

                            if (getUserServiceManager().getUser().isGuest()) {
                                Intent intentSignUp = new Intent(TrailDetailActivity.this, AuthActivity.class);
                                IntentUtils.getInstance().startActivityForResult(TrailDetailActivity.this, 2, intentSignUp, null, false);

                            } else {
                                Intent intentTrailTip = new Intent(TrailDetailActivity.this, TrailTipsActivity.class);
                                intentTrailTip.putExtra("type", "addTrailReview");
                                IntentUtils.getInstance().startActivityPendingTransition(TrailDetailActivity.this, 2, intentTrailTip, R.anim.slide_left_enter, R.anim.slide_right_enter);
                            }
                        }
                    }

                }).playOn(v, STANDART_DURETION);

                break;
            case R.id.bottom_bar_saved_trails:
                getTrailServicsManager().cancelRequest();
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(TrailDetailActivity.this, true)) {

                            if (getUserServiceManager().getUser() != null && getUserServiceManager().getUser().isGuest()) {
                                Intent i = new Intent(TrailDetailActivity.this, AuthActivity.class);
                                IntentUtils.getInstance().startActivityForResult(TrailDetailActivity.this, 2, i, null, false);

                            } else {
                                setResult(ResultCodes.SAVED_TRAIL_CODE);
                                supportFinishAfterTransition();
                            }
                        }
                    }
                }).playOn(v, LONG_DURETION);
                break;
            case R.id.like_icon:
                if (Util.isNetworkAvailable(TrailDetailActivity.this, true)) {
                    setResult(ResultCodes.RESULT_CODE_UPDATE_DATA);
                    SlidingActivity.resultCode = ResultCodes.RESULT_CODE_UPDATE_DATA;
                    resultCode = ResultCodes.RESULT_CODE_UPDATE_DATA;
                    if (getUserServiceManager().getUser().isGuest()) {
                        Intent intentLogin = new Intent(TrailDetailActivity.this, AuthActivity.class);
                        IntentUtils.getInstance().startActivityForResult(TrailDetailActivity.this, 2, intentLogin, null, false);
                    } else if (mTrail.isSaved()) {

                        getTrailServicsManager().removeFromSavedTrails(String.valueOf(mTrail.getTrailId()), getUserServiceManager().getUser().getToken(), new NetworkRequestListener<Response>() {
                            @Override
                            public void onResponseReceive(Response obj) {
                                if (obj != null && obj.getResult() != null) {
                                    savedTrailIcon.setImageResource(R.mipmap.heart_trails);
                                    mTrail.setIsSaved(false);
                                    getTrailServicsManager().removeSavedTrailById(mTrail.getTrailId());
                                }
                            }

                            @Override
                            public void onError(String message) {

                            }
                        });

                    } else {
                        saveingTrail();
                    }
                }
                break;
            case R.id.share_icon:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        Intent sharingIntent = new Intent(android.content.Intent.ACTION_SEND);
                        sharingIntent.setType("text/plain");
                        String shareBody = "http://www.hikearmenia.com/admin/login";
                        sharingIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Subject Here");
                        sharingIntent.putExtra(android.content.Intent.EXTRA_TEXT, shareBody);
                        startActivity(Intent.createChooser(sharingIntent, "Share via"));
                    }

                }).playOn(v, LONG_DURETION);
                break;
            case R.id.bottom_menu_take_photo:
                Intent intent = new Intent(this, TakePhotoActivity.class);
                startActivity(intent);
                break;
            case R.id.back_icon:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        getTrailServicsManager().cancelRequest();
                        if (resultCode != ResultCodes.RESULT_CODE_UPDATE_DATA) {
                            setResult(ResultCodes.RESULT_CODE_IGNORE);
                        }
//                        saveTrailOnExit();
                        supportFinishAfterTransition();
                    }
                }).playOn(v, LONG_DURETION);
                break;

        }

        return false;
    }

    private void initProgressItems() {
        descProgress = (LinearLayout) findViewById(R.id.desc_progress);
        infoProgress = (LinearLayout) findViewById(R.id.info_progress);
//      don't delete
        ProgressBarUI descProgressBar = new ProgressBarUI(this, descProgress);
        ProgressBarUI infoProgressBar = new ProgressBarUI(this, infoProgress);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.full_screen_map:
                saveBoolean(false);
                if (!Util.isNetworkAvailable(TrailDetailActivity.this, false) && !isOfflineModeOn) {
                    Util.isNetworkAvailable(TrailDetailActivity.this, true);
                } else {
                    Intent map = new Intent(this, MapsActivity.class);
                    map.putExtra("type", MapsActivity.DrawRouteType.DrawRoute.name());
                    map.putExtra("trail_id", trailId);
//                    map.putExtra("trail", (Parcelable) mTrail);
//                map.putExtra("trail_object", (Parcelable) mTrail);
                    IntentUtils.getInstance().startActivityForResult(TrailDetailActivity.this, 2, map, null, false);
                }


                break;
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        getTrailServicsManager().cancelRequest();
        if (resultCode != ResultCodes.RESULT_CODE_UPDATE_DATA) {
            setResult(ResultCodes.RESULT_CODE_IGNORE);
        }

//        saveTrailOnExit();
        supportFinishAfterTransition();
    }

    private CompoundButton.OnCheckedChangeListener initCheckecedChangeListener() {
        CompoundButton.OnCheckedChangeListener listener = new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    isOfflineModeOn = true;
                    if (!isSwitchChecked) {
                        showOfflineModeDialog();
                        saveBoolean(true);
                    }

                } else {
                    isOfflineModeOn = false;
                    isSwitchChecked = false;
                    removeTrail(trailId);
                    saveBoolean(false);
                    offlinemodetextView.setVisibility(View.GONE);
                    try {
                        saveTrailFile(TrailDetailActivity.this, KEY, offlineTrails);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        };
        return listener;
    }

    private void saveTrailFile(Context context, String key, List<Trail> trails) throws IOException {
        FileOutputStream fos = context.openFileOutput(key, Context.MODE_PRIVATE);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(trails);
        oos.close();
        fos.close();
    }

    private void initOfflineTrailList() throws IOException, ClassNotFoundException {
        if (!laodTrailFile(TrailDetailActivity.this, KEY).isEmpty()) {
            offlineTrails = laodTrailFile(TrailDetailActivity.this, KEY);
        } else {
            offlineTrails = new ArrayList<>();
        }

    }

    private boolean containsTrail(List<Trail> trails, String trailId) {
        if (trails != null)
            if (!trails.isEmpty()) {
                for (Trail trail : trails) {
                    if (trail != null)
                        if (trailId.equals("" + trail.getTrailId())) {
                            return true;
                        }
                }
            }
        return false;
    }

    private void removeTrail(String trailId) {
        for (Iterator<Trail> iterator = offlineTrails.iterator(); iterator.hasNext(); ) {
            Trail cur = iterator.next();
            if (cur != null)
                if (trailId.equals(String.valueOf(cur.getTrailId()))) {
                    iterator.remove();
                }
        }
    }

    private void showOfflineModeDialog() {
        DisplayMetrics displaymetrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
        int height = displaymetrics.heightPixels;
        int width = displaymetrics.widthPixels;
        ObjectAnimator xTranslate = ObjectAnimator.ofInt(nestedScrollView, "scrollX", width);
        ObjectAnimator yTranslate = ObjectAnimator.ofInt(nestedScrollView, "scrollY", (int) (height * 0.73));

        AnimatorSet animators = new AnimatorSet();
        animators.setDuration(500);
        animators.playTogether(xTranslate, yTranslate);
        animators.addListener(new android.animation.Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(android.animation.Animator animation) {

            }

            @Override
            public void onAnimationEnd(android.animation.Animator animation) {
                offlinemodetextView.setVisibility(View.VISIBLE);

            }

            @Override
            public void onAnimationCancel(android.animation.Animator animation) {
            }

            @Override
            public void onAnimationRepeat(android.animation.Animator animation) {
            }
        });

        animators.start();

    }

    private void initTrailData() throws IOException, ClassNotFoundException {
        List<Trail> trails = laodTrailFile(this, KEY);
        if (containsTrail(trails, trailId)) {
            for (int i = 0; i < trails.size(); i++) {
                if (trailId.equals(String.valueOf(trails.get(i).getTrailId()))) {
                    mTrail = trails.get(i);
                }
            }
        }
    }

    private void hideProgresDialogs() {
        description.setVisibility(View.VISIBLE);
        information.setVisibility(View.VISIBLE);
        descProgress.setVisibility(View.GONE);
        infoProgress.setVisibility(View.GONE);
    }

    private void loadImages() {
        if (mTrail != null) {
            savedTrailIcon.setOnTouchListener(this);
            colapsContent.setVisibility(View.VISIBLE);
            initImageSlider();
            if (!mTrail.getAccomodations().isEmpty() && mTrail.getAccomodations() != null) {
                initAccomodationSlider(true);
            } else {
                RelativeLayout accomodationLayout = (RelativeLayout) findViewById(R.id.accomodation_layout);
                accomodationLayout.setVisibility(View.GONE);
            }
            initView();
            TrailTipsAdapter mAdapter = new TrailTipsAdapter(this, mTrail.getReviews());
            trailTipsRecyclerView.setAdapter(mAdapter);
            collapsedTitile.setText(mTrail.getTrailName());
            setCollapsedToolbarTitle();
            nestedScrollView.setScrollbarFadingEnabled(true);
            LinearLayoutManager mLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
            trailTipsRecyclerView.setLayoutManager(mLayoutManager);
            if (mAdapter.getItemCount() > 0) {
                addTrailTip.setText(getResources().getString(R.string.add_trail_tip));
            }
        }

        offlineSwitcher.setEnabled(true);

    }

    private void saveBoolean(boolean isSavedTrailes) {
        sharedPreferences = getSharedPreferences(trailId, MODE_PRIVATE);
        SharedPreferences.Editor ed = sharedPreferences.edit();
        ed.putBoolean(trailId, isSavedTrailes);
        ed.commit();
    }

    private boolean getBoolean() {
        sharedPreferences = getSharedPreferences(trailId, MODE_PRIVATE);
        return sharedPreferences.getBoolean(trailId, false);
    }

    @Override
    protected void onStop() {
        super.onStop();
        saveTrailOnExit();

    }

    private void saveTrailOnExit() {
        if (isOfflineModeOn) {
            if (!containsTrail(offlineTrails, trailId)) {
                offlineTrails.add(mTrail);

            } else {
                if (!offlineTrails.isEmpty()) {
                    removeTrail(trailId);
                }
                offlineTrails.add(mTrail);
            }
        }
        try {
            saveTrailFile(TrailDetailActivity.this, KEY, offlineTrails);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}

