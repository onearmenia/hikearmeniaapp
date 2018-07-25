package com.hikearmenia.models.requests;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

/**
 * Created by Martha on 4/11/2016.
 */
public class ForgetPasswordRequest {

    @Expose
    @SerializedName("email")
    private String email;

    public ForgetPasswordRequest() {
    }

    public ForgetPasswordRequest(String email) {
        this.email = email;
    }
}
