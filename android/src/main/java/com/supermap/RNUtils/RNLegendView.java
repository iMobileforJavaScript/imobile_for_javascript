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
    protected void create(){
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
}
