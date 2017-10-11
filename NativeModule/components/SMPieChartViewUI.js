/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:饼状图。
 
 **********************************************************************************/
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    requireNativeComponent,
    ViewPropTypes,
} from 'react-native';

class SMPieChartView extends Component{
    static propTypes = {
        title:PropTypes.string,
        textSize:PropTypes.number,
        radious:PropTypes.number,
        center:PropTypes.array,
        geoId:PropTypes.number,
        textColor:PropTypes.array,
        chartDatas:PropTypes.array,
        ...ViewPropTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTPieChartView {...props} ref="PieChartView"></RCTPieChartView>
    }
}

var RCTPieChartView = requireNativeComponent('RCTPieChartView',SMPieChartView);

export default SMPieChartView;
