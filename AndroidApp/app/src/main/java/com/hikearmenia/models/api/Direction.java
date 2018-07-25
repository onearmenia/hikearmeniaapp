package com.hikearmenia.models.api;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Created by anikarapetyan1 on 5/25/16.
 */
public class Direction implements Serializable {

    String mTrailName;

    @Expose
    @SerializedName("trail_lat_start")
    private float latitudeStart;

    @Expose
    @SerializedName("trail_lat_end")
    private float latitudeEnd;

    @Expose
    @SerializedName("trail_long_start")
    private float longitudeStart;

    @Expose
    @SerializedName("trail_long_end")
    private float longitudeEnd;

    public Direction(String trailName, float latS, float latE, float longS, float longE) {
        latitudeStart = latS;
        latitudeEnd = latE;

        longitudeStart = longS;
        longitudeEnd = longE;
        mTrailName = trailName;
    }

    public float getLongitudeEnd() {
        return longitudeEnd;
    }

    public float getLongitudeStart() {
        return longitudeStart;
    }

    public float getLatitudeEnd() {
        return latitudeEnd;
    }

    public float getLatitudeStart() {
        return latitudeStart;
    }

    public String getmTrailName() {
        return mTrailName;
    }
}
