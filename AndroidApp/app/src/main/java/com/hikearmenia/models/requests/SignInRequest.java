package com.hikearmenia.models.requests;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

/**
 * Created by Martha on 4/10/2016.
 */
public class SignInRequest {


    @Expose
    @SerializedName("email")
    private String email;

    @Expose
    @SerializedName("password")
    private String password;

    @Expose
    @SerializedName("udid")
    private String udid;

    @Expose
    @SerializedName("fb_token")
    private String fb_token;

    @Expose
    @SerializedName("first_name")
    private String first_name;

    @Expose
    @SerializedName("last_name")
    private String last_name;

    @Expose
    @SerializedName("avatar")
    private String avatar;

    @Expose
    @SerializedName("phone")
    private String phone;

    public SignInRequest() {
    }

    public SignInRequest(String email, String password, String udid) {
        this.email = email;
        this.password = password;
        this.udid = udid;
    }

    public SignInRequest(String fb_token, String udid) {
        this.fb_token = fb_token;
        this.udid = udid;
    }

    public SignInRequest(String first_name, String last_name, String avatar, String phone, String email) {
        this.first_name = first_name;
        this.last_name = last_name;
        this.avatar = avatar;
        this.phone = phone;
        this.email = email;
    }

    public SignInRequest(String firstName, String lastName, String phone, String email) {
        this.first_name = firstName;
        this.last_name = lastName;
        this.email = email;
        this.phone = phone;
    }

}
