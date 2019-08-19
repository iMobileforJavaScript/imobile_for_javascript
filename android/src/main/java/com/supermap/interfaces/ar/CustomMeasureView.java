package com.supermap.interfaces.ar;

import android.content.Context;
import android.util.AttributeSet;
import com.supermap.ar.highprecision.MeasureView;

public class CustomMeasureView extends MeasureView {

    public CustomMeasureView(Context context) {
        super(context);
    }

    public CustomMeasureView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    public void requestLayout() {
        super.requestLayout();
        // The spinner relies on a measure + layout pass happening after it calls requestLayout().
        // Without this, the widget never actually changes the selection and doesn't call the
        // appropriate listeners. Since we override onLayout in our ViewGroups, a layout pass never
        // happens after a call to requestLayout, so we simulate one here.
        post(new Runnable() {
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
}
