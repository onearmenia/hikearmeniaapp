package com.hikearmenia.adapters;

import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.activities.TrailDetailActivity;
import com.hikearmenia.models.api.TrailReview;
import com.hikearmenia.ui.widgets.TextView;

import java.util.List;

/**
 * Created by jr on 5/24/16.
 */
public class TrailTipsAdapter extends RecyclerView.Adapter<TrailTipsAdapter.ViewHolder> {

    OnItemClickListener mItemClickListener;
    List<TrailReview> TrailReviewList;
    String mType;
    private BaseActivity mBaseActivity;

    public TrailTipsAdapter(BaseActivity mBaseActivity, List<TrailReview> TrailReviewList) {
        this.mBaseActivity = mBaseActivity;
        this.TrailReviewList = TrailReviewList;
    }

    @Override
    public TrailTipsAdapter.ViewHolder onCreateViewHolder(ViewGroup parent,
                                                          int viewType) {

        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.trail_tips_adapter_item, parent, false);

        ViewHolder vh = new ViewHolder(v);
        return vh;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {

        if (getItemCount() > 0) {
            TrailReview trailReview = TrailReviewList.get(position);
            holder.guideReviewText.setText(trailReview.getTrReview());
            if (mBaseActivity.getIntent().hasExtra("type") && mType.equals(TrailDetailActivity.class.getName())) {
                holder.guideReviewText.setMaxLines(Integer.MAX_VALUE);
            }
            holder.userName.setText(trailReview.getUserFirstName() + " " + trailReview.getUserLastName());
            Glide.with(mBaseActivity)
                    .load(trailReview.getUserAvatar())
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .centerCrop()
                    .placeholder(R.drawable.prof_pic)
                    .into(holder.userImg);
        }
    }

    @Override
    public int getItemCount() {
        return (null != TrailReviewList ? TrailReviewList.size() : 0);
    }

    public void setOnItemClickListener(final OnItemClickListener mItemClickListener) {
        this.mItemClickListener = mItemClickListener;
    }

    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        private de.hdodenhof.circleimageview.CircleImageView userImg;
        private CardView contentItem;
        private TextView userName;
        private TextView guideReviewText;
        private de.hdodenhof.circleimageview.CircleImageView guideImg;

        public ViewHolder(View v) {

            super(v);
            contentItem = (CardView) v.findViewById(R.id.content_item);
            contentItem.setPreventCornerOverlap(false);
            contentItem.setOnClickListener(this);
            guideReviewText = (TextView) v.findViewById(R.id.guide_review);
            userName = (TextView) v.findViewById(R.id.user_name);
            userImg = (de.hdodenhof.circleimageview.CircleImageView) v.findViewById(R.id.user_image);
            mType = mBaseActivity.getIntent().getStringExtra("type");
        }

        @Override
        public void onClick(View v) {

            if (mItemClickListener != null) {
                mItemClickListener.onItemClick(itemView, getPosition());
            }
        }
    }

}