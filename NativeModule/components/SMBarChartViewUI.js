import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    requireNativeComponent,
    ViewPropTypes,
} from 'react-native';

class SMBarChartView extends Component{
    static propTypes = {
        data:PropTypes.array,
        title:PropTypes.string,
        textSize:PropTypes.number,
        isValueAlongXAxis:PropTypes.bool,
        axisTitleSize:PropTypes.number,
        axisLableSize:PropTypes.number,
        xAxisTitle:PropTypes.string,
        yAxisTitle:PropTypes.string,
        hightLightColor:PropTypes.array,
        ...ViewPropTypes,
    };
    
    
    render(){
        var props = {...this.props};
        return <RCTBarChartView {...props} ref="BarChartView"></RCTBarChartView>
    }
}

var RCTBarChartView = requireNativeComponent('RCTBarChartView',SMBarChartView);

export default RCTBarChartView;
