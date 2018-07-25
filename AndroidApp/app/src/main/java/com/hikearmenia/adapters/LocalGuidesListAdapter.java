package com.hikearmenia.adapters;

import android.content.Intent;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.net.Uri;
import android.support.v7.widget.CardView;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.imageutils.ImageLoader;
import com.hikearmenia.models.api.Guide;
import com.hikearmenia.ui.RatingBar;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

import java.util.List;

/**
 * Created by jr on 5/11/16.
 */
public class LocalGuidesListAdapter extends RecyclerView.Adapter<LocalGuidesListAdapter.ViewHolder> {
    OnItemClickListener mItemClickListener;
    List<Guide> mGuidesList;
    private BaseActivity mBaseActivity;

    public LocalGuidesListAdapter(BaseActivity mBaseActivity, List<Guide> guidesList) {
        this.mBaseActivity = mBaseActivity;
        mGuidesList = guidesList;
    }

    @Override
    public LocalGuidesListAdapter.ViewHolder onCreateViewHolder(ViewGroup parent,
                                                                int viewType) {

        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.local_guides_item, parent, false);
        ViewHolder vh = new ViewHolder(v);
        return vh;
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {

        int width = Util.getDisplayWidth(mBaseActivity);
        final Guide guide = mGuidesList.get(position);
        if (guide.getReviewCount() == 1) {
            holder.reViews.setText(String.format(mBaseActivity.getString(R.string.one_review_guides), guide.getReviewCount()));
        } else {
            holder.reViews.setText(String.format(mBaseActivity.getString(R.string.reviews_guides), guide.getReviewCount()));
        }
        holder.guidName.setText(guide.getGuideFirstname() + " " + guide.getGuideLastName());
        ImageLoader loader = new ImageLoader(mBaseActivity, R.mipmap.profile_avatar);
        loader.DisplayImage(guide.getGuideImage(), holder.guideImg);
        if (guide.getGuidePhone().isEmpty() || guide.getGuidePhone() == null) {
            holder.callImg.setColorFilter(new
                    PorterDuffColorFilter(mBaseActivity.getResources().getColor(R.color.black_40_percent), PorterDuff.Mode.MULTIPLY));
        }
        if (TextUtils.isEmpty(guide.getGuideEmail())) {
            holder.sendEmail.setColorFilter(new
                    PorterDuffColorFilter(mBaseActivity.getResources().getColor(R.color.black_40_percent), PorterDuff.Mode.MULTIPLY));
        }

        holder.layoutManager = new LinearLayoutManager(mBaseActivity, LinearLayoutManager.HORIZONTAL, false);
        GuideLanguagesAdapter adapter = new GuideLanguagesAdapter(mBaseActivity, guide);
        holder.flagRecycler.setAdapter(adapter);
        holder.flagRecycler.setLayoutManager(holder.layoutManager);
        if (adapter.getItemCount() > 0) {
            holder.flagRecycler.setVisibility(View.VISIBLE);
        }
        RatingBar ratingBar = new RatingBar(mBaseActivity, holder.ratingBarLayout);
        ratingBar.getParams(((int) (width * 0.04)), ((int) (width * 0.04)), guide.getAverageRating(), false);
        if (!TextUtils.isEmpty(guide.getGuideEmail())) {
            holder.sendEmailLayout.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                        @Override
                        public void call(Animator animator) {

                            Intent emailIntent = new Intent(Intent.ACTION_SENDTO, Uri.fromParts(
                                    "mailto", guide.getGuideEmail(), null));
                            emailIntent.putExtra(Intent.EXTRA_SUBJECT, "Hike Armenia");
                            try {
                                mBaseActivity.startActivity(Intent.createChooser(emailIntent, "Send email..."));
                            } catch (Exception e) {
                                UIUtil.alertDialogShow(mBaseActivity, mBaseActivity.getString(R.string.could_not_send_email), mBaseActivity.getString(R.string.could_not_send_email_message));
                            }

                        }
                    }).playOn(v, mBaseActivity.STANDART_DURETION);
                    return false;
                }
            });
        }

        if (!guide.getGuidePhone().isEmpty() && guide.getGuidePhone() != null) {
            holder.callImgLayout.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                        @Override
                        public void call(Animator animator) {
                            Intent intent = new Intent(Intent.ACTION_DIAL);
                            intent.setData(Uri.parse("tel:" + guide.getGuidePhone()));
                            mBaseActivity.startActivity(intent);
                        }

                    }).playOn(v, mBaseActivity.STANDART_DURETION);
                    return false;
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        return mGuidesList.size();
    }

    public void setOnItemClickListener(final OnItemClickListener mItemClickListener) {
        this.mItemClickListener = mItemClickListener;
    }

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        private CardView contentItem;
        private de.hdodenhof.circleimageview.CircleImageView guideImg;
        private TextView reViews;
        private TextView guidName;
        private ImageView sendEmail;
        private ImageView callImg;
        private RelativeLayout callImgLayout;
        private RelativeLayout ratingBarLayout;
        private RelativeLayout contentGuideInfo;
        private RelativeLayout sendEmailLayout;
        private RecyclerView flagRecycler;
        private LinearLayoutManager layoutManager;

        public ViewHolder(View v) {

            super(v);
            contentItem = (CardView) v.findViewById(R.id.content_item);
            contentItem.setPreventCornerOverlap(false);
            guidName = (TextView) v.findViewById(R.id.guid_name);
            reViews = (TextView) v.findViewById(R.id.reViews);
            sendEmail = (ImageView) v.findViewById(R.id.send_email);
            callImg = (ImageView) v.findViewById(R.id.call_img);
            sendEmailLayout = (RelativeLayout) v.findViewById(R.id.send_email_layout);
            contentGuideInfo = (RelativeLayout) v.findViewById(R.id.content_guide_info);
            contentGuideInfo.setOnClickListener(this);
            contentGuideInfo.getLayoutParams().width = (int) (Util.getDisplayWidth(mBaseActivity) * 0.7);
            callImgLayout = (RelativeLayout) v.findViewById(R.id.call_img_layout);
            guideImg = (de.hdodenhof.circleimageview.CircleImageView) v.findViewById(R.id.guide_image);
            ratingBarLayout = (RelativeLayout) v.findViewById(R.id.rating_bar);
            flagRecycler = (RecyclerView) v.findViewById(R.id.flag_recycler);
        }

        @Override
        public void onClick(View v) {

            if (mItemClickListener != null) {
                mItemClickListener.onItemClick(contentGuideInfo, getPosition());
            }
        }
    }


}