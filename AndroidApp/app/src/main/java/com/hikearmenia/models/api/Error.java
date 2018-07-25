package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by anikarapetyan1 on 5/16/16.
 */
public class Error implements Serializable, Parcelable {

    public static final Creator<Error> CREATOR = new Creator<Error>() {
        @Override
        public Error createFromParcel(Parcel in) {
            return new Error(in);
        }

        @Override
        public Error[] newArray(int size) {
            return new Error[size];
        }
    };
    @Expose
    @SerializedName("code")
    public int code;
    @Expose
    @SerializedName("message")
    public String message;

    protected Error(Parcel in) {
        code = in.readInt();
        message = in.readString();
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(code);
        dest.writeString(message);
    }
}