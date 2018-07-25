package com.hikearmenia.models.requests;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

/**
 * Created by Martha on 4/11/2016.
 */

public class SignUpRequest {
    @Expose
    @SerializedName("first_name")
    private String firstName;

    @Expose
    @SerializedName("last_name")
    private String lastName;

    @Expose
    @SerializedName("email")
    private String email;

    @Expose
    @SerializedName("password")
    private String password;

    @Expose
    @SerializedName("udid")
    private String udid;

    public SignUpRequest() {
    }

    public SignUpRequest(String firstName, String lastName,
                         String email, String password, String udid) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.udid = udid;
    }
}
