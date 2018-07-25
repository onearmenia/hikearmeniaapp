package com.hikearmenia.models.api;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by jr on 5/4/16.
 */
public class Trail implements Serializable, Parcelable {
    public static final Creator<Trail> CREATOR = new Creator<Trail>() {
        @Override
        public Trail createFromParcel(Parcel in) {
            return new Trail(in);
        }

        @Override
        public Trail[] newArray(int size) {
            return new Trail[size];
        }
    };
    @Expose
    @SerializedName("trail_id")
    private int trailId;

    @Expose
    @SerializedName("trail_name")
    private String trailName;

    @Expose
    @SerializedName("trail_difficulty")
    private String trailDifficulty;

    @Expose
    @SerializedName("trail_things_to_do")
    private String trailThingsToDo;
    @Expose
    @SerializedName("trail_information")
    private String trailInformation;
    @Expose
    @SerializedName("trail_location_start")
    private String trailLocationStart;

    @Expose
    @SerializedName("trail_location_end")
    private String trailLocationEnd;

    @Expose
    @SerializedName("trail_distance")
    private String trailDistance;

    @Expose
    @SerializedName("trail_max_height")
    private String trailMaxHeight;

    @Expose
    @SerializedName("trail_min_height")
    private String trailMinHeight;

    @Expose
    @SerializedName("trail_time")
    private String trailTime;
    @Expose
    @SerializedName("trail_cover")
    private String trailCover;
    @Expose
    @SerializedName("trail_status")
    private String trailStatus;

    @Expose
    @SerializedName("is_saved")
    private int isSaved;

    @Expose
    @SerializedName("average_rating")
    private String averageRating;
    @Expose
    @SerializedName("review_count")
    private String reviewCount;
    @Expose
    @SerializedName("guides")
    private List<Guide> guides;
    @Expose
    @SerializedName("guide_count")
    private String guideCount;

    @Expose
    @SerializedName("accommodations")
    private List<Accomodation> accomodations;

    @Expose
    @SerializedName("trail_covers")
    private ArrayList<String> trailCovers;

    @Expose
    @SerializedName("reviews")
    private ArrayList<TrailReview> reviews;

    @Expose
    @SerializedName("trail_lat_start")
    private String latitudeStart;
    @Expose
    @SerializedName("trail_lat_end")
    private String latitudeEnd;

    @Expose
    @SerializedName("trail_long_start")
    private String longitudeStart;

    @Expose
    @SerializedName("trail_long_end")
    private String longitudeEnd;

    @Expose
    @SerializedName("trail_route")
    private List<TrailRoute> trailRoute;

    @Expose
    @SerializedName("weather")
    private Weather weather;

    @Expose
    @SerializedName("trail_map_image")
    private String mapUrl;


    public Trail(Parcel in) {
        trailId = in.readInt();
        trailName = in.readString();
        trailDifficulty = in.readString();
        trailThingsToDo = in.readString();
        trailInformation = in.readString();
        trailLocationStart = in.readString();
        trailLocationEnd = in.readString();
        trailDistance = in.readString();
        trailMaxHeight = in.readString();
        trailMinHeight = in.readString();
        trailTime = in.readString();
        trailCover = in.readString();
        trailStatus = in.readString();
        isSaved = in.readInt();
        averageRating = in.readString();
        reviewCount = in.readString();
        guideCount = in.readString();
        mapUrl = in.readString();
        guides = new ArrayList<>();
        in.readList(guides, getClass().getClassLoader());
        accomodations = new ArrayList<>();
        in.readList(accomodations, getClass().getClassLoader());
        trailCovers = in.readArrayList(getClass().getClassLoader());
        reviews = in.readArrayList(getClass().getClassLoader());
        weather = (Weather) in.readValue(getClass().getClassLoader());
        latitudeStart = in.readString();
        latitudeEnd = in.readString();

        longitudeStart = in.readString();
        longitudeEnd = in.readString();
        trailRoute = in.createTypedArrayList(TrailRoute.CREATOR);

    }

    public ArrayList<String> getTrailCovers() {
        return trailCovers;
    }

    public List<Guide> getGuides() {
        return guides;
    }

    public List<Accomodation> getAccomodations() {
        return accomodations;
    }

    public int getTrailId() {
        return trailId;
    }

    public void setTrailId(int trailId) {
        this.trailId = trailId;
    }

    public String getTrailName() {
        return trailName;
    }

    public void setTrailName(String trailName) {
        this.trailName = trailName;
    }

    public String getTrailDifficulty() {
        return trailDifficulty;
    }

