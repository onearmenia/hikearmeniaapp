package com.hikearmenia.ui.widgets;

import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.support.v4.view.MotionEventCompat;
import android.support.v4.view.ViewConfigurationCompat;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

import com.hikearmenia.R;
import com.hikearmenia.adapters.EndLessAdapter;
import com.hikearmenia.ui.listeners.PageIndicator;

import static android.graphics.Paint.ANTI_ALIAS_FLAG;
import static android.widget.LinearLayout.HORIZONTAL;
import static android.widget.LinearLayout.VERTICAL;

/**
 * Created by jr on 6/24/16.
 */
public class InfinitePageIndicator extends CirclePageIndicator implements PageIndicator {
    private static final int INVALID_POINTER = -1;
    private static final float MIN_SCALE = 0.75f;
    private final Paint mPaintPageFill = new Paint(ANTI_ALIAS_FLAG);
    private final Paint mPaintStroke = new Paint(ANTI_ALIAS_FLAG);
    private final Paint mPaintFill = new Paint(ANTI_ALIAS_FLAG);
    private float mRadius;
    private ViewPager mViewPager;
    private ViewPager.OnPageChangeListener mListener;
    private int mCurrentPage;
    private int mSnapPage;
    private float mPageOffset;
    private int mScrollState;
    private int mOrientation;
    private boolean mCentered;
    private boolean mSnap;
    private int mTouchSlop;
    private float mLastMotionX = -1;
    private int mActivePointerId = INVALID_POINTER;
    private boolean mIsDragging;

    public InfinitePageIndicator(Context context) {
        this(context, null);
    }

    public InfinitePageIndicator(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.RLCirclePageIndicatorStyle);
    }

    public InfinitePageIndicator(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        if (isInEditMode()) return;

        //Load defaults from resources
        final Resources res = getResources();
        final int defaultPageColor = res.getColor(R.color.default_circle_indicator_page_color);
        final int defaultFillColor = res.getColor(R.color.default_circle_indicator_fill_color);
        final int defaultOrientation = res.getInteger(R.integer.default_circle_indicator_orientation);
//        final int defaultStrokeColor = res.getColor(R.color.default_circle_indicator_stroke_color);
//        final float defaultStrokeWidth = res.getDimension(R.dimen.default_circle_indicator_stroke_width);
        final float defaultRadius = res.getDimension(R.dimen.default_circle_indicator_radius);
        final boolean defaultCentered = res.getBoolean(R.bool.default_circle_indicator_centered);
        final boolean defaultSnap = res.getBoolean(R.bool.default_circle_indicator_snap);

        //Retrieve styles attributes
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.CirclePageIndicator, defStyle, 0);

        mCentered = a.getBoolean(R.styleable.CirclePageIndicator_centered, defaultCentered);
        mOrientation = a.getInt(R.styleable.CirclePageIndicator_android_orientation, defaultOrientation);
        mPaintPageFill.setStyle(Paint.Style.FILL);
        mPaintPageFill.setColor(a.getColor(R.styleable.CirclePageIndicator_pageColor, defaultPageColor));
        mPaintStroke.setStyle(Paint.Style.STROKE);
