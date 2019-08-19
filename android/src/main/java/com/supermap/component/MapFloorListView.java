package com.supermap.component;

import android.content.Context;
import android.util.AttributeSet;

import com.supermap.indoor.FloorListView;

public class MapFloorListView extends FloorListView {
    public MapFloorListView(Context context) {
        super(context);
    }
    public MapFloorListView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    @Override
    public void requestLayout() {
        super.requestLayout();
        post(new Runnable(){
            @Override
            public void run() {
                // 就差一个 draw 重绘了
                measure(
                        MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY),
                        MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY)
                );
                layout(getLeft(), getTop(), getRight(), getBottom());
                // 自定义样式处理
            }
        });
    }

//    @Override
//    public void requestLayout() {
//        super.requestLayout();
//        reLayout();
//    }

    public void reLayout() {
        if (getWidth() > 0 && getHeight() > 0) {
            int w = MeasureSpec.makeMeasureSpec(getWidth(), MeasureSpec.EXACTLY);
            int h = MeasureSpec.makeMeasureSpec(getHeight(), MeasureSpec.EXACTLY);
            measure(w, h);
            layout(getPaddingLeft() + getLeft(), getPaddingTop() + getTop(), getWidth() + getPaddingLeft() + getLeft(), getHeight() + getPaddingTop() + getTop());
        }
    }
}
