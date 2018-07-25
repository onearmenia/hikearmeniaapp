package com.hikearmenia.manager;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.app.ManagerContext;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.TrailRoute;
import com.hikearmenia.models.api.User;
import com.hikearmenia.models.requests.ApiRequest;
import com.hikearmenia.models.requests.ChangePasswordRequest;
import com.hikearmenia.models.requests.ForgetPasswordRequest;
import com.hikearmenia.models.requests.SignInRequest;
import com.hikearmenia.models.requests.SignUpRequest;
import com.hikearmenia.models.requests.UserRouteRequest;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by Martha on 4/12/2016.
 */
public class UserServiceManager extends BaseManager {

    private static final String KEY_CUSTOMER = "CUSTOMER";
    private BaseActivity baseActivity;
    private User currentUser;
    private String saveUserPath = "user";

    public UserServiceManager(ManagerContext c, Context context) {
        super(c, context);
        baseActivity = (BaseActivity) context;
        if (currentUser == null) {
            if (Util.isFileExist(saveUserPath, baseActivity)) {
                currentUser = getUserCache();
            } else {
                currentUser = new User(true);
            }
        }

    }

    /**
     * @param userSigninObj
     * @param listener
     */
    public void loginRequest(SignInRequest userSigninObj, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<User.UserResponse> call = service.signInUser(userSigninObj);

        call.enqueue(new Callback<User.UserResponse>() {
            @Override
            public void onResponse(Call<User.UserResponse> call, Response<User.UserResponse> response) {
                User.UserResponse responce = response.body();
                if (responce != null) {
                    if (responce.getResult() != null) {
                        currentUser = responce.getResult();
                        saveUser();
                        listener.onResponseReceive(null);
                    } else if (responce != null && responce.getError() != null) {
                        listener.onError("Error");
                    } else {
                        Util.isNetworkAvailable(baseActivity, true);

                        listener.onError("Error occured");
                    }
                } else {
                    Util.isNetworkAvailable(baseActivity, true);
                    listener.onError("Error occured");
                }
            }

            @Override
            public void onFailure(Call<User.UserResponse> call, Throwable t) {
                UIUtil.hideProgressDialog(baseActivity);
                if (t != null) {
                    UIUtil.alertDialogShow(baseActivity, baseActivity.getString(R.string.login_failed), t.getMessage());
                }
            }
        });
    }


    public void changePassword(ChangePasswordRequest changePasswordRequest, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<com.hikearmenia.models.api.Response> call = service.changePassword(changePasswordRequest, getUser().getToken());

        call.enqueue(new Callback<com.hikearmenia.models.api.Response>() {
            @Override
            public void onResponse(Call<com.hikearmenia.models.api.Response> call, Response<com.hikearmenia.models.api.Response> response) {
                if (response.body() != null && response.body().getResult() != null) {
                    listener.onResponseReceive(response.body().getResult());
                } else {
                    listener.onError(baseActivity.getString(R.string.wrong_password));
                }
            }

            @Override
            public void onFailure(Call<com.hikearmenia.models.api.Response> call, Throwable t) {
                UIUtil.hideProgressDialog(baseActivity);
                if (t != null) {
                    listener.onError(t.getMessage());
                }
            }
        });
    }

    /**
     * @param userSignupObj
     */
    public void signup(SignUpRequest userSignupObj, final NetworkRequestListener listener) {

        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<User.UserResponse> call = service.signup(userSignupObj);
        call.enqueue(new Callback<User.UserResponse>() {
            @Override
            public void onResponse(Call<User.UserResponse> call, Response<User.UserResponse> response) {
                User.UserResponse responce = response.body();
                if (responce != null) {
                    if (responce.getResult() != null) {
                        currentUser = responce.getResult();
                        saveUser();
                        listener.onResponseReceive(null);

                    } else if (responce != null && responce.getError() != null) {
                        listener.onError(responce.getError().getMessage());
                    } else {

                        Util.isNetworkAvailable(baseActivity, true);

                        listener.onError("Error occured");
                    }
                } else {
                    listener.onError("s");
                }
            }

            @Override
            public void onFailure(Call<User.UserResponse> call, Throwable t) {
                listener.onError(t.getMessage());
            }
        });
    }

    public void loginWithFacebook(final SignInRequest request, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<User.UserResponse> call = service.loginWithFacebook(request);
        call.enqueue(new Callback<User.UserResponse>() {
            @Override
            public void onResponse(Call<User.UserResponse> call, Response<User.UserResponse> response) {
                User.UserResponse responce = response.body();
                if (responce != null) {
                    listener.onResponseReceive(null);
                    currentUser = responce.getResult();
                } else {

                    Util.isNetworkAvailable(baseActivity, true);

                    listener.onError("Server error");
                }
            }

            @Override
            public void onFailure(Call<User.UserResponse> call, Throwable t) {
                if (t != null) {
                    UIUtil.alertDialogShow(baseActivity, baseActivity.getString(R.string.login_with_facebook_failed), t.getMessage());
                }

            }
        });

    }

