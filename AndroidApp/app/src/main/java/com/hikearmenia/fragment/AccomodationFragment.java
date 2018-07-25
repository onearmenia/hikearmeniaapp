package com.hikearmenia.fragment;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.app.ActivityOptionsCompat;
import android.support.v4.app.Fragment;
import android.support.v4.util.Pair;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.activities.AccomodationActivity;
import com.hikearmenia.activities.TrailDetailActivity;
import com.hikearmenia.models.api.Accomodation;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.SlidingLayout;
import com.hikearmenia.util.Util;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;


public class AccomodationFragment extends Fragment {
    private static TrailDetailActivity mBaseAcivity;
    int RESULTST_CODE = 2;
    private ImageView accomodationCover;
    private RelativeLayout accomodationLay;


    public AccomodationFragment() {

    }

    public static AccomodationFragment getInstance(Accomodation accomodation, TrailDetailActivity baseActivity, int position, String trail_Id) {
        AccomodationFragment fragment = new AccomodationFragment();
        Bundle args = new Bundle();
        args.putParcelable("accomodation", accomodation);
        args.putInt("position", position);
        args.putString("trail_Id", trail_Id);
        fragment.setArguments(args);
        mBaseAcivity = baseActivity;
        return fragment;
    }


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_accomodation, container, false);
        final int position = getArguments().getInt("position");
        final String trail_Id = getArguments().getString("trail_Id");
        final Accomodation mAccomodation = getArguments().getParcelable("accomodation");


        accomodationCover = (ImageView) view.findViewById(R.id.accomodation);
        TextView accomodationPrice = (TextView) view.findViewById(R.id.accomodation_price);
        TextView accomodationName = (TextView) view.findViewById(R.id.accomodation_name);
        RelativeLayout accomodationlayout = (RelativeLayout) view.findViewById(R.id.accomodation_layout);
        accomodationLay = (RelativeLayout) view.findViewById(R.id.accomodation_lay);


        if (mAccomodation != null) {
            setAccomPagerHeight();

            DisplayImageOptions mOptions = new DisplayImageOptions.Builder()
                    .cacheInMemory(true)
                    .cacheOnDisk(true)
                    .showImageForEmptyUri(R.mipmap.placeholder)
                    .showImageOnLoading(R.mipmap.placeholder)
                    .showImageOnFail(R.mipmap.placeholder)
                    .imageScaleType(ImageScaleType.NONE)
                    .bitmapConfig(Bitmap.Config.RGB_565)
                    .build();

            com.nostra13.universalimageloader.core.ImageLoader.getInstance().displayImage(mAccomodation.getAccomodationCover(),
                    accomodationCover, mOptions);

            accomodationPrice.setText(mAccomodation.getAccomodationPrice());
            accomodationName.setText(mAccomodation.getAccomodationName());
            view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (!Util.isNetworkAvailable(mBaseAcivity, false) && !mBaseAcivity.isOfflineModeOn) {
                        Util.isNetworkAvailable(mBaseAcivity, true);

                    } else {
                        Pair<View, String> imagePair = Pair.create(v, "tImage");
                        ActivityOptionsCompat options = ActivityOptionsCompat.makeSceneTransitionAnimation(mBaseAcivity, imagePair);
                        Intent intentAccom = new Intent(mBaseAcivity, AccomodationActivity.class);
                        intentAccom.putExtra("position", position);
                        intentAccom.putExtra("trail_Id", trail_Id);
                        mBaseAcivity.startActivity(intentAccom);
                        IntentUtils.getInstance().startActivity(mBaseAcivity, intentAccom);

                    }
                }

            });

            view.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    if (event.getAction() == MotionEvent.ACTION_DOWN || event.getAction() == MotionEvent.ACTION_BUTTON_PRESS) {
                        SlidingLayout.isSlid = false;
                    } else if (event.getAction() == MotionEvent.ACTION_UP || event.getAction() == MotionEvent.ACTION_CANCEL) {
                        SlidingLayout.isSlid = true;
                    }
                    return false;
                }
            });
        }
        return view;
    }


    private void setAccomPagerHeight() {
        accomodationCover.getLayoutParams().height = (int) (Util.getDisplayHeight(mBaseAcivity) * 0.36);
        accomodationLay.getLayoutParams().height = (int) (Util.getDisplayHeight(mBaseAcivity) * 0.36);
    }
}
