package com.supermap.interfaces.ai;

import android.content.Context;
import android.util.AttributeSet;
import com.supermap.ai.AIDetectView;

public class CustomAIDetectView extends AIDetectView {

    public CustomAIDetectView(Context context) {
        super(context);
    }

    public CustomAIDetectView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    public CustomAIDetectView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
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
