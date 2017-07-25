/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:柱状图。
 
 **********************************************************************************/
let React = require('react');
let {requireNativeComponent,View}=require('react-native');

class SMBarChartView extends React.Component{
    static propTypes = {
        title:React.PropTypes.string,
        textSize:React.PropTypes.number,
        isValueAlongXAxis:React.PropTypes.boolean,
        axisTitleSize:React.PropTypes.number,
        axisLableSize:React.PropTypes.number,
        xAxisTitle:React.PropTypes.string,
        yAxisTitle:React.PropTypes.string,
        hightLightColor:React.PropTypes.array,
        chartDatas:React.PropTypes.array,
        ...View.propTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTBarChartView {...props} ref="BarChartView"></RCTBarChartView>
    }
}

var RCTBarChartView = requireNativeComponent('RCTBarChartView',SMBarChartView);

export default SMBarChartView;
