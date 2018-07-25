package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by Astghik on 16.06.2016.
 */
public class Weather implements Serializable, Parcelable {
    public static final Creator<Weather> CREATOR = new Creator<Weather>() {
        @Override
        public Weather createFromParcel(Parcel in) {
            return new Weather(in);
        }

        @Override
        public Weather[] newArray(int size) {
            return new Weather[size];
        }
    };
    @Expose
    @SerializedName("weather_temperature")
    private String temperature;
    @Expose
    @SerializedName("weather_icon")
    private String weatherIcon;

    protected Weather(Parcel in) {
        temperature = in.readString();
        weatherIcon = in.readString();
    }

    public String getTemperature() {
        return temperature;
    }

    public String getWeatherIcon() {
        return weatherIcon;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(temperature);
    }
}