    public void updateUserData(final SignInRequest request, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Gson gson = new Gson();
        JsonElement jsonRequest = gson.toJsonTree(request);
        Call<User.UserResponse> call = service.updateUserData(getUser().getId(), jsonRequest, getUser().getToken());


        call.enqueue(new Callback<User.UserResponse>() {
            @Override
            public void onResponse(Call<User.UserResponse> call, Response<User.UserResponse> response) {
                User newUser = (User) response.body().getResult();
                User user = response.body().getResult();
                if (response != null && response != null) {
                    currentUser = user;
                    saveUser();
                    listener.onResponseReceive(null);
                } else if (response != null) {
                    if (response.errorBody() != null) {
                        listener.onError("Error");
                    }
                } else {
                    Util.isNetworkAvailable(baseActivity, true);

                    listener.onError("Error Occured");
                }
            }

            @Override
            public void onFailure(Call<User.UserResponse> call, Throwable t) {
                Log.e("ERROR", t.getMessage());
            }
        });
    }

    public User getUser() {
        return currentUser;
    }

    public void signOutUser() {
        currentUser = new User(true);
        saveUser();
    }

    private void saveUser() {
        try {
            FileOutputStream fos = baseActivity.openFileOutput(saveUserPath, Context.MODE_PRIVATE);
            ObjectOutputStream os = new ObjectOutputStream(fos);
            os.writeObject(currentUser);
            os.close();
            fos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private User getUserCache() {
        User user = new User(true);
        try {
            FileInputStream fis = baseActivity.openFileInput(saveUserPath);
            ObjectInputStream is = new ObjectInputStream(fis);
            user = (User) is.readObject();
            is.close();
            fis.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public void recoverPassword(String email, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        ForgetPasswordRequest forgetPasswordRequest = new ForgetPasswordRequest(email);
        Call<com.hikearmenia.models.api.Response> call = service.forgetPassword(forgetPasswordRequest);
        call.enqueue(new Callback<com.hikearmenia.models.api.Response>() {
            @Override
            public void onResponse(Call<com.hikearmenia.models.api.Response> call, Response<com.hikearmenia.models.api.Response> response) {
                com.hikearmenia.models.api.Response responce = response.body();
                if (responce != null && responce.getResult() != null) {
                    listener.onResponseReceive(responce);
                } else {
                    Util.isNetworkAvailable(baseActivity, true);

                    listener.onError("Server error");
                }
            }

            @Override
            public void onFailure(Call<com.hikearmenia.models.api.Response> call, Throwable t) {

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

        outState.putParcelable(KEY_CUSTOMER, currentUser);
    }

    @Override
    public synchronized void onRestoreInstanceState(Bundle inState) {
        super.onRestoreInstanceState(inState);

        if (currentUser == null) {
            currentUser = inState.getParcelable(KEY_CUSTOMER);
        }
    }

    public void sendUserRoute(List<TrailRoute> route, int trailId, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        UserRouteRequest request = new UserRouteRequest(route);
        Call<com.hikearmenia.models.api.Response> call = service.sendUserRoute(request, trailId, getUser().getToken());
        call.enqueue(new Callback<com.hikearmenia.models.api.Response>() {
            @Override
            public void onResponse(Call<com.hikearmenia.models.api.Response> call, Response<com.hikearmenia.models.api.Response> response) {
                listener.onResponseReceive(response.body());
            }

            @Override
            public void onFailure(Call<com.hikearmenia.models.api.Response> call, Throwable t) {
                listener.onError(t.getMessage());
            }
        });
    }

    public void getUserRoute(int trailId, final NetworkRequestListener listener) {
        ApiRequest service = baseActivity.retrofit.create(ApiRequest.class);
        Call<com.hikearmenia.models.api.Response> call = service.getUserRoute(trailId, getUser().getToken());
        call.enqueue(new Callback<com.hikearmenia.models.api.Response>() {
            @Override
            public void onResponse(Call<com.hikearmenia.models.api.Response> call, Response<com.hikearmenia.models.api.Response> response) {
                listener.onResponseReceive(response.body());
            }

            @Override
            public void onFailure(Call<com.hikearmenia.models.api.Response> call, Throwable t) {
                listener.onError(t.getMessage());
            }
        });

    }
}
