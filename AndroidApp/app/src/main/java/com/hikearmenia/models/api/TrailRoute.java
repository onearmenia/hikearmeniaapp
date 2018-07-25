package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by anikarapetyan1 on 5/26/16.
 */
public class TrailRoute implements Serializable, Parcelable {

    public static final Creator<TrailRoute> CREATOR = new Creator<TrailRoute>() {
        @Override
        public TrailRoute createFromParcel(Parcel in) {
            return new TrailRoute(in);
        }

        @Override
        public TrailRoute[] newArray(int size) {
            return new TrailRoute[size];
        }
    };
    @Expose
    @SerializedName("latitude")
    private double latitude;
    @Expose
    @SerializedName("longitude")
    private double longitude;

    public TrailRoute(Parcel in) {
        latitude = in.readFloat();
        longitude = in.readFloat();
    }

    public TrailRoute(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeFloat((float) latitude);
        dest.writeFloat((float) longitude);
    }

    @Override
    public String toString() {
        return "TrailRoute{" +
                "latitude=" + latitude +
                ", longitude=" + longitude +
                '}';
    }
}
