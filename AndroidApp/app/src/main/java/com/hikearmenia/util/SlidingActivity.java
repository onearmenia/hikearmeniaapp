package com.hikearmenia.util;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.constants.ResultCodes;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;

/**
 * Created by chenjishi on 14-3-17.
 */
public class SlidingActivity extends BaseActivity implements SlidingLayout.SlidingListener {
    public static int resultCode = ResultCodes.RESULT_CODE_IGNORE;
    private View mPreview;
    private float mInitOffset;
    private String mBitmapId;

    @Override
    public void setContentView(int layoutResID) {
        super.setContentView(R.layout.slide_layout);

        DisplayMetrics metrics = getResources().getDisplayMetrics();
        LayoutInflater inflater = LayoutInflater.from(this);
        mInitOffset = -(1.f / 3) * metrics.widthPixels;

        mPreview = findViewById(R.id.iv_preview);
        FrameLayout contentView = (FrameLayout) findViewById(R.id.content_view);

        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(MATCH_PARENT,
                MATCH_PARENT, Gravity.BOTTOM);
        lp.setMargins(0, 0, 0, 0);
        contentView.addView(inflater.inflate(layoutResID, null), lp);

        final SlidingLayout slideLayout = (SlidingLayout) findViewById(R.id.slide_layout);
        slideLayout.setShadowResource(R.drawable.sliding_back_shadow);
        slideLayout.setSlidingListener(this);
        slideLayout.setEdgeSize(400);//(int) (Util.getDisplayWidth(this) * 0.125)

        if (getIntent().getExtras() != null) {
            mBitmapId = getIntent().getExtras().getString("bitmap_id");

        }
        Bitmap bitmap = IntentUtils.getInstance().getBitmap(mBitmapId);
        if (bitmap == null) {
            finish();
        }
        if (null != bitmap) {
            if (Build.VERSION.SDK_INT >= 16) {
                mPreview.setBackground(new BitmapDrawable(bitmap));
            } else {
                mPreview.setBackgroundDrawable(new BitmapDrawable(bitmap));
            }

            IntentUtils.getInstance().setIsDisplayed(mBitmapId, true);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        IntentUtils.getInstance().setIsDisplayed(mBitmapId, false);
    }

    @Override
    public void onPanelSlide(View panel, float slideOffset) {
        if (slideOffset <= 0) {
        } else if (slideOffset < 1) {
            mPreview.setTranslationX(mInitOffset * (1 - slideOffset));
        } else {
            mPreview.setTranslationX(0);
            setResult(resultCode);
            finish();
            overridePendingTransition(0, 0);
        }
    }

}
