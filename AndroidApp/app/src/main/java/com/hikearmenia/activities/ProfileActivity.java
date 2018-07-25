package com.hikearmenia.activities;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.provider.MediaStore;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.Toolbar;
import android.util.Base64;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Toast;

import com.hikearmenia.R;
import com.hikearmenia.app.HikeArmeniaApplication;
import com.hikearmenia.constants.ResultCodes;
import com.hikearmenia.dialogs.CustomAlertDialog;
import com.hikearmenia.imageutils.ImageLoader;
import com.hikearmenia.listener.NetworkRequestListener;
import com.hikearmenia.models.api.User;
import com.hikearmenia.models.requests.SignInRequest;
import com.hikearmenia.ui.widgets.Button;
import com.hikearmenia.ui.widgets.EditText;
import com.hikearmenia.ui.widgets.TextView;
import com.hikearmenia.util.Techniques;
import com.hikearmenia.util.UIUtil;
import com.hikearmenia.util.Util;
import com.hikearmenia.util.YoYo;
import com.nineoldandroids.animation.Animator;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by Martha on 4/10/2016.
 */

public class ProfileActivity extends BaseActivity implements View.OnClickListener, View.OnTouchListener, NetworkRequestListener {

    final int READ_EXTERNAL_STORAGE_CODE = 1;
    final int CAMERA_CODE = 2;
    EditText nameEditText;
    EditText surnameEditText;
    EditText emailEditText;
    EditText phoneEditText;
    TextView deletePhoto;
    Button logoutBtn;
    Button changePasswordBtn;
    com.hikearmenia.ui.widgets.TextView editPhotoTv;
    CircleImageView userPhoto;
    private Uri outputFileUri;
    private String userAvatarx64;
    private String avatar;

    private static List<Intent> addIntentsToList(Context context, List<Intent> list, Intent intent) {
        List<ResolveInfo> resInfo = context.getPackageManager().queryIntentActivities(intent, 0);
        for (ResolveInfo resolveInfo : resInfo) {
            String packageName = resolveInfo.activityInfo.packageName;
            Intent targetedIntent = new Intent(intent);
            targetedIntent.setPackage(packageName);
            list.add(targetedIntent);
        }
        return list;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.test);

