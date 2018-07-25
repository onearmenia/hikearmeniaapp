package com.hikearmenia.ui.widgets;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;

import com.hikearmenia.R;
import com.hikearmenia.ui.FontFactory;

/**
 * Created by jr on 4/22/16.
 */
public class EditText extends android.widget.EditText {
    Context mContext;

    public EditText(Context context) {
        super(context);
        mContext = context;
        init(context, null);
    }

    public EditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    private void init(Context context, AttributeSet attrs) {
        if (attrs != null && !isInEditMode()) {
            TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.TextFont, 0, 0);

            try {
                String font = a.getString(R.styleable.TextFont_txtFont);
                setFont(font);

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
