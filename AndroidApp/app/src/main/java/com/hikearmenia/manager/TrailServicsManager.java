package com.hikearmenia.manager;

import android.content.Context;
import android.os.Bundle;

import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.app.ManagerContext;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.Direction;
import com.hikearmenia.models.api.Response;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.models.api.TrailReview;
import com.hikearmenia.models.requests.ApiRequest;
import com.hikearmenia.util.Util;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;

/**
 * Created by jr on 5/4/16.
 */
public class TrailServicsManager extends BaseManager {

    private static final String KEY_TRAIL = "KEY_TRAIL";
    Call<Response<Trail>> callTrail;
    private BaseActivity baseActivity;
    private Response mResponse;
    private List<Trail> trailsList;
    private Trail mTrail;

    public TrailServicsManager(ManagerContext c, Context context) {
        super(c, context);
        baseActivity = (BaseActivity) context;
    }

    public void getListOfTrails(final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<Response<List<Trail>>> call;
        if (baseActivity.getUserServiceManager().getUser() != null && !baseActivity.getUserServiceManager().getUser().isGuest()) {
            call = service.listOfTrails(baseActivity.getUserServiceManager().getUser().getToken());
        } else {
            call = service.listOfTrails("");
        }
        call.enqueue(new Callback<Response<List<Trail>>>() {
            @Override
            public void onResponse(Call<Response<List<Trail>>> call, retrofit2.Response<Response<List<Trail>>> response) {
                if (response != null) {
                    trailsList = response.body().getResult();
                    listener.onResponseReceive(trailsList);
                } else {
                    listener.onError("Error");
                    Util.isNetworkAvailable(baseActivity, true);
                }
            }

            @Override
            public void onFailure(Call<Response<List<Trail>>> call, Throwable t) {

            }
        });
    }

    public ArrayList<Trail> filterSavedTrails() {
        ArrayList<Trail> savedTrailsList = new ArrayList<Trail>();
        for (int i = 0; i < getTrailsList().size(); i++) {
            if (getTrailsList().get(i).isSaved()) {
                savedTrailsList.add(getTrailsList().get(i));
            }
        }
        return savedTrailsList;
    }

    public void removeSavedTrailById(int id) {
        for (int i = 0; i < getTrailsList().size(); i++) {
            if (getTrailsList().get(i).getTrailId() == id) {
                getTrailsList().get(i).setIsSaved(false);
            }
        }
    }

    public void addtoSavedTrail(int id) {
        for (int i = 0; i < getTrailsList().size(); i++) {
            if (getTrailsList().get(i).getTrailId() == id) {
                getTrailsList().get(i).setIsSaved(true);
            }
        }
    }


    public void removeFromSavedTrails(final String trailID, String token, final NetworkRequestListener<Response> listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);

