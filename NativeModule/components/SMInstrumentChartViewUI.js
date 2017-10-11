/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:仪表盘。
 
 **********************************************************************************/
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    requireNativeComponent,
    ViewPropTypes,
} from 'react-native';

class SMInstrumentChartView extends Component{
    static propTypes = {
        isShowCurValue:PropTypes.bool,
        minValue:PropTypes.number,
        maxValue:PropTypes.number,
        splitCount:PropTypes.number,
        startAngle:PropTypes.number,
        endAngle:PropTypes.number,
        backgroundColor:PropTypes.array,
        gradient:PropTypes.string,
        ...ViewPropTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTInstrumentChartView {...props} ref="InstrumentChartView"></RCTInstrumentChartView>
    }
}

var RCTInstrumentChartView = requireNativeComponent('RCTInstrumentChartView',SMInstrumentChartView);

export default SMInstrumentChartView;
