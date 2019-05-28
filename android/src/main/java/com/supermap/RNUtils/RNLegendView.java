package com.supermap.RNUtils;

import android.content.Context;
import android.os.Handler;

import com.supermap.mapping.LegendView;

/**
 * Created by will on 2016/9/19.
 */
public class RNLegendView extends LegendView{

    public RNLegendView(Context context){
        super(context);
    }

    private Handler mHandler = new Handler();

    @Override
    public void create(){
        mHandler.post(new Runnable() {

            @Override
            public void run() {
                // TODO Auto-generated method stub
                LegendAdapter legendAdapter = new LegendAdapter();
                setAdapter(legendAdapter);

                layoutChildren();
            }
        });
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
}
