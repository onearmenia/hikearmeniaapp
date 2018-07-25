package com.hikearmenia.adapters;

import android.support.v7.widget.RecyclerView;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.models.api.Guide;

/**
 * Created by anikarapetyan on 6/1/16.
 */
public class GuideLanguagesAdapter extends RecyclerView.Adapter<GuideLanguagesAdapter.ViewHolder> {
    Guide guide;
    private BaseActivity mBaseActivity;

    public GuideLanguagesAdapter(BaseActivity mBaseActivity, Guide mGuide) {
        this.mBaseActivity = mBaseActivity;
        guide = mGuide;
    }

    @Override
    public GuideLanguagesAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.flag_guid_review_adapter_item, parent, false);

        ViewHolder vh = new ViewHolder(v);
        return vh;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        DisplayMetrics displaymetrics = new DisplayMetrics();
        mBaseActivity.getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
        int width = displaymetrics.widthPixels;
        holder.flagItem.getLayoutParams().width = ((int) (width * 0.053));
        holder.flagItem.getLayoutParams().height = ((int) (width * 0.053));

//        loader.DisplayImage(guide.getGuideLanguage().get(position).getLangImg(), holder.flagItem);
        Glide.with(mBaseActivity)
                .load(guide.getGuideLanguage().get(position).getLangImg())
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .centerCrop()
                .into(holder.flagItem);
    }

    @Override
    public int getItemCount() {
        return guide.getGuideLanguage().size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private ImageView flagItem;

        public ViewHolder(View v) {

            super(v);
            flagItem = (ImageView) v.findViewById(R.id.flag_img);
        }
    }
}
