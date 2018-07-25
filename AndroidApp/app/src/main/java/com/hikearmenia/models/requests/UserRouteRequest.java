package com.hikearmenia.models.requests;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import com.hikearmenia.models.api.TrailRoute;

import java.util.List;


public class UserRouteRequest {


    @Expose
    @SerializedName("location")
    private List<TrailRoute> location;

    public UserRouteRequest(List<TrailRoute> route) {
        this.location = route;
    }

    public List<TrailRoute> getRoute() {
        return location;
    }

    public void setRoute(List<TrailRoute> route) {
        this.location = route;
    }

}
