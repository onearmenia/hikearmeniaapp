package com.hikearmenia.models.requests;


import com.google.gson.JsonElement;
import com.hikearmenia.models.api.Guide;
import com.hikearmenia.models.api.Response;
import com.hikearmenia.models.api.Trail;
import com.hikearmenia.models.api.TrailReview;
import com.hikearmenia.models.api.User;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;


/**
 * Created by Martha on 4/12/2016.
 */
public interface ApiRequest {

    @POST("/api/register")
    Call<User.UserResponse> signup(@Body SignUpRequest signUpRequest);

    @POST("/api/login")
    Call<User.UserResponse> signInUser(@Body SignInRequest signInRequest);

    @PUT("/api/user/{user_id}")
    Call<User.UserResponse>
    updateUserData(@Path("user_id") String userId, @Body JsonElement user, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @PUT("api/saved-trails/{trail_id}")
    Call<Response> saveTrail(@Path("trail_id") int trailId, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @DELETE("api/saved-trails/{trail_id}")
    Call<Response> removeFromSavedTrails(@Path("trail_id") int trailId, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @POST("/api/change-password")
    Call<Response> changePassword(@Body ChangePasswordRequest changePasswordRequest, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @POST("/api/login")
    Call<User.UserResponse> loginWithFacebook(@Body SignInRequest fb_token);

    @PUT("/api/user")
    Call<User.UserResponse> updateUserData(@Body User user, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @POST("/api/forgot-password")
    Call<Response> forgetPassword(@Body ForgetPasswordRequest email);

    @GET("/api/trails")
    Call<Response<List<Trail>>> listOfTrails(@Header("X_HTTP_AUTH_TOKEN") String userToken);

    @GET("/api/trails/{trail_id}")
    Call<Response<Trail>> trailDetail(@Path("trail_id") String trail_id, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @GET("/api/guide/?language=")
    Call<Response<List<Guide>>> listOfGuide(@Query("language") String language);

    @GET("api/trail-guides/{trail_id}?language=")
    Call<Response<List<Guide>>> listOfGuideByTrailID(@Path("trail_id") String trailID, @Query("language") String language);

    @GET("/api/guide/{guide_id}")
    Call<Response<Guide>> listOfGuideReview(@Path("guide_id") int guide_id);

    @PUT("/api/guide-review/{guide_id}")
    Call<Response> guideReview(@Path("guide_id") int guideId, @Body ReviewRequest guideReviewRequest, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @PUT("api/trail-review/{trail_id}")
    Call<Response> trailReview(@Path("trail_id") int trailId, @Body ReviewRequest trailReviewRequest, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @GET("api/trail-review/{trail_id}")
    Call<Response<List<TrailReview>>> trailReviews(@Path("trail_id") int trail_id);


    @PUT("api/trails/{trail_id}")
    Call<Response> sendUserRoute(@Body UserRouteRequest routeRequest, @Path("trail_id") int trail_id, @Header("X_HTTP_AUTH_TOKEN") String userToken);

    @GET("api/user-trails/{trail_id}")
    Call<Response> getUserRoute(@Path("trail_id") int trail_id, @Header("X_HTTP_AUTH_TOKEN") String userToken);

}
