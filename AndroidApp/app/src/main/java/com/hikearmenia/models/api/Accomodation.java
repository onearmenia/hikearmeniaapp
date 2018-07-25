package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by anikarapetyan1 on 5/16/16.
 */
public class Accomodation implements Serializable, Parcelable {

    public static final Creator<Accomodation> CREATOR = new Creator<Accomodation>() {
        @Override
        public Accomodation createFromParcel(Parcel in) {
            return new Accomodation(in);
        }

        @Override
        public Accomodation[] newArray(int size) {
            return new Accomodation[size];
        }
    };
    @Expose
    @SerializedName("acc_id")
    String accomodationId;

    @Expose
    @SerializedName("acc_name")
    String accomodationName;

    @Expose
    @SerializedName("acc_phone")
    String accomodationPhone;

    @Expose
    @SerializedName("acc_price")
    String accomodationPrice;

    @Expose
    @SerializedName("acc_email")
    String accomodationEmail;

    @Expose
    @SerializedName("acc_description")
    String accomodationDescription;

    @Expose
    @SerializedName("acc_facilities")
    String accomodationFacilities;

    @Expose
    @SerializedName("acc_url")
    String accomodationUrl;

    @Expose
    @SerializedName("acc_status")
    String accomodationStatus;

    @Expose
    @SerializedName("acc_cover")
    String accomodationCover;

    @Expose
    @SerializedName("acc_map_image")
    String accomodatMapImage;

    @Expose
    @SerializedName("acc_lat")
    String accommodationLat;

    @Expose
    @SerializedName("acc_long")
    String accommodationLong;


    protected Accomodation(Parcel in) {
        accomodationId = in.readString();
        accomodationPhone = in.readString();
        accomodationPrice = in.readString();
        accomodationEmail = in.readString();
        accomodationDescription = in.readString();
        accomodationFacilities = in.readString();
        accomodationUrl = in.readString();
        accomodationStatus = in.readString();
        accomodatMapImage = in.readString();
        accommodationLat = in.readString();
        accommodationLong = in.readString();
    }

    public String getAccomodationName() {
        return accomodationName;
    }

    public String getAccomodationCover() {
        return accomodationCover;
    }

    public String getAccomodationId() {
        return accomodationId;
    }

    public String getAccomodationPhone() {
        return accomodationPhone;
    }

    public String getAccomodationPrice() {
        return accomodationPrice;
    }

    public String getAccomodationEmail() {
        return accomodationEmail;
    }

    public String getAccomodationDescription() {
        return accomodationDescription;
    }

    public String getAccomodationFacilities() {
        return accomodationFacilities;
    }

    public String getAccomodationUrl() {
        return accomodationUrl;
    }

    public String getAccomodationStatus() {
        return accomodationStatus;
    }

    public String getAccomodatMapImage() {
        return accomodatMapImage;
    }

    public String getAccommodationLat() {
        return accommodationLat;
    }

    public String getAccommodationLong() {
        return accommodationLong;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(accomodationId);
        dest.writeString(accomodationPhone);
        dest.writeString(accomodationPrice);
        dest.writeString(accomodationEmail);
        dest.writeString(accomodationDescription);
        dest.writeString(accomodationFacilities);
        dest.writeString(accomodationUrl);
        dest.writeString(accomodationStatus);
        dest.writeString(accomodatMapImage);
        dest.writeString(accommodationLat);
        dest.writeString(accommodationLong);
    }
}
