package com.hikearmenia.ui;

import android.content.Context;
import android.graphics.Typeface;

import com.hikearmenia.R;

import java.util.HashMap;
import java.util.Map;

public final class FontFactory {

    public static final int FONT_BLACK = 1;
    public static final int FONT_BOLD = 2;
    public static final int FONT_HEAVY = 3;
    public static final int FONT_LIGHT = 4;
    public static final int FONT_MEDIUM = 5;
    public static final int FONT_REGULAR = 6;
    public static final int FONT_SEMIBOLD = 7;
    public static final int FONT_THIN = 8;
    public static final int FONT_ULTRALIGHT = 9;

    private static FontFactory sInstance = new FontFactory();
    // Typeface caching;
    // more info here https://code.google.com/p/android/issues/detail?id=9904
    private Map<String, Typeface> mCache = new HashMap<String, Typeface>();

    private FontFactory() {
    }

    public static FontFactory getInstance() {
        return sInstance;
    }

    public Typeface getTypeface(Context context, int font) {
        switch (font) {
            case FONT_BLACK:
                return getTypeface(context, context.getString(R.string.black_font));

            case FONT_BOLD:
                return getTypeface(context, context.getString(R.string.bold_font));

            case FONT_HEAVY:
                return getTypeface(context, context.getString(R.string.heavy_font));

            case FONT_LIGHT:
                return getTypeface(context, context.getString(R.string.light_font));

            case FONT_MEDIUM:
                return getTypeface(context, context.getString(R.string.medium_font));

            case FONT_REGULAR:
                return getTypeface(context, context.getString(R.string.regular_font));

            case FONT_SEMIBOLD:
                return getTypeface(context, context.getString(R.string.semibold_font));

            case FONT_THIN:
                return getTypeface(context, context.getString(R.string.thin_font));

            case FONT_ULTRALIGHT:
                return getTypeface(context, context.getString(R.string.ultralight_font));
            default:
                return null;
        }
    }

    public synchronized Typeface getTypeface(Context context, String fontName) {
        Typeface typeface = mCache.get(fontName);

        if (typeface == null) {
            typeface = Typeface.createFromAsset(context.getApplicationContext().getAssets(), fontName);
            mCache.put(fontName, typeface);
        }

        return typeface;
    }

}
