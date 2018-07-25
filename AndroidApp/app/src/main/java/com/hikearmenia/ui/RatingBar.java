package com.hikearmenia.ui;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;

import java.util.Arrays;
import java.util.List;

public class RatingBar implements View.OnClickListener {
    ImageView star0;
    ImageView star1;
    ImageView star2;
    ImageView star3;
    ImageView star4;
    private Context context;
    private int selectedStarCount = 0;
    private List<ImageView> ratingStartsList;
    private List<Boolean> statusStar;
    private View theInflatedView;

    public RatingBar(Context context, View ratingbar) {
        this.context = context;
        theInflatedView = ratingbar;
        getTheInflatedView();
    }


    public View getTheInflatedView() {
        star0 = (ImageView) theInflatedView.findViewById(R.id.star1);
        star1 = (ImageView) theInflatedView.findViewById(R.id.star2);
        star2 = (ImageView) theInflatedView.findViewById(R.id.star3);
        star3 = (ImageView) theInflatedView.findViewById(R.id.star4);
        star4 = (ImageView) theInflatedView.findViewById(R.id.star5);
        statusStar = Arrays.asList(false, false, false, false, false);
        ratingStartsList = Arrays.asList(star0, star1, star2, star3, star4);
        for (int i = 0; i < ratingStartsList.size(); i++) {
            ratingStartsList.get(i).setOnClickListener(this);
        }

        return theInflatedView;
    }


    @Override
    public void onClick(View v) {
        int i;
        switch (v.getId()) {
            case R.id.star1:
                i = 0;
                onRatingSelected(i);
                break;
            case R.id.star2:
                i = 1;
                onRatingSelected(i);
                break;
            case R.id.star3:
                i = 2;
                onRatingSelected(i);
                break;
            case R.id.star4:
                i = 3;
                onRatingSelected(i);
                break;
            case R.id.star5:
                i = 4;
                onRatingSelected(i);
                break;
        }
    }

    public void getParams(int height, int width, int ratingCount, boolean emptyWhite) {
        RelativeLayout.LayoutParams layoutParams;

        layoutParams = (RelativeLayout.LayoutParams) star0.getLayoutParams();
        layoutParams.height = height;
        layoutParams.width = width;
        star0.setLayoutParams(layoutParams);

        layoutParams = (RelativeLayout.LayoutParams) star1.getLayoutParams();
        layoutParams.height = height;
        layoutParams.width = width;
        star1.setLayoutParams(layoutParams);

        layoutParams = (RelativeLayout.LayoutParams) star2.getLayoutParams();
        layoutParams.height = height;
        layoutParams.width = width;
        star2.setLayoutParams(layoutParams);

        layoutParams = (RelativeLayout.LayoutParams) star3.getLayoutParams();
        layoutParams.height = height;
        layoutParams.width = width;
        star3.setLayoutParams(layoutParams);

        layoutParams = (RelativeLayout.LayoutParams) star4.getLayoutParams();
        layoutParams.height = height;
        layoutParams.width = width;
        star4.setLayoutParams(layoutParams);
        for (int j = 0; j < ratingCount; j++) {
            ratingStartsList.get(j).setImageResource(R.drawable.full_star);
            ratingStartsList.get(j).setClickable(false);
        }
        if (emptyWhite) {
            for (int j = ratingCount; j < ratingStartsList.size(); j++) {
                ratingStartsList.get(j).setImageResource(R.drawable.empty_star_white);
                statusStar.set(j, false);
                ratingStartsList.get(j).setClickable(false);
            }
        } else {
            for (int j = ratingCount; j < ratingStartsList.size(); j++) {
                ratingStartsList.get(j).setImageResource(R.drawable.empty_star);
                statusStar.set(j, false);
                ratingStartsList.get(j).setClickable(false);
            }
        }
    }

    public void onRatingSelected(int i) {

        for (int j = 0; j <= i; j++) {
            ratingStartsList.get(j).setImageResource(R.drawable.full_star);
            statusStar.set(j, true);
        }
        for (int j = i + 1; j < ratingStartsList.size(); j++) {
            ratingStartsList.get(j).setImageResource(R.drawable.empty_star);
            statusStar.set(j, false);
        }

    }

    public int getRating() {

        int count = 0;
        for (int x = 0; x < statusStar.size(); x++) {
            if (statusStar.get(x)) {
                count++;
            }
        }
        return count;
    }

}
