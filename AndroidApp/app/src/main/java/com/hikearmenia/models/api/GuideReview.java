package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by jr on 5/16/16.
 */
public class GuideReview implements Serializable, Parcelable {

    public static final Creator<GuideReview> CREATOR = new Creator<GuideReview>() {
        @Override
        public GuideReview createFromParcel(Parcel in) {
            return new GuideReview(in);
        }

        @Override
        public GuideReview[] newArray(int size) {
            return new GuideReview[size];
        }
    };
    @Expose
    @SerializedName("gr_id")
    private int grId;

    @Expose
    @SerializedName("gr_user_id")
    private int grUserId;

    @Expose
    @SerializedName("gr_guide_id")
    private int grGuideId;

    @Expose
    @SerializedName("gr_review")
    private String grReview;

    @Expose
    @SerializedName("gr_rating")
    private float grRating;

    @Expose
    @SerializedName("gr_status")
    private String grStatus;

    @Expose
    @SerializedName("user_first_name")
    private String userFirstName;

    @Expose
    @SerializedName("user_last_name")
    private String userLastName;

    @Expose
    @SerializedName("user_avatar")
    private String userAvatar;


    public GuideReview(int grGuideId, String grReview) {
        this.grGuideId = grGuideId;
        this.grReview = grReview;
    }

    protected GuideReview(Parcel in) {
        grId = in.readInt();
        grUserId = in.readInt();
        grGuideId = in.readInt();
        grReview = in.readString();
        grRating = in.readFloat();
        grStatus = in.readString();
        userFirstName = in.readString();
        userLastName = in.readString();
        userAvatar = in.readString();
    }

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    public int getGrId() {
        return grId;
    }

    public void setGrId(int grId) {
        this.grId = grId;
    }

    public int getGrUserId() {
        return grUserId;
    }

    public void setGrUserId(int grUserId) {
        this.grUserId = grUserId;
    }

    public int getGrGuideId() {
        return grGuideId;
    }

    public void setGrGuideId(int grGuideId) {
        this.grGuideId = grGuideId;
    }

    public String getGrReview() {
        return grReview;
    }

    public void setGrReview(String grReview) {
        this.grReview = grReview;
    }

    public float getGrRating() {
        return grRating;
    }

    public void setGrRating(float grRating) {
        this.grRating = grRating;
    }

    public String getGrStatus() {
        return grStatus;
    }

    public void setGrStatus(String grStatus) {
        this.grStatus = grStatus;
    }

    public String getUserFirstName() {
        return userFirstName;
    }

    public void setUserFirstName(String userFirstName) {
        this.userFirstName = userFirstName;
    }

    public String getUserLastName() {
        return userLastName;
    }

    public void setUserLastName(String userLastName) {
        this.userLastName = userLastName;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(grId);
        dest.writeInt(grUserId);
        dest.writeInt(grGuideId);
        dest.writeString(grReview);
        dest.writeFloat(grRating);
        dest.writeString(grStatus);
        dest.writeString(userFirstName);
        dest.writeString(userLastName);
        dest.writeString(userAvatar);
    }
}