        Call<Response> call = service.removeFromSavedTrails(Integer.valueOf(trailID), token);
        call.enqueue(new Callback<Response>() {
            @Override
            public void onResponse(Call<Response> call, retrofit2.Response<Response> response) {
                if (response != null) {
                    listener.onResponseReceive(response.body());
                } else {
                    listener.onError("Error");
                    Util.isNetworkAvailable(baseActivity, true);

                }
            }

            @Override
            public void onFailure(Call<Response> call, Throwable t) {
                listener.onError("Error");
            }
        });
    }

    public void saveTrail(String trailID, String token, final NetworkRequestListener<Response> listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);

        Call<Response> call = service.saveTrail(Integer.valueOf(trailID), token);
        call.enqueue(new Callback<Response>() {
            @Override
            public void onResponse(Call<Response> call, retrofit2.Response<Response> response) {
                if (response != null) {
                    listener.onResponseReceive(response.body());
                } else {
                    listener.onError("Error");
                    Util.isNetworkAvailable(baseActivity, true);

                }
            }

            @Override
            public void onFailure(Call<Response> call, Throwable t) {
                listener.onError("Error");
            }
        });
    }

    public List<Direction> getTrailsDirections() {
        List<Direction> directions = new ArrayList<>();
        if (trailsList != null && !trailsList.isEmpty()) {
            for (Trail t : trailsList) {
                Direction d = new Direction(t.getTrailName(), t.getLatitudeStart(), t.getLatitudeEnd(), t.getLongitudeStart(), t.getLongitudeEnd());
                directions.add(d);
            }
        }
        return directions;
    }

    public List<Direction> getSavedTrailsDirections() {
        List<Direction> directions = new ArrayList<>();
        if (filterSavedTrails() != null && !filterSavedTrails().isEmpty()) {
            for (Trail t : filterSavedTrails()) {
                Direction d = new Direction(t.getTrailName(), t.getLatitudeStart(), t.getLatitudeEnd(), t.getLongitudeStart(), t.getLongitudeEnd());
                directions.add(d);
            }
        }
        return directions;
    }

    public List<Trail> getTrailsList() {
        if (trailsList == null) {
            return new ArrayList<>();
        }
        return trailsList;
    }

    public Trail getmTrail() {
        return mTrail;
    }

    public Trail getCurrentTrail(String markerTitle) {
        for (int i = 0; i < getTrailsList().size(); i++) {
            if (getTrailsList().get(i).getTrailName().equals(markerTitle)) {
                return getTrailsList().get(i);
            }
        }
        return null;
    }

    public void loadDetailTrail(String trailId, final NetworkRequestListener<Trail> listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        callTrail = service.trailDetail(trailId, "");
        if (baseActivity.getUserServiceManager().getUser() != null && !baseActivity.getUserServiceManager().getUser().isGuest()) {
            callTrail = service.trailDetail(trailId, baseActivity.getUserServiceManager().getUser().getToken());
        }
        final Trail[] trail = {null};
        callTrail.enqueue(new Callback<Response<Trail>>() {
            @Override
            public void onResponse(Call<Response<Trail>> call, retrofit2.Response<Response<Trail>> response) {
                if (response != null) {
                    if (response.body() != null) {
                        trail[0] = response.body().getResult();
                        mTrail = trail[0];
                        saveTrail(mTrail);
                        if (callTrail.isExecuted()) {
                            listener.onResponseReceive(trail[0]);
                        }

                    } else {
                        Util.isNetworkAvailable(baseActivity, true);
                        listener.onError("Error");
                    }
                } else {
                    Util.isNetworkAvailable(baseActivity, true);
                    listener.onError("Error");
                }
            }

            @Override
            public void onFailure(Call<Response<Trail>> call, Throwable t) {
            }
        });
    }

    public void cancelRequest() {
        if (callTrail != null) {
            callTrail.cancel();
        }
    }

    public void loadTrailReviews(int trailID, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<Response<List<TrailReview>>> call = service.trailReviews(trailID);
        call.enqueue(new Callback<Response<List<TrailReview>>>() {
            @Override
            public void onResponse(Call<Response<List<TrailReview>>> call, retrofit2.Response<Response<List<TrailReview>>> response) {
                if (response != null) {
                    if (response.body() != null) {
                        List<TrailReview> reviews = response.body().getResult();
                        listener.onResponseReceive(reviews);
                    } else {
                        Util.isNetworkAvailable(baseActivity, true);
                        listener.onError(response.body().error.getMessage());
                    }
                } else {
                }
            }

            @Override
            public void onFailure(Call<Response<List<TrailReview>>> call, Throwable t) {
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
        outState.putParcelable(KEY_TRAIL, mTrail);
        // don't work
    }

    @Override
    public synchronized void onRestoreInstanceState(Bundle inState) {

        super.onRestoreInstanceState(inState);

        if (mTrail == null) {
            //  mTrail = inState.getParcelable(KEY_TRAIL);
            mTrail = getTrailCache();
        }
    }


    private void saveTrail(Trail trail) {
        try {
            FileOutputStream fos = baseActivity.openFileOutput("Trail", Context.MODE_PRIVATE);
            ObjectOutputStream os = new ObjectOutputStream(fos);
            os.writeObject(trail);
            os.close();
            fos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private Trail getTrailCache() {
        Trail trail = null;
        try {
            FileInputStream fis = baseActivity.openFileInput("Trail");
            ObjectInputStream is = new ObjectInputStream(fis);
            trail = (Trail) is.readObject();
            is.close();
            fis.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trail;
    }
}
