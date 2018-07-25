package com.hikearmenia.ui.widgets;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.text.TextUtils;
import android.util.AttributeSet;

import com.hikearmenia.R;
import com.hikearmenia.ui.FontFactory;

/**
 * Created by jr on 4/22/16.
 */
public class TextView extends android.widget.TextView {
    private boolean mHandwrittenText;

    public TextView(Context context) {
        super(context);
        init(context, null);
    }

    public TextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public TextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context, attrs);
    }

    private void init(Context context, AttributeSet attrs) {
        if (attrs != null && !isInEditMode()) {
            TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.TextFont, 0, 0);

            try {
                String font = a.getString(R.styleable.TextFont_txtFont);
                if (!TextUtils.isEmpty(font)) {
                    setFont(font);
                }
            } finally {
                a.recycle();
            }
        }

    }

    public void setFont(String fontPath) {
        Typeface typeface = FontFactory.getInstance().getTypeface(getContext(), fontPath);
        setTypeface(typeface);
    }
}
