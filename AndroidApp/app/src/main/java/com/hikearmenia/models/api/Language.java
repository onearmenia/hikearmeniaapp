package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by anikarapetyan on 6/2/16.
 */
public class Language implements Serializable, Parcelable {
    public static final Creator<Language> CREATOR = new Creator<Language>() {
        @Override
        public Language createFromParcel(Parcel in) {
            return new Language(in);
        }

        @Override
        public Language[] newArray(int size) {
            return new Language[size];
        }
    };
    @Expose
    @SerializedName("lang_code")
    private String langCode;
    @Expose
    @SerializedName("lang_img")
    private String langImg;

    protected Language(Parcel in) {
        langCode = in.readString();
        langImg = in.readString();
    }

    public String getLangCode() {
        return langCode;
    }

    public String getLangImg() {
        return langImg;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(langCode);
        dest.writeString(langImg);
    }
}
