package com.hikearmenia.util;

import android.content.SharedPreferences;

import com.google.gson.Gson;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.models.api.Trail;

import java.util.ArrayList;

import static android.content.Context.MODE_PRIVATE;

/**
 * Created by Astghik on 8/16/16.
 */

public class SharedPreferencesData {

    private static SharedPreferencesData obj;
    private static ArrayList<String> selectionIdList;

    private SharedPreferencesData() {

    }

    public static SharedPreferencesData getInstance() {
        if (obj == null) {
            obj = new SharedPreferencesData();
        }

        return obj;
    }

    public void storeSelectionIdList(String selectionId, BaseActivity activity) {
        boolean isNewTrail = true;
        selectionIdList = getSelectionIdList(activity);
        if (selectionIdList == null) {
            selectionIdList = new ArrayList<>();

        } else {
            for (int i = 0; i < selectionIdList.size(); i++) {
                if (selectionIdList.get(i).equals(selectionId)) {
                    isNewTrail = false;
                }
            }
        }
        if (isNewTrail) {
            selectionIdList.add(selectionId);

            SharedPreferences mPrefs = activity.getSharedPreferences("Preferences", MODE_PRIVATE);
            SharedPreferences.Editor prefsEditor;
            prefsEditor = mPrefs.edit();
            Gson gson = new Gson();
            String json = gson.toJson(selectionIdList);
            prefsEditor.putString("selectionIdList", json);
            prefsEditor.commit();
        }

    }

    public void storeSelectionIdList(ArrayList mSelectionIdList, BaseActivity activity) {
        SharedPreferences mPrefs = activity.getSharedPreferences("Preferences", MODE_PRIVATE);
        SharedPreferences.Editor prefsEditor;
        prefsEditor = mPrefs.edit();
        Gson gson = new Gson();
        String json = gson.toJson(mSelectionIdList);
        prefsEditor.putString("selectionIdList", json);
        prefsEditor.commit();

    }

    public ArrayList<String> getSelectionIdList(BaseActivity activity) {
        SharedPreferences mPrefs = activity.getSharedPreferences("Preferences", MODE_PRIVATE);
        Gson gson = new Gson();
        String json = mPrefs.getString("selectionIdList", "");
        ArrayList<String> obj = gson.fromJson(json, ArrayList.class);
        return obj;
    }

    public void storeSelection(Trail selection, BaseActivity activity) {

        SharedPreferences mPrefs = activity.getSharedPreferences("Preferences", MODE_PRIVATE);
        SharedPreferences.Editor prefsEditor;
        prefsEditor = mPrefs.edit();
        Gson gson = new Gson();
        String json = gson.toJson(selection);
        prefsEditor.putString(String.valueOf(selection.getTrailId()), json);
        prefsEditor.commit();
    }

    public Trail getSelection(BaseActivity activity, String selectionId) {
        SharedPreferences mPrefs = activity.getSharedPreferences("Preferences", MODE_PRIVATE);
        Gson gson = new Gson();
        String json = mPrefs.getString(selectionId, "");
        Trail obj = gson.fromJson(json, Trail.class);
        return obj;
    }

    public void removeSelection(BaseActivity activity, String selectionId) {
        selectionIdList = getSelectionIdList(activity);
        if (selectionIdList != null) {
            for (int i = 0; i < selectionIdList.size(); i++) {
                if (selectionIdList.get(i).equals(selectionId)) {
                    selectionIdList.remove(i);
                    removeSelectionById(activity, selectionId);
                    storeSelectionIdList(selectionIdList, activity);
                }
            }

        }
    }

    private void removeSelectionById(BaseActivity activity, String id) {
        SharedPreferences mySPrefs = activity.getSharedPreferences("Preferences", MODE_PRIVATE);
        SharedPreferences.Editor editor = mySPrefs.edit();
        editor.remove(id);
        editor.apply();
    }

}
