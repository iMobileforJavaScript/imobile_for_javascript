package com.supermap.component;

import android.content.Context;
import android.util.AttributeSet;

import com.supermap.mapping.MapView;

/**
 * @Author: shanglongyang
 * Date:        2019/5/21
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class MapWrapView extends MapView {
    public MapWrapView(Context context) {
        super(context);
    }

    public MapWrapView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

//    @Override
//    protected void onLayout(boolean b, int i, int i1, int i2, int i3) {
//        super.onLayout(b, i, i1, i2, i3);
//    }

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
