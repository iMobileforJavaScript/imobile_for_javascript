package com.supermap.rnsupermap;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.charts.PieChartView;

/**
 * Created by Myself on 2017/7/25.
 */

public class JSPieChartViewManager extends SimpleViewManager<PieChartView> {
    private static final String REACT_CLASS = "RCTPieChartView";
    ThemedReactContext m_ThemeReactContext;

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public PieChartView createViewInstance(ThemedReactContext reactContext){
        PieChartView chartView = new PieChartView(reactContext);
        return chartView;
    }
}
