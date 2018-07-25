package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by jr on 5/4/16.
 */
public class Response<T> implements Serializable, Parcelable {

    public static final Creator<Response> CREATOR = new Creator<Response>() {
        @Override
        public Response createFromParcel(Parcel in) {
            return new Response(in);
        }

        @Override
        public Response[] newArray(int size) {
            return new Response[size];
        }
    };
    @Expose
    @SerializedName("result")
    public T result;
    @Expose
    @SerializedName("error")
    public Error error;

    public Response(Parcel in) {
        result = (T) in.readValue(getClass().getClassLoader());
    }

    public T getResult() {
        return result;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeValue(result);
    }
}
