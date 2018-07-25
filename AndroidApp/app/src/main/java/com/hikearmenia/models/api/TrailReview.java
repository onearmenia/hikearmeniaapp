package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by anikarapetyan1 on 5/23/16.
 */
public class TrailReview implements Serializable, Parcelable {

    public static final Creator<TrailReview> CREATOR = new Creator<TrailReview>() {
        @Override
        public TrailReview createFromParcel(Parcel in) {
            return new TrailReview(in);
        }

        @Override
        public TrailReview[] newArray(int size) {
            return new TrailReview[size];
        }
    };
    @Expose
    @SerializedName("tr_id")
    private int trId;

    @Expose
    @SerializedName("tr_trail_id")
    private int trailID;

    @Expose
    @SerializedName("tr_user_id")
    private int trailReviewUserId;

    @Expose
    @SerializedName("tr_review")
    private String trReview;

    @Expose
    @SerializedName("tr_rating")
    private float trRating;

    @Expose
    @SerializedName("tr_status")
    private String trStatus;

    @Expose
    @SerializedName("user_first_name")
    private String userFirstName;

    @Expose
    @SerializedName("user_last_name")
    private String userLastName;

    @Expose
    @SerializedName("user_avatar")
    private String userAvatar;

    public TrailReview(int trailID, String trailReview) {
        this.trailID = trailID;
        this.trReview = trailReview;
    }

    protected TrailReview(Parcel in) {
        trId = in.readInt();
        trailID = in.readInt();
        trailReviewUserId = in.readInt();
        trReview = in.readString();
        trRating = in.readFloat();
        trStatus = in.readString();
        userFirstName = in.readString();
        userLastName = in.readString();
        userAvatar = in.readString();
    }

    public int getTrId() {
        return trId;
    }

    public void setTrId(int trId) {
        this.trId = trId;
    }

    public int getTrailID() {
        return trailID;
    }

    public void setTrailID(int trailID) {
        this.trailID = trailID;
    }

    public int getTrailReviewUserId() {
        return trailReviewUserId;
    }

    public void setTrailReviewUserId(int trailReviewUserId) {
        this.trailReviewUserId = trailReviewUserId;
    }

    public String getTrReview() {
        return trReview;
    }

    public void setTrReview(String trReview) {
        this.trReview = trReview;
    }

    public float getTrRating() {
        return trRating;
    }

    public void setTrRating(float trRating) {
        this.trRating = trRating;
    }

    public String getTrStatus() {
        return trStatus;
    }

    public void setTrStatus(String trStatus) {
        this.trStatus = trStatus;
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

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(trId);
        dest.writeInt(trailID);
        dest.writeInt(trailReviewUserId);
        dest.writeString(trReview);
        dest.writeFloat(trRating);
        dest.writeString(trStatus);
        dest.writeString(userFirstName);
        dest.writeString(userLastName);
        dest.writeString(userAvatar);
    }
}
