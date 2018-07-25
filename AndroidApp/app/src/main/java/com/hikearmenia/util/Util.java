package com.hikearmenia.util;

import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.provider.MediaStore;
import android.util.Patterns;
import android.view.Display;

import com.hikearmenia.R;
import com.hikearmenia.activities.BaseActivity;
import com.hikearmenia.constants.ResultCodes;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Created by Martha on 4/8/2016.
 */
public class Util {

    public static void writeToInternalFile(String content, String fileName, Context context) {
        try {
            FileOutputStream fileOutputStream = context.openFileOutput(fileName, Context.MODE_PRIVATE);
            fileOutputStream.write(content.getBytes());
            fileOutputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String readFromInternalFile(String fileName, Context context) {
        try {
            FileInputStream fileInputStream = context.openFileInput(fileName);
            InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream);
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            StringBuilder stringBuilder = new StringBuilder();
            String tempLine;
            while ((tempLine = bufferedReader.readLine()) != null) {
                stringBuilder.append(tempLine);
            }
            return stringBuilder.toString();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean isFileExist(String url, Context context) {
        File file = context.getFileStreamPath(url);
        if (file == null || !file.exists()) {
            return false;
        } else return true;

    }

    public static boolean isEmailValid(String email) {
        return email != null && Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }

    public static boolean isPasswordValid(String password) {
        return password != null && !password.isEmpty();
    }

    public static int getDisplayHeight(BaseActivity context) {

        Point size = new Point();
        Display display = context.getWindowManager().getDefaultDisplay();
        display.getRealSize(size);
        int height = size.y;
        return height;
    }

    public static int getDisplayWidth(BaseActivity context) {

        Point size = new Point();
        Display display = context.getWindowManager().getDefaultDisplay();
        display.getRealSize(size);
        int width = size.x;
        return width;
    }

    public static String setNumberFormat(String i) {
        return NumberFormat.getNumberInstance(Locale.US).format(Integer.valueOf(i)) + " m";
    }

    public static int dpToPx(final Context context, final float dp) {
        float density = 1.5f;

        if (context != null) {
            density = context.getResources().getDisplayMetrics().density;
        }
        return (int) (density * dp + 0.5f);
    }

    public static boolean isNetworkAvailable(Context context, boolean show) {

        ConnectivityManager connectivityManager
                = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        if (activeNetworkInfo == null || !activeNetworkInfo.isConnected() && show) {
            if (show) {
                UIUtil.alertDialogShow(context, context.getString(R.string.error_dialog), context.getString(R.string.please_check_your_network_connectivity));
            }
            return false;
        }
        return true;
    }

    public static void dispatchTakePictureIntent(BaseActivity context) {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(context.getPackageManager()) != null) {
            context.setResult(ResultCodes.REQUEST_IMAGE_CAPTURE);
            context.startActivityForResult(takePictureIntent, ResultCodes.REQUEST_IMAGE_CAPTURE);
        }
    }
}
