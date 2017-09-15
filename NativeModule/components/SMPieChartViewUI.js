/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:饼状图。
 
 **********************************************************************************/
let React = require('react');
let {
    requireNativeComponent,
    View,
    ViewPropTypes,
}=require('react-native');

class SMPieChartView extends React.Component{
    static propTypes = {
        title:React.PropTypes.string,
        textSize:React.PropTypes.number,
        radious:React.PropTypes.number,
        center:React.PropTypes.array,
        geoId:React.PropTypes.number,
        textColor:React.PropTypes.array,
        chartDatas:React.PropTypes.array,
        ...ViewPropTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTPieChartView {...props} ref="PieChartView"></RCTPieChartView>
    }
}

var RCTPieChartView = requireNativeComponent('RCTPieChartView',SMPieChartView);

export default SMPieChartView;