    public void setTrailDifficulty(String trailDifficulty) {
        this.trailDifficulty = trailDifficulty;
    }

    public String getTrailThingsToDo() {
        return trailThingsToDo;
    }

    public void setTrailThingsToDo(String trailThingsToDo) {
        this.trailThingsToDo = trailThingsToDo;
    }

    public String getTrailInformation() {
        return trailInformation;
    }

    public void setTrailInformation(String trailInformation) {
        this.trailInformation = trailInformation;
    }

    public String getTrailLocationStart() {
        return trailLocationStart;
    }

    public void setTrailLocationStart(String trailLocationStart) {
        this.trailLocationStart = trailLocationStart;
    }

    public String getWeather() {
        if (weather != null) {
            return weather.getTemperature();
        }
        return null;
    }

    public String getweatherImageIcon() {
        if (weather != null) {
            return weather.getWeatherIcon();
        }
        return null;
    }

    public float getLatitudeEnd() {
        float value;
        try {
            value = Float.parseFloat(latitudeEnd);
        } catch (Exception e) {
            value = 0f;
        }
        return value;
    }

    public float getLongitudeStart() {
        float value;
        try {
            value = Float.parseFloat(longitudeStart);
        } catch (Exception e) {
            value = 0f;
        }
        return value;
    }

    public float getLatitudeStart() {
        float value;
        try {
            value = Float.parseFloat(latitudeStart);
        } catch (Exception e) {
            value = 0f;
        }
        return value;
    }

    public float getLongitudeEnd() {
        float value;
        try {
            value = Float.parseFloat(longitudeEnd);
        } catch (Exception e) {
            value = 0f;
        }
        return value;
    }

    public String getTrailLocationEnd() {
        return trailLocationEnd;
    }

    public void setTrailLocationEnd(String trailLocationEnd) {
        this.trailLocationEnd = trailLocationEnd;
    }

    public List<TrailRoute> getTrailRoute() {
        return trailRoute;
    }

    public String getTrailDistance() {
        return trailDistance;
    }

    public void setTrailDistance(String trailDistance) {
        this.trailDistance = trailDistance;
    }

    public String getTrailMaxHeight() {
        return trailMaxHeight;
    }

    public String getTrailMinHeight() {
        return trailMinHeight;
    }

    public String getTrailTime() {
        return trailTime;
    }

    public void setTrailTime(String trailTime) {
        this.trailTime = trailTime;
    }

    public String getTrailCover() {
        return trailCover;
    }

    public void setTrailCover(String trailCover) {
        this.trailCover = trailCover;
    }

    public String getTrailStatus() {
        return trailStatus;
    }

    public void setTrailStatus(String trailStatus) {
        this.trailStatus = trailStatus;
    }

    public String getMapUrl() {
        return mapUrl;
    }

    public boolean isSaved() {
        return isSaved > 0;
    }

    public void setIsSaved(boolean isSaved) {
        this.isSaved = 0;
        if (isSaved) {
            this.isSaved = 1;
        }
    }

    public int getAverageRating() {
        if (averageRating != null && !averageRating.isEmpty()) {
            return (int) (Float.parseFloat(averageRating));
        }
        return 0;
    }

    public void setAverageRating(int averageRating) {
        this.averageRating = String.valueOf(averageRating);
    }

    public int getGuideCount() {
        return Integer.valueOf(guideCount);
    }

    public int getReviewCount() {
        return Integer.valueOf(reviewCount);
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = String.valueOf(reviewCount);
    }

    public ArrayList<TrailReview> getReviews() {
        return reviews;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(trailId);
        dest.writeString(trailName);
        dest.writeString(trailDifficulty);
        dest.writeString(trailThingsToDo);
        dest.writeString(trailInformation);
        dest.writeString(trailLocationStart);
        dest.writeString(trailLocationEnd);
        dest.writeString(trailDistance);
        dest.writeString(trailMaxHeight);
        dest.writeString(trailMinHeight);
        dest.writeString(trailTime);
        dest.writeString(trailCover);
        dest.writeString(trailStatus);
        dest.writeInt(isSaved);
        dest.writeString(averageRating);
        dest.writeString(reviewCount);
        dest.writeString(guideCount);
        dest.writeString(mapUrl);
        dest.writeTypedList(accomodations);
        dest.writeValue(trailCovers);
        dest.writeValue(reviews);
        dest.writeValue(weather);

        dest.writeString(latitudeStart);
        dest.writeString(latitudeEnd);
        dest.writeString(longitudeStart);
        dest.writeString(longitudeEnd);
        dest.writeTypedList(trailRoute);
    }
}
