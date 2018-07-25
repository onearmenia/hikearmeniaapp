package com.hikearmenia.fragment;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.RelativeLayout;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.requests.ReviewRequest;
import com.hikearmenia.ui.RatingBar;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.UIUtil;

public class WriteReviewFragment extends Fragment implements NetworkRequestListener {

    static BaseActivity mBaseActivity;
    static int mId;
    static String mType;
    RatingBar ratingBar1;
    private EditText reviewsEdidtText;
    private TextView reviewsTv;
    private TextView characterCount;

    public WriteReviewFragment() {
    }


    public static WriteReviewFragment getInstance(BaseActivity baseActivity, int id, String type) {
        WriteReviewFragment fragment = new WriteReviewFragment();
        mBaseActivity = baseActivity;
        Bundle args = new Bundle();
        mId = id;
        mType = type;
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        InputMethodManager imm = (InputMethodManager) getActivity()
                .getSystemService(Context.INPUT_METHOD_SERVICE);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_write_review, container, false);

        reviewsEdidtText = (EditText) v.findViewById(R.id.reviews_edit_text);
        reviewsTv = (TextView) v.findViewById(R.id.guide_reviews_tv);
        characterCount = (TextView) v.findViewById(R.id.max_character);
        characterCount.setText(String.format(mBaseActivity.getString(R.string.max_characters), 300));
        RelativeLayout ratingBar = (RelativeLayout) v.findViewById(R.id.rating_bar);
        ratingBar1 = new RatingBar(getActivity(), ratingBar);
        ratingBar1.getTheInflatedView();
        if (mType.equals("addGuidReview")) {
            reviewsTv.setText(getString(R.string.write_a_review));
        } else if (mType.equals("addTrailReview")) {
            reviewsTv.setText(getString(R.string.write_a_trail_tip));
        }
        ;
        reviewsEdidtText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int aft) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                // this will show characters remaining
                characterCount.setText(String.format(mBaseActivity.getString(R.string.max_characters), 300 - s.toString().length()));
//
            }
        });
        return v;
    }

    public String getReviewText() {
        return reviewsEdidtText.getText().toString();
    }

    public int getRetingBarValue() {
        return ratingBar1.getRating();
    }

    public void sendData(String type) {
        if (type.equals("addGuidReview")) {
            UIUtil.showProgressDialog(mBaseActivity);
            ReviewRequest guideReviewRequest = new ReviewRequest(reviewsEdidtText.getText().toString(), String.valueOf(ratingBar1.getRating()));
            mBaseActivity.guideReview(WriteReviewFragment.this, mId, guideReviewRequest);

        } else if (type.equals("addTrailReview")) {
            if (!reviewsEdidtText.getText().toString().matches("") || ratingBar1.getRating() > 0) {
                ReviewRequest trailReviewRequest = new ReviewRequest(reviewsEdidtText.getText().toString(), String.valueOf(ratingBar1.getRating()));
                mBaseActivity.traileReview(WriteReviewFragment.this, mId, trailReviewRequest);
                UIUtil.showProgressDialog(mBaseActivity);
                mBaseActivity.setResult(ResultCodes.RESULT_TRAIL_TIPS_POSTED_OK);
            } else {
                UIUtil.alertDialogShow(mBaseActivity, getString(R.string.warning), getString(R.string.review_screen_warning_message));
            }

        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

    }

    @Override
    public void onDetach() {
        super.onDetach();

    }

    @Override
    public void onResponseReceive(Object obj) {
        if (mType.equals("addGuidReview")) {
            mBaseActivity.getSupportFragmentManager().beginTransaction()
                    .setCustomAnimations(R.anim.slide_out_left, R.anim.slide_out_right)
                    .remove(this)
                    .commit();
            mBaseActivity.setResult(ResultCodes.RESULT_CODE_DIALOG_OK);
            UIUtil.hideProgressDialog(mBaseActivity);
            UIUtil.alertDialogShow(mBaseActivity, getString(R.string.sucses), getString(R.string.review_posted_message));
        } else {
            mBaseActivity.finish();
        }
    }

    @Override
    public void onError(String message) {
        //UIUtil.alertDialogShow(mBaseActivity,getString(R.string.error_dialog),getString(R.string.save_trail_networking_failed));
    }
}