        initToolbar();
        initDrawerLayout();
        initViewValues();
        handleKeyboard();
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        HikeArmeniaApplication.setCurrentActivity(this);
    }

    private void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.custom_toolbar);
        setSupportActionBar(toolbar);

        getSupportActionBar().setDisplayShowTitleEnabled(false);
        getSupportActionBar().setHomeButtonEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        getSupportActionBar().setDisplayHomeAsUpEnabled(false);
        getSupportActionBar().setDisplayShowHomeEnabled(false);
        getSupportActionBar().setDisplayShowCustomEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);

        toolbar.setContentInsetsAbsolute(0, 0);
        EditText toolbarTitleText = (EditText) findViewById(R.id.toolbar_title);
        toolbarTitleText.setVisibility(View.VISIBLE);
        toolbarTitleText.setText("Edit Account");

        findViewById(R.id.home_icon).setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (drawerLayout != null) {
                            drawerLayout.openDrawer(Gravity.LEFT);
                        }
                    }
                }).playOn(v, LONG_DURETION);
                return false;
            }
        });

        findViewById(R.id.save).setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        SignInRequest request = createUserUpdateRequest();
                        if (request != null) {
                            UIUtil.showProgressDialog(ProfileActivity.this);
                            getUserServiceManager().updateUserData(request, ProfileActivity.this);
                        }
                    }
                }).playOn(v, LONG_DURETION);
                return false;
            }
        });
    }

    private SignInRequest createUserUpdateRequest() {

        String firstName = nameEditText.getText().toString();
        String lastName = surnameEditText.getText().toString();
        String email = emailEditText.getText().toString();
        String phone = phoneEditText.getText().toString();
        avatar = "";
        if (userAvatarx64 != null) {
            avatar = userAvatarx64;
        }
        SignInRequest request = new SignInRequest();
        String udId = getDeviceUdid();
        if (avatar.isEmpty()) {
            if (!firstName.matches("") && !lastName.matches("") && Util.isEmailValid(email)) {
                request = new SignInRequest(firstName, lastName, phone, email);
            } else if (!Util.isEmailValid(email) && !firstName.matches("") && !lastName.matches("")) {
                UIUtil.alertDialogShow(this, getString(R.string.invalid_email_title), getString(R.string.invalid_email_message));
                return null;
            } else {
                UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.fill_empty_fields));

                return null;
            }

        } else {
            if (!firstName.matches("") && !lastName.matches("") && Util.isEmailValid(email)) {
                request = new SignInRequest(firstName, lastName, phone, email);
            } else if (!Util.isEmailValid(email)) {
                UIUtil.alertDialogShow(this, getString(R.string.invalid_email_title), getString(R.string.invalid_email_message));
                return null;
            } else {
                UIUtil.alertDialogShow(this, getString(R.string.warning), getString(R.string.fill_empty_fields));
                return null;
            }
            request = new SignInRequest(firstName, lastName, avatar, phone, email);
        }
        return request;
    }

    private void handleKeyboard() {
        final View contentView = findViewById(R.id.root_content);
        contentView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {

                Rect r = new Rect();
                contentView.getWindowVisibleDisplayFrame(r);
                int screenHeight = contentView.getRootView().getHeight();

                // r.bottom is the position above soft keypad or device button.
                // if keypad is shown, the r.bottom is smaller than that before.
                int keypadHeight = screenHeight - r.bottom;
                if (keypadHeight > screenHeight * 0.15) { // 0.15 ratio is perhaps enough to determine keypad height.
                    // keyboard is opened
                    logoutBtn.setVisibility(View.GONE);
                } else {
                    // keyboard is closed
                    logoutBtn.setVisibility(View.VISIBLE);
                }
            }
        });

    }

    @Override
    protected void onPause() {
        HikeArmeniaApplication.setCurrentActivity(null);
        super.onPause();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {
            case android.R.id.home:
                if (drawerLayout != null) {
                    drawerLayout.openDrawer(Gravity.LEFT);
                }
                return true;
            case R.id.toolbar_menu_item:
                finish();
                return true;
            default:
                return false;
        }
    }

    @Override
    public void onResponseReceive(Object obj) {
        UIUtil.hideProgressDialog(ProfileActivity.this);
        UIUtil.alertDialogShow(this, getString(R.string.sucses), getString(R.string.changes_successfully_saved), new CustomAlertDialog.Callback() {
            @Override
            public void onPositiveButtonChoosen() {
                finish();
            }
        });

    }

    @Override
    public void onError(String message) {
        UIUtil.hideProgressDialog(this);
        UIUtil.alertDialogShow(this, getString(R.string.save_account_failed), message);
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (v.getId()) {
            case R.id.profile_view_logout_button:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        getUserServiceManager().signOutUser();
                        if (getOnAccountChangeListener() != null) {
                            getOnAccountChangeListener().onAccountChanged(false);
                        }
                        UIUtil.showProgressDialog(ProfileActivity.this);
                        savedTrails(false);
                        getTrailServicsManager().getListOfTrails(new NetworkRequestListener() {
                            @Override
                            public void onResponseReceive(Object obj) {
                                UIUtil.hideProgressDialog(ProfileActivity.this);
                                finish();
                            }

                            @Override
                            public void onError(String message) {
                                UIUtil.hideProgressDialog(ProfileActivity.this);
                                UIUtil.alertDialogShow(ProfileActivity.this, getString(R.string.warning), message);
                            }
                        });
                    }
                }).playOn(v, STANDART_DURETION);
                break;
            case R.id.change_account_photo:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        if (ContextCompat.checkSelfPermission(ProfileActivity.this, Manifest.permission.READ_EXTERNAL_STORAGE)
                                != PackageManager.PERMISSION_GRANTED
                                &&
                                ContextCompat.checkSelfPermission(ProfileActivity.this, Manifest.permission.CAMERA)
                                        != PackageManager.PERMISSION_GRANTED) {

                            if (ActivityCompat.shouldShowRequestPermissionRationale(ProfileActivity.this,
                                    Manifest.permission.READ_EXTERNAL_STORAGE)) {

                            } else {
                                ActivityCompat.requestPermissions(ProfileActivity.this,
                                        new String[]{
                                                Manifest.permission.CAMERA,
                                                Manifest.permission.READ_EXTERNAL_STORAGE
                                        },
                                        READ_EXTERNAL_STORAGE_CODE);
                            }
                        } else {
                            pickerIntent();
                        }
                    }
                }).playOn(v, STANDART_DURETION);
                break;

            case R.id.change_password_btn:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        startActivityForResult(new Intent(ProfileActivity.this, ChangePasswordActivity.class), 0);
                        overridePendingTransition(R.anim.slide_left_enter, R.anim.slide_right_enter);
                    }
                }).playOn(v, STANDART_DURETION);

                break;
            case R.id.delete_photo:
                YoYo.with(Techniques.Pulse).onEnd(new YoYo.AnimatorCallback() {
                    @Override
                    public void call(Animator animator) {
                        userPhoto.setImageResource(R.drawable.prof_pic);
                        Bitmap largeIcon = BitmapFactory.decodeResource(getResources(), R.drawable.prof_pic);
                        userAvatarx64 = encodeToBase64(largeIcon);
                        largeIcon.recycle();
                    }
                }).playOn(v, STANDART_DURETION);
                break;

            default:
                break;
        }
    }

    private User updateUser() {
        User user = getUserServiceManager().getUser();
        user.setFirstName(nameEditText.getText().toString());
        user.setLastName(surnameEditText.getText().toString());
        user.setEmail(emailEditText.getText().toString());
        user.setPhone(phoneEditText.getText().toString());
        if (userAvatarx64 != null) {
            user.setAvatar(userAvatarx64);
        }

        return user;
    }

    private void initViewValues() {
        nameEditText = (EditText) findViewById(R.id.edit_name);
        deletePhoto = (TextView) findViewById(R.id.delete_photo);
        deletePhoto.setOnClickListener(this);
        surnameEditText = (EditText) findViewById(R.id.edit_surname);
        emailEditText = (EditText) findViewById(R.id.edit_email);
        phoneEditText = (EditText) findViewById(R.id.edit_phone);
        logoutBtn = (Button) findViewById(R.id.profile_view_logout_button);
        changePasswordBtn = (Button) findViewById(R.id.change_password_btn);
        changePasswordBtn.setOnClickListener(this);
        logoutBtn.setOnClickListener(this);
        editPhotoTv = (com.hikearmenia.ui.widgets.TextView) findViewById(R.id.change_account_photo);
        editPhotoTv.setOnClickListener(this);
        userPhoto = (CircleImageView) findViewById(R.id.puser_edit_prof_pic);

        if (getUserServiceManager() != null && getUserServiceManager().getUser() != null) {
            User user = getUserServiceManager().getUser();

            if (user.getAvatar() != null) {

                if (user.getAvatar() != null) {
                    ImageLoader loader = new ImageLoader(this, R.drawable.prof_pic);
                    loader.DisplayImage(user.getAvatar(), userPhoto);
                }

                nameEditText.setText(user.getFirstName());
                surnameEditText.setText(user.getLastName());
                emailEditText.setText(user.getEmail());

                if (user.getPhone() != null) {
                    phoneEditText.setText(user.getPhone());
                }
            }
        }
    }

    private void pickerIntent() {
        Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        Intent pickPhoto = new Intent(Intent.ACTION_PICK,
                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);

//        File f = new File(Environment.getExternalStorageDirectory(), "temp.jpg");
//        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(f));

        List<Intent> pickerIntents = new ArrayList<>();

        pickerIntents = addIntentsToList(this, pickerIntents, cameraIntent);
        pickerIntents = addIntentsToList(this, pickerIntents, pickPhoto);

        Intent chooser = new Intent();
        if (pickerIntents.size() > 0) {
            chooser = Intent.createChooser(pickerIntents.remove(0), null);
            chooser.putExtra(Intent.EXTRA_INITIAL_INTENTS, pickerIntents.toArray(new Parcelable[]{}));
        }

        startActivityForResult(chooser, 123);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        switch (requestCode) {
            case READ_EXTERNAL_STORAGE_CODE:
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    pickerIntent();

                } else {

                    Toast.makeText(this, "No permissions", Toast.LENGTH_SHORT).show();
                }
                return;

        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (data != null) {
            if (data.hasExtra("data")) {
                try {
                    Bitmap bitmap;
                    bitmap = (Bitmap) data.getExtras().get("data");
                    Uri selectedImageUri = getImageUri(getApplicationContext(), bitmap);
                    Bitmap rotatedBitmap = UIUtil.getRotatedBitmap(getRealPathFromURI(selectedImageUri));

                    userPhoto.setImageBitmap(rotatedBitmap);
                    userAvatarx64 = encodeToBase64(rotatedBitmap);

                    rotatedBitmap.recycle();
                    bitmap.recycle();
                } catch (Exception ignored) {

                }

            } else {
                //gallery
                Uri selectedImage = data.getData();
                if (selectedImage != null) {
                    String realPath = getRealPathFromURI(selectedImage);
                    Bitmap bitmap = UIUtil.getRotatedBitmap(realPath);
                    bitmap = Bitmap.createScaledBitmap(bitmap, bitmap.getWidth() / 3, bitmap.getHeight() / 3, true);
                    userPhoto.setImageBitmap(bitmap);
                    userAvatarx64 = encodeToBase64(bitmap);
                    bitmap.recycle();
                }
            }
        }

        switch (resultCode) {
            case ResultCodes.RESULT_CODE_DIALOG_OK:
                UIUtil.alertDialogShow(this, getString(R.string.sucses), getString(R.string.password_successfully_changed));
        }
    }

    public String encodeToBase64(final Bitmap image) {
        Bitmap compressedImage = image;
        final ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

        compressedImage.compress(Bitmap.CompressFormat.JPEG, 70, byteArrayOutputStream);

        return Base64.encodeToString(byteArrayOutputStream.toByteArray(), Base64.DEFAULT);
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                v.setAlpha(0.7f);
                break;
            case MotionEvent.ACTION_UP:
                v.setAlpha(1f);
                if (v.getId() == R.id.save) {

                    break;
                }
        }
        return false;
    }

    public String getRealPathFromURI(Uri contentUri) {
        try {
            String[] proj = {MediaStore.Images.Media.DATA};
            Cursor cursor = managedQuery(contentUri, proj, null, null, null);
            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            return cursor.getString(column_index);
        } catch (Exception e) {
            return contentUri.getPath();
        }
    }

    public Uri getImageUri(Context inContext, Bitmap inImage) {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
        String path = MediaStore.Images.Media.insertImage(inContext.getContentResolver(), inImage, "Title", null);
        return Uri.parse(path);
    }

}
