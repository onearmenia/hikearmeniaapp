package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by Ani KArapetyan on 4/13/16.
 */

public class User implements Serializable, Parcelable {

    public static final Creator<User> CREATOR = new Creator<User>() {
        @Override
        public User createFromParcel(Parcel in) {
            return new User(in);
        }

        @Override
        public User[] newArray(int size) {
            return new User[size];
        }
    };
    @Expose
    @SerializedName("id")
    private String id;
    @Expose
    @SerializedName("first_name")
    private String first_name;
    @Expose
    @SerializedName("last_name")
    private String last_name;
    @Expose
    @SerializedName("email")
    private String email;
    @Expose
    @SerializedName("phone")
    private String phone;
    @Expose
    @SerializedName("avatar")
    private String avatar;
    @Expose
    @SerializedName("token")
    private String token;
    private boolean isGuest = true;

    public User(boolean isGuest) {
        this.isGuest = isGuest;
    }

    public User(Parcel in) {
        id = in.readString();
        first_name = in.readString();
        last_name = in.readString();
        email = in.readString();
        phone = in.readString();
        avatar = in.readString();
        token = in.readString();
    }

    public String getId() {
        return id;
    }

    public String getFirstName() {
        return first_name;
    }

    public void setFirstName(String firstName) {
        this.first_name = firstName;
    }

    public String getLastName() {
        return last_name;
    }

    public void setLastName(String lastName) {
        this.last_name = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String password) {
        this.phone = password;
    }

    public boolean isGuest() {
        return isGuest;
    }

    public void setIsGuest(boolean isGuest) {
        this.isGuest = isGuest;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String userAvatar) {
        this.avatar = userAvatar;
    }

    public String getToken() {
        return token;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(id);
        dest.writeString(first_name);
        dest.writeString(last_name);
        dest.writeString(email);
        dest.writeString(phone);
        dest.writeString(avatar);
        dest.writeString(token);
        dest.writeByte((byte) (isGuest ? 1 : 0));
    }


    public static class UserResponse implements Serializable, Parcelable {

        public static final Creator<UserResponse> CREATOR = new Creator<UserResponse>() {
            @Override
            public UserResponse createFromParcel(Parcel in) {
                return new UserResponse(in);
            }

            @Override
            public UserResponse[] newArray(int size) {
                return new UserResponse[size];
            }
        };
        @Expose
        @SerializedName("result")
        public User result;
        @Expose
        @SerializedName("error")
        public Error error;

        public UserResponse(Parcel in) {
            result = (User) in.readValue(getClass().getClassLoader());
            error = (Error) in.readValue(getClass().getClassLoader());
        }

        public Error getError() {
            return error;
        }

        public User getResult() {
            return result;
        }

        @Override
        public int describeContents() {
            return 0;
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeValue(result);
            dest.writeValue(error);
        }
    }
}