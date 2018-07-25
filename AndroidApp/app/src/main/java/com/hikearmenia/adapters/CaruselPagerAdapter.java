package com.hikearmenia.adapters;

import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.activities.TrailDetailActivity;
import com.hikearmenia.fragment.AccomodationFragment;
import com.hikearmenia.models.api.Accomodation;

import java.util.ArrayList;

/**
 * Created by jr on 7/12/16.
 */
public class CaruselPagerAdapter extends FragmentPagerAdapter implements
        ViewPager.OnPageChangeListener {


    public final static float BIG_SCALE = 1.0f;
    public final static float SMALL_SCALE = 0.7f;
    public final static float DIFF_SCALE = BIG_SCALE - SMALL_SCALE;
    int currentPos = -1;
    ArrayList<Accomodation> mAccomodationList;
    private RelativeLayout cur = null;
    private RelativeLayout next = null;
    private TrailDetailActivity context;
    private FragmentManager fm;
    private float scale;

    public CaruselPagerAdapter(TrailDetailActivity context, FragmentManager fm, ArrayList<Accomodation> accomodationList) {
        super(fm);
        this.fm = fm;
        this.context = context;
        mAccomodationList = accomodationList;
    }

    public int getImagePosition(int position) {

        if (position >= mAccomodationList.size() - 1) {
            return position % mAccomodationList.size();
        }
        return position;
    }

    @Override
    public AccomodationFragment getItem(int position) {
        // make the first pager bigger than others
        if (position == TrailDetailActivity.FIRST_PAGE)
            scale = BIG_SCALE;
        else
            scale = SMALL_SCALE;

        //position = position % TrailDetailActivity.PAGES;
        position = position % mAccomodationList.size();
        return AccomodationFragment.getInstance(mAccomodationList.get(getImagePosition(position)), context, getImagePosition(position), TrailDetailActivity.trailId);
    }

    @Override
    public int getCount() {
        //return TrailDetailActivity.PAGES * TrailDetailActivity.LOOPS;
        if (mAccomodationList.size() == 1) {
            return 1;
        } else {
            return mAccomodationList.size() * TrailDetailActivity.LOOPS;
        }

    }

    @Override
    public void onPageScrolled(int position, float positionOffset,
                               int positionOffsetPixels) {
        if (positionOffset >= 0f && positionOffset <= 1f) {
            cur = getRootView(position);

            if (position < mAccomodationList.size() - 1) {
                next = getRootView(position + 1);
            }
        }
    }

    @Override
    public void onPageSelected(int position) {
    }

    @Override
    public void onPageScrollStateChanged(int state) {
    }

    private RelativeLayout getRootView(int position) {
        return (RelativeLayout)
                fm.findFragmentByTag(this.getFragmentTag(position))
                        .getView().findViewById(R.id.accomodation_layout);
    }

    private String getFragmentTag(int position) {
        return "android:switcher:" + context.accomodationSlider.getId() + ":" + position;
    }

    @Override
    public float getPageWidth(int position) {
        if (mAccomodationList.size() == 1) {
            return 1f;
        }
        return 0.8f;
    }
}