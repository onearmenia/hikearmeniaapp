package com.hikearmenia.adapters;

import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.activities.AuthActivity;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.activities.HomeActivity;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Response;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.ui.RatingBar;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.IntentUtils;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.yayandroid.parallaxrecyclerview.ParallaxViewHolder;

import java.util.List;

/**
 * Created by jr on 4/26/16.
 */
public class SavedTrailsAdapter extends RecyclerView.Adapter<SavedTrailsAdapter.ViewHolder> {
    OnItemClickListener mItemClickListener;
    List<Trail> mTrailList;
    private BaseActivity mBaseActivity;
    private boolean savedTrails;
    private boolean isHeartedTrails = false;
    private boolean mClickedItemStates[];

    public SavedTrailsAdapter(BaseActivity mBaseActivity, List<Trail> trailsList, boolean savedTrails) {
        this.mBaseActivity = mBaseActivity;
        this.savedTrails = savedTrails;
        mTrailList = trailsList;
        mClickedItemStates = new boolean[getItemCount()];
        initImageLoader(mBaseActivity);
    }

    public static void initImageLoader(Context context) {

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

    @Override
    public SavedTrailsAdapter.ViewHolder onCreateViewHolder(ViewGroup parent,
                                                            int viewType) {

        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_saved_trails_item, parent, false);

        ViewHolder vh = new ViewHolder(v);
        return vh;
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, final int position) {
        final Trail mTrail = mTrailList.get(position);
        int width = Util.getDisplayWidth(mBaseActivity);

        DisplayImageOptions mOptions = new DisplayImageOptions.Builder()
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .showImageForEmptyUri(R.mipmap.placeholder)
                .showImageOnLoading(R.mipmap.placeholder)
                .showImageOnFail(R.mipmap.placeholder)
                .imageScaleType(ImageScaleType.NONE)
                .build();
        if (mTrail != null) {
            com.nostra13.universalimageloader.core.ImageLoader.getInstance().displayImage(mTrail.getTrailCover(),
                    holder.coverPhotoTrail, mOptions);
            holder.coverPhotoTrail.setScaleType(ImageView.ScaleType.CENTER_CROP);

            if (mTrail.getReviewCount() == 1) {
                holder.trailReview.setText(String.format(mBaseActivity.getString(R.string.one_review_guides), mTrail.getReviewCount()));
            } else {
                holder.trailReview.setText(String.format(mBaseActivity.getString(R.string.reviews_guides), mTrail.getReviewCount()));
            }
            holder.trailName.setText(mTrail.getTrailName());
            holder.hoursTv.setText(mTrail.getTrailTime());
            holder.trailDistance.setText(String.format(mBaseActivity.getResources().getString(R.string.trail_distance), mTrail.getTrailDistance()));
            holder.trailDifficulty.setText(mTrail.getTrailDifficulty());
            RatingBar ratingBar = new RatingBar(mBaseActivity, holder.ratingBarLayout);
            ratingBar.getParams(((int) (width * 0.04)), ((int) (width * 0.04)), mTrail.getAverageRating(), true);
        }
        if (mTrail.isSaved()) {
            holder.mFavouriteTrail
                    .setImageResource(R.mipmap.heartred_trails);
        } else {
            holder.mFavouriteTrail
                    .setImageResource(R.mipmap.heart_trails);
        }

        holder.heartTrailsLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (Util.isNetworkAvailable(mBaseActivity, true)) {

                            if (mBaseActivity.getUserServiceManager().getUser() != null && mBaseActivity.getUserServiceManager().getUser().getToken() != null) {
                                if (!mTrail.isSaved()) {
                                    mBaseActivity.getTrailServicsManager().saveTrail(String.valueOf(mTrailList.get(position).getTrailId()),
                                            mBaseActivity.getUserServiceManager().getUser().getToken(), new NetworkRequestListener<Response>() {
                                                @Override
                                                public void onResponseReceive(Response obj) {
                                                    if (obj != null && obj.getResult() != null) {
                                                        mTrail.setIsSaved(true);
                                                        holder.mFavouriteTrail
                                                                .setImageResource(R.mipmap.heartred_trails);
                                                    }
                                                }

                                                @Override
                                                public void onError(String message) {
                                                    UIUtil.alertDialogShow(mBaseActivity, mBaseActivity.getString(R.string.error_dialog), mBaseActivity.getString(R.string.save_trail_networking_failed));
                                                }
                                            });

                                } else {
                                    mBaseActivity.getTrailServicsManager().removeFromSavedTrails(String.valueOf(mTrailList.get(position).getTrailId()),
                                            mBaseActivity.getUserServiceManager().getUser().getToken(), new NetworkRequestListener<Response>() {
                                                @Override
                                                public void onResponseReceive(Response obj) {
                                                    holder.mFavouriteTrail
                                                            .setImageResource(R.mipmap.heart_trails);
                                                    mTrail.setIsSaved(false);
                                                    if (obj != null && obj.getResult() != null) {
                                                        holder.mFavouriteTrail
                                                                .setImageResource(R.mipmap.heart_trails);
                                                        if (savedTrails) {
                                                            removeAt(position);
                                                        }

                                                        mTrail.setIsSaved(false);
                                                        if (mTrailList.size() == 0) {
                                                            ((HomeActivity) mBaseActivity).showEmptyText(false);
                                                        }
                                                    }
                                                }

                                                @Override
                                                public void onError(String message) {

                                                }
                                            });
                                }
                            } else {
                                Intent intent = new Intent(mBaseActivity, AuthActivity.class);
                                IntentUtils.getInstance().startActivityForResult(mBaseActivity, 2, intent, null, false);
                            }
                        }
                    }
                }).playOn(v, mBaseActivity.STANDART_DURETION);

            }
        });


    }

    @Override
    public int getItemCount() {
        return mTrailList.size();
    }

    public void setOnItemClickListener(final OnItemClickListener mItemClickListener) {
        this.mItemClickListener = mItemClickListener;
    }

    public List<Trail> updateList() {

        return mBaseActivity.getTrailServicsManager().getTrailsList();

    }

    public void removeAt(int position) {
        mTrailList.remove(position);
        notifyItemRemoved(position);
        notifyItemRangeChanged(position, mTrailList.size());
    }

    public void swap(List<Trail> updatedData) {
        mTrailList.clear();
        mTrailList.addAll(updatedData);
        notifyDataSetChanged();
    }

    public void swap(List<Trail> updatedData, boolean savedTrails) {
        this.savedTrails = savedTrails;
        mTrailList.clear();
        mTrailList.addAll(updatedData);
        notifyDataSetChanged();
    }

    public void clear() {
        mTrailList.clear();
        notifyDataSetChanged();
    }

    // Add a list of items
    public void addAll(List<Trail> list) {
        mTrailList.addAll(list);
        notifyDataSetChanged();
    }

    public interface OnItemClickListener {
        void onItemClick(View view, List<Trail> trailList, int position, Trail trail);
    }

    public class ViewHolder extends ParallaxViewHolder implements View.OnClickListener {
        public ImageView mFavouriteTrail;
        public com.yayandroid.parallaxrecyclerview.ParallaxImageView coverPhotoTrail;
        public TextView trailName;
        public TextView hoursTv;
        public TextView trailDistance;
        private FrameLayout contentItem;
        private FrameLayout heartTrailsLayout;
        private TextView trailDifficulty;
        private TextView trailReview;
        private RelativeLayout ratingBarLayout;
        private RelativeLayout trailLayout;

        public ViewHolder(View v) {
            super(v);
            contentItem = (FrameLayout) v.findViewById(R.id.content_item);
            // contentItem.setPreventCornerOverlap (false);
            RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) contentItem.getLayoutParams();
            params.height = (int) (Util.getDisplayHeight(mBaseActivity) * 0.24);
            contentItem.setLayoutParams(params);
            coverPhotoTrail = (com.yayandroid.parallaxrecyclerview.ParallaxImageView) v.findViewById(R.id.image_item);
            mFavouriteTrail = (ImageView) v.findViewById(R.id.heart_trails);
            contentItem.setOnClickListener(this);
            trailName = (TextView) v.findViewById(R.id.trail_name);
            hoursTv = (TextView) v.findViewById(R.id.hours_tv);
            trailDistance = (TextView) v.findViewById(R.id.trail_distance);
            trailDifficulty = (TextView) v.findViewById(R.id.trail_difficulty);
            trailReview = (TextView) v.findViewById(R.id.trail_review);
            heartTrailsLayout = (FrameLayout) v.findViewById(R.id.heart_trails_layout);
            ratingBarLayout = (RelativeLayout) v.findViewById(R.id.rating_bar);
            trailLayout = (RelativeLayout) v.findViewById(R.id.saved_trail_detail_image);

            trailLayout.measure(0, 0);
            trailName.measure(0, 0);

            int trailNameWidth = trailName.getMeasuredWidth();
            int layoutWidth = trailLayout.getMeasuredWidth();
            int newTextSize = (int) trailName.getTextSize();
//            int width = Util.getDisplayWidth(mBaseActivity);
            while ((trailNameWidth / layoutWidth) > 0.6) {
                newTextSize -= 1;
                trailName.measure(0, 0);
//                trailLayout.measure(0, 0);
                trailName.setTextSize(TypedValue.COMPLEX_UNIT_SP, newTextSize);
                trailNameWidth = trailName.getMeasuredWidth();
            }

        }

        @Override
        public int getParallaxImageId() {
            return R.id.image_item;
        }

        @Override
        public void onClick(View v) {
            if (mItemClickListener != null) {
                mItemClickListener.onItemClick(itemView, mTrailList, getPosition(), mTrailList.get(getPosition()));
            }
        }
    }

}