//        mPaintStroke.setColor(a.getColor(R.styleable.CirclePageIndicator_strokeColor, defaultStrokeColor));
//        mPaintStroke.setStrokeWidth(a.getDimension(R.styleable.CirclePageIndicator_strokeWidth, defaultStrokeWidth));
        mPaintFill.setStyle(Paint.Style.FILL);
        mPaintFill.setColor(a.getColor(R.styleable.CirclePageIndicator_fillColor, defaultFillColor));
        mRadius = a.getDimension(R.styleable.CirclePageIndicator_radius, defaultRadius);
        mSnap = a.getBoolean(R.styleable.CirclePageIndicator_snap, defaultSnap);

        Drawable background = a.getDrawable(R.styleable.CirclePageIndicator_android_background);
        if (background != null) {
            setBackgroundDrawable(background);
        }

        a.recycle();

        final ViewConfiguration configuration = ViewConfiguration.get(context);
        mTouchSlop = ViewConfigurationCompat.getScaledPagingTouchSlop(configuration);
    }

    public boolean isCentered() {
        return mCentered;
    }

    public void setCentered(boolean centered) {
        mCentered = centered;
        invalidate();
    }

    public int getPageColor() {
        return mPaintPageFill.getColor();
    }

    public void setPageColor(int pageColor) {
        mPaintPageFill.setColor(pageColor);
        invalidate();
    }

    public int getFillColor() {
        return mPaintFill.getColor();
    }

    public void setFillColor(int fillColor) {
        mPaintFill.setColor(fillColor);
        invalidate();
    }

    public int getOrientation() {
        return mOrientation;
    }

    public void setOrientation(int orientation) {
        switch (orientation) {
            case HORIZONTAL:
            case VERTICAL:
                mOrientation = orientation;
                requestLayout();
                break;

            default:
                throw new IllegalArgumentException("Orientation must be either HORIZONTAL or VERTICAL.");
        }
    }

    public int getStrokeColor() {
        return mPaintStroke.getColor();
    }

    public void setStrokeColor(int strokeColor) {
        mPaintStroke.setColor(strokeColor);
        invalidate();
    }

    public float getStrokeWidth() {
        return mPaintStroke.getStrokeWidth();
    }

    public void setStrokeWidth(float strokeWidth) {
        mPaintStroke.setStrokeWidth(strokeWidth);
        invalidate();
    }

    public float getRadius() {
        return mRadius;
    }

    public void setRadius(float radius) {
        mRadius = radius;
        invalidate();
    }

    public boolean isSnap() {
        return mSnap;
    }

    public void setSnap(boolean snap) {
        mSnap = snap;
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (mViewPager == null) {
            return;
        }
        final int count = ((EndLessAdapter) mViewPager.getAdapter()).getItemsCount();
        if (count == 0) {
            return;
        }

        if (mCurrentPage >= count) {
            return;
        }

        int longSize;
        int longPaddingBefore;
        int longPaddingAfter;
        int shortPaddingBefore;
        if (mOrientation == HORIZONTAL) {
            longSize = getWidth();
            longPaddingBefore = getPaddingLeft();
            longPaddingAfter = getPaddingRight();
            shortPaddingBefore = getPaddingTop();
        } else {
            longSize = getHeight();
            longPaddingBefore = getPaddingTop();
            longPaddingAfter = getPaddingBottom();
            shortPaddingBefore = getPaddingLeft();
        }

        final float threeRadius = mRadius * 3;
        final float shortOffset = shortPaddingBefore + mRadius;
        float longOffset = longPaddingBefore + mRadius;
        if (mCentered) {
            longOffset += ((longSize - longPaddingBefore - longPaddingAfter) / 2.0f) - ((count * threeRadius) / 2.0f);
        }

        float dX;
        float dY;

        float pageFillRadius = mRadius;
        if (mPaintStroke.getStrokeWidth() > 0) {
            pageFillRadius -= mPaintStroke.getStrokeWidth() / 2.0f;
        }

        //Draw stroked circles
        for (int iLoop = 0; iLoop < count; iLoop++) {
            float drawLong = longOffset + (iLoop * threeRadius);
            if (mOrientation == HORIZONTAL) {
                dX = drawLong;
                dY = shortOffset;
            } else {
                dX = shortOffset;
                dY = drawLong;
            }
            // Only paint fill if not completely transparent
            if (mPaintPageFill.getAlpha() > 0) {
                canvas.drawCircle(dX, dY, pageFillRadius, mPaintPageFill);
            }

            // Only paint stroke if a stroke width was non-zero
            if (!(Math.abs(pageFillRadius - mRadius) < .0000001)) {
                canvas.drawCircle(dX, dY, mRadius, mPaintStroke);
            }
        }

        //Draw the filled circle according to the current scroll
        float cx = (mSnap ? mSnapPage : mCurrentPage) * threeRadius;
        if (!mSnap && mCurrentPage != ((EndLessAdapter) mViewPager.getAdapter()).getItemsCount() - 1) {
            cx += mPageOffset * threeRadius;
        }
        if (mOrientation == HORIZONTAL) {
            dX = longOffset + cx;
            dY = shortOffset;
        } else {
            dX = shortOffset;
            dY = longOffset + cx;
        }
        canvas.drawCircle(dX, dY, mRadius, mPaintFill);


    }

    public boolean onTouchEvent(android.view.MotionEvent ev) {
        if (super.onTouchEvent(ev)) {
            return true;
        }
        if ((mViewPager == null) || (((EndLessAdapter) mViewPager.getAdapter()).getItemsCount() == 0)) {
            return false;
        }

        final int action = ev.getAction() & MotionEventCompat.ACTION_MASK;
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                mActivePointerId = MotionEventCompat.getPointerId(ev, 0);
                mLastMotionX = ev.getX();
                break;

            case MotionEvent.ACTION_MOVE: {
                final int activePointerIndex = MotionEventCompat.findPointerIndex(ev, mActivePointerId);
                final float x = MotionEventCompat.getX(ev, activePointerIndex);
                final float deltaX = x - mLastMotionX;

                if (!mIsDragging) {
                    if (Math.abs(deltaX) > mTouchSlop) {
                        mIsDragging = true;
                    }
                }

                if (mIsDragging) {
                    mLastMotionX = x;
                    if (mViewPager.isFakeDragging() || mViewPager.beginFakeDrag()) {
                        mViewPager.fakeDragBy(deltaX);
                    }
                }

                break;
            }

            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_UP:
                if (!mIsDragging) {
                    final int count = ((EndLessAdapter) mViewPager.getAdapter()).getItemsCount();
                    final int width = getWidth();
                    final float halfWidth = width / 2f;
                    final float sixthWidth = width / 6f;

                    if ((mCurrentPage > 0) && (ev.getX() < halfWidth - sixthWidth)) {
                        if (action != MotionEvent.ACTION_CANCEL) {
                            // mViewPager.setCurrentItem(mCurrentPage - 1);
                        }
                        return true;
                    } else if ((mCurrentPage < count - 1) && (ev.getX() > halfWidth + sixthWidth)) {
                        if (action != MotionEvent.ACTION_CANCEL) {
                            //  mViewPager.setCurrentItem(mCurrentPage + 1);
                        }
                        return true;
                    }
                }

                mIsDragging = false;
                mActivePointerId = INVALID_POINTER;
                if (mViewPager.isFakeDragging()) mViewPager.endFakeDrag();
                break;

            case MotionEventCompat.ACTION_POINTER_DOWN: {
                final int index = MotionEventCompat.getActionIndex(ev);
                mLastMotionX = MotionEventCompat.getX(ev, index);
                mActivePointerId = MotionEventCompat.getPointerId(ev, index);
                break;
            }

            case MotionEventCompat.ACTION_POINTER_UP:
                final int pointerIndex = MotionEventCompat.getActionIndex(ev);
                final int pointerId = MotionEventCompat.getPointerId(ev, pointerIndex);
                if (pointerId == mActivePointerId) {
                    final int newPointerIndex = pointerIndex == 0 ? 1 : 0;
                    mActivePointerId = MotionEventCompat.getPointerId(ev, newPointerIndex);
                }
                mLastMotionX = MotionEventCompat.getX(ev, MotionEventCompat.findPointerIndex(ev, mActivePointerId));
                break;
            default:
                break;
        }

        return true;
    }

    @Override
    public void setViewPager(ViewPager view) {
        if (mViewPager == view) {
            return;
        }
        if (mViewPager != null) {
            mViewPager.setOnPageChangeListener(null);
        }
        if (view.getAdapter() == null) {
            throw new IllegalStateException("ViewPager does not have adapter instance.");
        }
        mViewPager = view;
        mViewPager.setOnPageChangeListener(this);
        invalidate();
    }

    @Override
    public void setViewPager(ViewPager view, int initialPosition) {
        setViewPager(view);
        //setCurrentItem(initialPosition);
    }

    @Override
    public void setCurrentItem(int item) {
        mCurrentPage = item;
    }

    @Override
    public void notifyDataSetChanged() {
        invalidate();
    }

    @Override
    public void onPageScrollStateChanged(int state) {
        mScrollState = state;

        if (mListener != null) {
            mListener.onPageScrollStateChanged(state);
        }
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        mCurrentPage = ((EndLessAdapter) mViewPager.getAdapter()).getImagePosition(position);
        mPageOffset = positionOffset;
        invalidate();

        if (mListener != null) {
            mListener.onPageScrolled(position, positionOffset, positionOffsetPixels);
        }
    }

    @Override
    public void onPageSelected(int position) {
        if (mSnap || mScrollState == ViewPager.SCROLL_STATE_IDLE) {
            mCurrentPage = ((EndLessAdapter) mViewPager.getAdapter()).getImagePosition(position);
            mSnapPage = ((EndLessAdapter) mViewPager.getAdapter()).getImagePosition(position);
            invalidate();
        }

        if (mListener != null) {
            mListener.onPageSelected(((EndLessAdapter) mViewPager.getAdapter()).getImagePosition(position));
        }
    }

    @Override
    public void setOnPageChangeListener(ViewPager.OnPageChangeListener listener) {
        mListener = listener;
    }

    /*
* (non-Javadoc)
*
* @see android.view.View#onMeasure(int, int)
*/
    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        if (mOrientation == HORIZONTAL) {
            setMeasuredDimension(measureLong(widthMeasureSpec), measureShort(heightMeasureSpec));
        } else {
            setMeasuredDimension(measureShort(widthMeasureSpec), measureLong(heightMeasureSpec));
        }
    }

    /**
     * Determines the width of this view
     *
     * @param measureSpec A measureSpec packed into an int
     * @return The width of the view, honoring constraints from measureSpec
     */
    private int measureLong(int measureSpec) {
        int result;
        int specMode = MeasureSpec.getMode(measureSpec);
        int specSize = MeasureSpec.getSize(measureSpec);

        if ((specMode == MeasureSpec.EXACTLY) || (mViewPager == null)) {
            //We were told how big to be
            result = specSize;
        } else {
            //Calculate the width according the views count
            final int count = ((EndLessAdapter) mViewPager.getAdapter()).getItemsCount();
            result = (int) (getPaddingLeft() + getPaddingRight()
                    + (count * 2 * mRadius) + (count - 1) * mRadius + 1);
            //Respect AT_MOST value if that was what is called for by measureSpec
            if (specMode == MeasureSpec.AT_MOST) {
                result = Math.min(result, specSize);
            }
        }
        return result;
    }

    /**
     * Determines the height of this view
     *
     * @param measureSpec A measureSpec packed into an int
     * @return The height of the view, honoring constraints from measureSpec
     */
    private int measureShort(int measureSpec) {
        int result;
        int specMode = MeasureSpec.getMode(measureSpec);
        int specSize = MeasureSpec.getSize(measureSpec);

        if (specMode == MeasureSpec.EXACTLY) {
            //We were told how big to be
            result = specSize;
        } else {
            //Measure the height
            result = (int) (2 * mRadius + getPaddingTop() + getPaddingBottom() + 1);
            //Respect AT_MOST value if that was what is called for by measureSpec
            if (specMode == MeasureSpec.AT_MOST) {
                result = Math.min(result, specSize);
            }
        }
        return result;
    }

    @Override
    public void onRestoreInstanceState(Parcelable state) {
        SavedState savedState = (SavedState) state;
        super.onRestoreInstanceState(savedState.getSuperState());
        mCurrentPage = savedState.currentPage;
        mSnapPage = savedState.currentPage;
        requestLayout();
    }

    @Override
    public Parcelable onSaveInstanceState() {
        Parcelable superState = super.onSaveInstanceState();
        SavedState savedState = new SavedState(superState);
        savedState.currentPage = mCurrentPage;
        return savedState;
    }

    public void transformPage(View view, float position) {
        int pageWidth = view.getWidth();

        if (position < -1) { // [-Infinity,-1)
            // This page is way off-screen to the left.
            view.setAlpha(0);

        } else if (position <= 0) { // [-1,0]
            // Use the default slide transition when moving to the left page
            view.setAlpha(1);
            view.setTranslationX(0);
            view.setScaleX(1);
            view.setScaleY(1);

        } else if (position <= 1) { // (0,1]
            // Fade the page out.
            view.setAlpha(1 - position);

            // Counteract the default slide transition
            view.setTranslationX(pageWidth * -position);

            // Scale the page down (between MIN_SCALE and 1)
            float scaleFactor = MIN_SCALE
                    + (1 - MIN_SCALE) * (1 - Math.abs(position));
            view.setScaleX(scaleFactor);
            view.setScaleY(scaleFactor);

        } else { // (1,+Infinity]
            // This page is way off-screen to the right.
            view.setAlpha(0);
        }
    }

    static class SavedState extends BaseSavedState {
        public static final Parcelable.Creator<SavedState> CREATOR = new Parcelable.Creator<SavedState>() {
            @Override
            public SavedState createFromParcel(Parcel in) {
                return new SavedState(in);
            }

            @Override
            public SavedState[] newArray(int size) {
                return new SavedState[size];
            }
        };
        int currentPage;

        public SavedState(Parcelable superState) {
            super(superState);
        }

        private SavedState(Parcel in) {
            super(in);
            currentPage = in.readInt();
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            super.writeToParcel(dest, flags);
            dest.writeInt(currentPage);
        }
    }
}