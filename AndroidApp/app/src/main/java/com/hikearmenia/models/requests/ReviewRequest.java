package com.hikearmenia.models.requests;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by jr on 5/18/16.
 */
public class ReviewRequest implements Serializable {

    @Expose
    @SerializedName("review")
    private String review;

    @Expose
    @SerializedName("rating")
    private String rating;

    public ReviewRequest(String review, String rating) {
        this.review = review;
        this.rating = rating;
    }
}
