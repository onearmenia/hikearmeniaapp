package com.hikearmenia.util;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.provider.Settings;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;

import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.dialogs.CustomAlertDialog;

import java.io.IOException;

/**
 * Created by anikarapetyan1 on 5/11/16.
 */
public class UIUtil {

    public static void alertDialogShow(Context context, String title, String message) {
        CustomAlertDialog customAlertDialog = new CustomAlertDialog((BaseActivity) context, title, message);
        customAlertDialog.show();
    }

    public static void alertDialogShow(Context context, String title, String message, CustomAlertDialog.Callback callback) {
        CustomAlertDialog customAlertDialog = new CustomAlertDialog((BaseActivity) context, title, message, callback);
        customAlertDialog.show();
    }

    public static CustomAlertDialog routeAccesDialog(Context context, String title, String message, boolean visible) {

        CustomAlertDialog customAlertDialog = new CustomAlertDialog((BaseActivity) context, title, message, visible);
        customAlertDialog.show();
        return customAlertDialog;
    }

    public static void showProgressDialog(Context context) {
        ProgressFragment.newInstance().show(((BaseActivity) context).getSupportFragmentManager(), "FTAG_PROGRESS");
    }

    public static void hideProgressDialog(Context context) {
        ProgressFragment fragment = (ProgressFragment) ((FragmentActivity) context).getSupportFragmentManager().findFragmentByTag("FTAG_PROGRESS");
        if (fragment != null) {
            fragment.dismissAllowingStateLoss();
        }
    }

    public static Bitmap getRotatedBitmap(String path) {
        BitmapFactory.Options o = new BitmapFactory.Options();
        o.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(path, o);
        int scale = 1;
        Bitmap b = null;
        o = new BitmapFactory.Options();
        b = BitmapFactory.decodeFile(path, o);
        ExifInterface exif = null;
        try {
            Bitmap bitmap;
            exif = new ExifInterface(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_UNDEFINED);
        Bitmap newBtm = null;
        Matrix m = new Matrix();
        switch (orientation) {
            case ExifInterface.ORIENTATION_ROTATE_90:
                m.postRotate(90);
                newBtm = Bitmap.createBitmap(b, 0, 0, b.getWidth(), b.getHeight(), m, true);
                b.recycle();
                return newBtm;
            case ExifInterface.ORIENTATION_ROTATE_180:
                m.postRotate(180);
                newBtm = Bitmap.createBitmap(b, 0, 0, b.getWidth(), b.getHeight(), m, true);
                b.recycle();
                return newBtm;
            case ExifInterface.ORIENTATION_ROTATE_270:
                m.postRotate(270);
                newBtm = Bitmap.createBitmap(b, 0, 0, b.getWidth(), b.getHeight(), m, true);
                b.recycle();
                return newBtm;
            default:
                break;
        }

        return b;
    }

    public static void scaleView(View v, float startScale, float endScale) {
        Animation anim = new ScaleAnimation(
                0f, 0f, // Start and end values for the X axis scaling
                startScale, endScale, // Start and end values for the Y axis scaling
                Animation.RELATIVE_TO_SELF, 0f, // Pivot point of X scaling
                Animation.RELATIVE_TO_SELF, 1f); // Pivot point of Y scaling
        anim.setFillAfter(true); // Needed to keep the result of the animation
        Animation animOut = new ScaleAnimation(
                1f, 1f, // Start and end values for the X axis scaling
                startScale, endScale, // Start and end values for the Y axis scaling
                Animation.RELATIVE_TO_SELF, 0f, // Pivot point of X scaling
                Animation.RELATIVE_TO_SELF, 0f); // Pivot point of Y scaling
        animOut.setFillAfter(true); // Needed to keep the result of the animation
        animOut.setDuration(1000);

        v.startAnimation(anim);
        v.startAnimation(animOut);
    }

    public static void showLocationSettingsAlert(final Context context) {

        android.app.AlertDialog.Builder alertDialog = new android.app.AlertDialog.Builder(context);

        // Setting Dialog Title
        alertDialog.setTitle("GPS is settings");

        // Setting Dialog Message
        alertDialog.setMessage("GPS is not enabled. Do you want to go to settings menu?");

        alertDialog.setPositiveButton("Settings", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                context.startActivity(intent);
            }
        });

        alertDialog.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.cancel();
            }
        });

        alertDialog.show();
    }
}


