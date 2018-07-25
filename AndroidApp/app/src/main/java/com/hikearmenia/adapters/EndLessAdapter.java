package com.hikearmenia.adapters;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Parcelable;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;

import com.hikearmenia.R;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * Created by jr on 6/24/16.
 */
public class EndLessAdapter extends android.support.v4.view.PagerAdapter {
    FragmentActivity activity;
    List<String> urlList;
    LayoutInflater inflater;

    public EndLessAdapter(FragmentActivity act, List<String> imgArra) {

        urlList = imgArra;
        activity = act;
        inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

    }

    public int getCount() {
        if (urlList.size() > 1) {
            return Integer.MAX_VALUE;
        } else return 1;

    }

    public int getItemsCount() {
        return urlList.size();
    }

    public Object instantiateItem(View collection, int position) {

        View view = inflater.inflate(R.layout.trail_detail_image, null);
        ImageView mwebView = (ImageView) view.findViewById(R.id.trail_detail_img);
        ((ViewPager) collection).addView(view, 0);
//        UIUtil.scaleView(trailDetailLayout, 0f, 2f);
        mwebView.setScaleType(ImageView.ScaleType.FIT_XY);
        DisplayImageOptions mOptions = new DisplayImageOptions.Builder()
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .showImageForEmptyUri(R.mipmap.placeholder)
                .showImageOnLoading(R.mipmap.placeholder)
                .showImageOnFail(R.mipmap.placeholder)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();

        if (urlList.get(getImagePosition(position)) != null && !urlList.get(getImagePosition(position)).isEmpty()) {
            ImageLoader.getInstance().displayImage(urlList.get(getImagePosition(position)), mwebView, mOptions);
        }
        return view;
    }

    public int getImagePosition(int position) {

        if (position >= urlList.size() - 1) {
            return position % urlList.size();
        }
        return position;
    }

    @Override
    public void destroyItem(View arg0, int arg1, Object arg2) {
        ((ViewPager) arg0).removeView((View) arg2);
    }

    @Override
    public boolean isViewFromObject(View arg0, Object arg1) {
        return arg0 == ((View) arg1);
    }

    @Override
    public Parcelable saveState() {
        return null;
    }

    @Override
    public int getItemPosition(Object object) {
        return POSITION_NONE;
    }

    public void swap(List<String> updatedData) {
        urlList.addAll(updatedData);
        notifyDataSetChanged();
    }

}
