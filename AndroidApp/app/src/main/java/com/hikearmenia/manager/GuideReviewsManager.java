package com.hikearmenia.manager;

import android.content.Context;
import android.os.Bundle;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.app.ManagerContext;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Guide;
import com.hikearmenia.models.api.Response;
import com.hikearmenia.models.requests.ApiRequest;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;

import retrofit2.Call;
import retrofit2.Callback;

/**
 * Created by jr on 5/16/16.
 */
public class GuideReviewsManager extends BaseManager {
    private BaseActivity baseActivity;
    private Guide guideFullData;

    public GuideReviewsManager(ManagerContext c, Context context) {
        super(c, context);
        baseActivity = (BaseActivity) context;
    }

    public void getGuidDetailInfo(final NetworkRequestListener listener, int guideId) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<Response<Guide>> call = service.listOfGuideReview(guideId);
        call.enqueue(new Callback<Response<Guide>>() {
            @Override
            public void onResponse(Call<Response<Guide>> call, retrofit2.Response<Response<Guide>> response) {
                if (response != null) {
                    guideFullData = response.body().getResult();
                    listener.onResponseReceive(guideFullData);
                } else {
                    Util.isNetworkAvailable(baseActivity, true);
                    listener.onError("Error");
                }
            }

            @Override
            public void onFailure(Call<Response<Guide>> call, Throwable t) {
                if (t != null) {
                    UIUtil.alertDialogShow(getAppContext(), getAppContext().getString(R.string.error_dialog), t.getMessage());
                }

            }
        });
    }

    /***/
    @Override
    public BaseManager.Initializer getInitializer() {
        return new AsyncInitializer();
    }

    @Override
    public synchronized void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);

//        outState.putParcelable(KEY_CUSTOMER, currentUser);
    }

    @Override
    public synchronized void onRestoreInstanceState(Bundle inState) {
        super.onRestoreInstanceState(inState);

//        if (currentUser == null) {
//            currentUser = inState.getParcelable(KEY_CUSTOMER);
//        }
    }
}
