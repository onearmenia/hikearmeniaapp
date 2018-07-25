package com.hikearmenia.fragment;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;

/**
 * Created by Ani Karapetyan on 5/16/16.
 */
public class ImageFragment extends Fragment {

    private static BaseActivity mBaseActivity;

    public ImageFragment() {

    }

    public static ImageFragment getInstance(Context context, String imageUri, int placeHolder) {
        ImageFragment instance = new ImageFragment();
        Bundle args = new Bundle();
        args.putString("image", imageUri);
        args.putInt("image_holder", placeHolder);
        instance.setArguments(args);
        mBaseActivity = (BaseActivity) context;
        initImageLoader(context);
        return instance;
    }

    public static void initImageLoader(Context context) {
        // This configuration tuning is custom. You can tune every option, you may tune some of them,
        // or you can create default configuration by
        //  ImageLoaderConfiguration.createDefault(this);
        // method.
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

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.trail_detail_image, null);
        ImageView image = (ImageView) view.findViewById(R.id.trail_detail_img);
        String url = getArguments().getString("image");
        int id = getArguments().getInt("image_holder");
        DisplayImageOptions mOptions = new DisplayImageOptions.Builder()
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .showImageForEmptyUri(id)
                .showImageOnLoading(id)
                .showImageOnFail(id)
                .imageScaleType(ImageScaleType.NONE)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();

        if (url != null && !url.isEmpty()) {
            com.nostra13.universalimageloader.core.ImageLoader.getInstance().displayImage(url, image, mOptions);
        }

        return view;
    }
}
