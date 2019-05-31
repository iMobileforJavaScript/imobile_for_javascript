package com.supermap.component;

import android.content.Context;
import android.support.v7.widget.AppCompatImageView;
import android.util.AttributeSet;

/**
 * @Author: shanglongyang
 * Date:        2019/5/21
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class ImageWrapView extends AppCompatImageView {
    public ImageWrapView(Context context) {
        super(context);
    }

    public ImageWrapView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public ImageWrapView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    public void requestLayout() {
        super.requestLayout();
        reLayout();
    }

    public void reLayout() {
        if (getWidth() > 0 && getHeight() > 0) {
            int w = MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY);
            int h = MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY);
            measure(w, h);
            layout(getPaddingLeft() + getLeft(), getPaddingTop() + getTop(), getWidth() + getPaddingLeft() + getLeft(), getHeight() + getPaddingTop() + getTop());
        }
    }
}
