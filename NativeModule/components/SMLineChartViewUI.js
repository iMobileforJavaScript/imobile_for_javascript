/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:折线图。
 
 **********************************************************************************/
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    requireNativeComponent,
    ViewPropTypes,
} from 'react-native';

class SMLineChartView extends Component{
    static propTypes = {
        title:PropTypes.string,
        textSize:PropTypes.number,
        axisTitleSize:PropTypes.number,
        axisLableSize:PropTypes.number,
        xAxisTitle:PropTypes.string,
        yAxisTitle:PropTypes.string,
        allowsUserInteraction:PropTypes.bool,
        hightLightColor:PropTypes.array,
        geoId:PropTypes.number,
        chartDatas:PropTypes.array,
        ...ViewPropTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTLineChartView {...props} ref="LineChartView"></RCTLineChartView>
    }
}

var RCTLineChartView = requireNativeComponent('RCTLineChartView',SMLineChartView);

export default SMLineChartView;
