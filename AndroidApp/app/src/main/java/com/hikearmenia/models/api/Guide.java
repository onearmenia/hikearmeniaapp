package com.hikearmenia.models.api;

import android.annotation.TargetApi;
import android.os.Build;
import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

/**
 * Created by jr on 5/12/16.
 */
public class Guide implements Serializable, Parcelable {

    public static final Creator<Guide> CREATOR = new Creator<Guide>() {
        @Override
        public Guide createFromParcel(Parcel in) {
            return new Guide(in);
        }

        @Override
        public Guide[] newArray(int size) {
            return new Guide[size];
        }
    };
    @Expose
    @SerializedName("guide_id")
    private int guideId;
    @Expose
    @SerializedName("guide_first_name")
    private String guideFirstname;
    @Expose
    @SerializedName("guide_last_name")
    private String guideLastName;
    @Expose
    @SerializedName("guide_phone")
    private String guidePhone;
    @Expose
    @SerializedName("guide_email")
    private String guideEmail;
    @Expose
    @SerializedName("guide_image")
    private String guideImage;
    @Expose
    @SerializedName("guide_status")
    private String guideStatus;
    @Expose
    @SerializedName("average_rating")
    private String averageRating;
    @Expose
    @SerializedName("guide_description")
    private String description;
    @Expose
    @SerializedName("review_count")
    private String reviewCount;
    @Expose
    @SerializedName("reviews")
    private List<GuideReview> guideReviews;
    @Expose
    @SerializedName("languages")
    private List<Language> guideLanguage;

    protected Guide(Parcel in) {
        guideId = in.readInt();
        guideFirstname = in.readString();
        guideLastName = in.readString();
        guidePhone = in.readString();
        guideEmail = in.readString();
        guideImage = in.readString();
        guideStatus = in.readString();
        averageRating = in.readString();
        description = in.readString();
        reviewCount = in.readString();
        guideReviews = in.readArrayList(getClass().getClassLoader());
        guideLanguage = in.readArrayList(getClass().getClassLoader());
    }

    public int getGuideId() {
        return guideId;
    }

    public void setGuideId(int guideId) {
        this.guideId = guideId;
    }

    public String getGuideFirstname() {
        return guideFirstname;
    }

    public void setGuideFirstname(String guideFirstname) {
        this.guideFirstname = guideFirstname;
    }

    public String getGuideLastName() {
        return guideLastName;
    }

    public void setGuideLastName(String guideLastName) {
        this.guideLastName = guideLastName;
    }

    public String getGuidePhone() {
        return guidePhone;
    }

    public void setGuidePhone(String guidePhone) {
        this.guidePhone = guidePhone;
    }

    public String getGuideEmail() {
        return guideEmail;
    }

    public void setGuideEmail(String guideEmail) {
        this.guideEmail = guideEmail;
    }

    public String getGuideImage() {
        return guideImage;
    }

    public void setGuideImage(String guideImage) {
        this.guideImage = guideImage;
    }

    public String getGuideStatus() {
        return guideStatus;
    }

    public void setGuideStatus(String guideStatus) {
        this.guideStatus = guideStatus;
    }

    public String getDescription() {
        return description;
    }

    public int getAverageRating() {
        if (averageRating != null && !averageRating.isEmpty()) {
            return (int) (Float.parseFloat(averageRating));
        }
        return 0;
    }

    public int getReviewCount() {
        return Integer.valueOf(reviewCount);
    }

    public List<GuideReview> getGuideReviews() {
        return guideReviews;
    }

    public List<Language> getGuideLanguage() {
        return guideLanguage;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(guideId);
        dest.writeString(guideFirstname);
        dest.writeString(guideLastName);
        dest.writeString(guidePhone);
        dest.writeString(guideEmail);
        dest.writeString(guideImage);
        dest.writeString(guideStatus);
        dest.writeString(averageRating);
        dest.writeString(description);
        dest.writeString(reviewCount);
        dest.writeList(guideReviews);
    }
}
