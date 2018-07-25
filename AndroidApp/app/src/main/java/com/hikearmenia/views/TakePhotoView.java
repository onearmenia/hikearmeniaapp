package com.hikearmenia.views;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;

public class TakePhotoView extends View {

    Bitmap bg;
    Bitmap logo;

    public TakePhotoView(Context context) {
        super(context);
    }

    public TakePhotoView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public TakePhotoView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void setBg(Bitmap bg)

    {
        this.bg = bg;
    }

    public void setLogo(Bitmap logo)
    {
        this.logo = logo;
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        Rect rect = new Rect(0, 0, getWidth(), getHeight());
        Rect rect2 = new Rect(getWidth() - getWidth() / 5, getHeight() - getHeight() / 7, getWidth() - 40, getHeight() - 40);
        if (bg != null) {
            canvas.drawBitmap(bg, null, rect, null);
        }
        if (logo != null) {
            canvas.drawBitmap(logo, null, rect2, null);
        }


    }

    public Bitmap asBitmap() {
        setDrawingCacheEnabled(true);
        buildDrawingCache();
        Bitmap drawingCache = Bitmap.createBitmap(getDrawingCache());
        setDrawingCacheEnabled(false);
        return drawingCache;
    }
}
