package com.hikearmenia.activities;

import android.Manifest;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hikearmenia.R;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.YoYo;
import com.hikearmenia.views.TakePhotoView;
import com.nineoldandroids.animation.Animator;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

public class TakePhotoActivity extends Activity implements View.OnTouchListener{
    Uri mCapturedImageURI;
    Bitmap logoBitmap;
    Bitmap imageBitmap;
    TakePhotoView photoView;
    private boolean isSaved;
    private final int MY_PERMISSIONS_REQUEST_CAMERA = 18223;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_take_photo);
        if (Build.VERSION.SDK_INT >= 23) {
            sendPermissionRequest();

        } else {
            takePhoto();
        }
        ImageView shareIcon = (ImageView) findViewById(R.id.share_photo);
        TextView close = (TextView) findViewById(R.id.close_fragment);
        shareIcon.setOnTouchListener(this);
        close.setOnTouchListener(this);

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {

            if (requestCode == ResultCodes.REQUEST_IMAGE_CAPTURE) {
                String[] projection = {MediaStore.Images.Media.DATA};
                Cursor cursor = managedQuery(mCapturedImageURI, projection, null, null, null);
                int column_index_data = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                String capturedImageFilePath = cursor.getString(column_index_data);

                imageBitmap = BitmapFactory.decodeFile(capturedImageFilePath);
                logoBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.logo);
                photoView = (TakePhotoView) findViewById(R.id.take_photo_view);

                photoView.setLogo(logoBitmap);
                photoView.setBg(imageBitmap);
                photoView.invalidate();
            }
        } else {
            finish();
        }
    }

    @Override
    public boolean onTouch(final View view, MotionEvent motionEvent) {
        switch (view.getId()) {
            case R.id.share_photo:
//                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
//                    @Override
//                    public void call(Animator animator) {
                        Intent shareIntent = new Intent(Intent.ACTION_SEND);
                        shareIntent.setType("image/*");
                        shareIntent.putExtra(Intent.EXTRA_STREAM, getBitmap());
                        isSaved = true;
                        startActivity(Intent.createChooser(shareIntent, getResources().getString(R.string.com_facebook_share_button_text)));
//                    }
//                }).playOn(view, STANDART_DURETION);
                break;
            case R.id.close_fragment:
//                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
//                    @Override
//                    public void call(Animator animator) {
                        finish();
//                    }
//                }).playOn(view, STANDART_DURETION);
                break;
        }
        return false;

    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        finish();
    }

    private void takePhoto() {
            Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
            String fileName = "temp.jpg";
            ContentValues values = new ContentValues();
            values.put(MediaStore.Images.Media.TITLE, fileName);
            mCapturedImageURI = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
            cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, mCapturedImageURI);
            startActivityForResult(cameraIntent, ResultCodes.REQUEST_IMAGE_CAPTURE);
    }

    private String getPath(Uri uri) {
        String[] projection = {MediaStore.Images.Media.DATA};
        Cursor cursor = managedQuery(uri, projection, null, null, null);
        if (cursor != null) {
            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            return cursor.getString(column_index);
        } else return null;
    }

    private Uri getImageUri(Bitmap bitmap) {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
        return Uri.parse(MediaStore.Images.Media.insertImage(this.getContentResolver(), bitmap, "Title", null));
    }

    private Uri getBitmap() {
        if (photoView != null) {
            return getImageUri(photoView.asBitmap());
        } else {
            return null;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (!isSaved) {
            getBitmap();
        }
        File file = new File(getPath(mCapturedImageURI));
        if (file.exists()) {
            file.delete();
        }
    }

    private void sendPermissionRequest() {
        int result = ContextCompat.checkSelfPermission(TakePhotoActivity.this, Manifest.permission.CAMERA);
        if (result != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(TakePhotoActivity.this,
                    new String[]{Manifest.permission.CAMERA},
                    MY_PERMISSIONS_REQUEST_CAMERA);
        } else {
            takePhoto();
        }
    }
    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_CAMERA: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    takePhoto();

                } else {
                    finish();
                }
            }
        }
    }

    public static Bitmap decodeSampledBitmapFromUri (String path, int reqWidth,
                                                     int reqHeight) {

        Bitmap bm = null;
        // First decode with inJustDecodeBounds=true to check dimensions
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(path, options);

        // Calculate inSampleSize
        options.inSampleSize = calculateInSampleSize(options, reqWidth,
                reqHeight);

        // Decode bitmap with inSampleSize set
        options.inJustDecodeBounds = false;
        bm = BitmapFactory.decodeFile(path, options);

        if (bm == null) {
            return bm;
        }
        if (bm.getWidth() < 0 || bm.getHeight() < 0) {
            return null;
        }
        ExifInterface exif = null;
        try {
            exif = new ExifInterface(path);
        } catch (IOException e) {
            e.printStackTrace();
        }
        int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_UNDEFINED);

        Matrix matrix = new Matrix();
        Bitmap newBtm = null;
        if (bm.getHeight() < 0 || bm.getWidth() < 0) {
            return null;
        }
        switch (orientation) {
            case ExifInterface.ORIENTATION_ROTATE_90:
                matrix.postRotate(90);
                newBtm = Bitmap.createBitmap(bm, 0, 0, reqHeight, reqWidth, matrix, true);
                bm.recycle();
                return newBtm;
            case ExifInterface.ORIENTATION_ROTATE_180:
                matrix.postRotate(180);
                newBtm = Bitmap.createBitmap(bm, 0, 0, reqWidth, reqHeight, matrix, true);
                bm.recycle();
                return newBtm;
            case ExifInterface.ORIENTATION_ROTATE_270:
                matrix.postRotate(270);
                newBtm = Bitmap.createBitmap(bm, 0, 0, reqHeight, reqWidth, matrix, true);
                bm.recycle();
                return newBtm;
            default:
                break;
        }


        //bm.recycle();
        return bm;
    }


    public static int calculateInSampleSize(

            BitmapFactory.Options options, int reqWidth, int reqHeight) {
        // Raw height and width of image
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {
            if (width > height) {
                inSampleSize = Math.round((float) height
                        / (float) reqHeight);
            } else {
                inSampleSize = Math.round((float) width / (float) reqWidth);
            }
        }

        return inSampleSize;
    }

}

