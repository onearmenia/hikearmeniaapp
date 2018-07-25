package com.hikearmenia.adapters;

import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.imageutils.ImageLoader;
import com.hikearmenia.models.api.GuideReview;
import com.hikearmenia.ui.widgets.TextView;

import java.util.List;

/**
 * Created by jr on 5/17/16.
 */
public class GuideReviewAdapter extends RecyclerView.Adapter<GuideReviewAdapter.ViewHolder> {

    OnItemClickListener mItemClickListener;
    List<GuideReview> guideReviewList;
    private BaseActivity mBaseActivity;


    public GuideReviewAdapter(BaseActivity mBaseActivity, List<GuideReview> guideReviewList) {
        this.mBaseActivity = mBaseActivity;
        this.guideReviewList = guideReviewList;
    }

    @Override
    public GuideReviewAdapter.ViewHolder onCreateViewHolder(ViewGroup parent,
                                                            int viewType) {

        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.guide_review_adapter_item, parent, false);

        ViewHolder vh = new ViewHolder(v);
        return vh;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {

        GuideReview guideReview = guideReviewList.get(position);
        holder.guideReviewText.setText(guideReview.getGrReview());
        holder.userName.setText(guideReview.getUserFirstName() + " " + guideReview.getUserLastName());
        ImageLoader loader = new ImageLoader(mBaseActivity, false);
        loader.DisplayImage(guideReview.getUserAvatar(), holder.userImg);

//        Glide.with(mBaseActivity)
//                .load(guideReview.getUserAvatar())
//                .diskCacheStrategy(DiskCacheStrategy.ALL)
//                .centerCrop()
//                .into(holder.userImg);
    }

    @Override
    public int getItemCount() {
//        return mBaseActivity.getTrailServicsManager().getTrailsList().size();
        return guideReviewList.size();
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
            contentItem.setOnClickListener(this);
            guideReviewText = (TextView) v.findViewById(R.id.guide_review);
            userName = (TextView) v.findViewById(R.id.user_name);
            userImg = (de.hdodenhof.circleimageview.CircleImageView) v.findViewById(R.id.user_image);
            RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) contentItem.getLayoutParams();
        }

        @Override
        public void onClick(View v) {

            if (mItemClickListener != null) {
                mItemClickListener.onItemClick(itemView, getPosition());
            }
        }
    }

}

