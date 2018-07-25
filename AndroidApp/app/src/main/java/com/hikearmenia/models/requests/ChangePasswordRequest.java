package com.hikearmenia.models.requests;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

/**
 * Created by Martha on 4/11/2016.
 */
public class ChangePasswordRequest {

    @Expose
    @SerializedName("old_password")
    private String oldPassword;

    @Expose
    @SerializedName("new_password")
    private String newPassword;

    public ChangePasswordRequest() {
    }

    public ChangePasswordRequest(String old_password, String new_password) {
        this.oldPassword = old_password;
        this.newPassword = new_password;
    }

}
