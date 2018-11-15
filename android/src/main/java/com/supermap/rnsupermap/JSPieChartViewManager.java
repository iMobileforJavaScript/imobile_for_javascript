package com.supermap.rnsupermap;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.mapping.imChart.PieChart;

/**
 * Created by Myself on 2017/7/25.
 */

public class JSPieChartViewManager extends SimpleViewManager<PieChart> {
    private static final String REACT_CLASS = "RCTPieChartView";
    ThemedReactContext m_ThemeReactContext;

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public PieChart createViewInstance(ThemedReactContext reactContext){
        PieChart chartView = new PieChart(reactContext);
        return chartView;
    }
}
