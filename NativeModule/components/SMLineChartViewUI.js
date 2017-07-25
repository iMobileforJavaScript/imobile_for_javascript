/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:折线图。
 
 **********************************************************************************/
let React = require('react');
let {requireNativeComponent,View}=require('react-native');

class SMLineChartView extends React.Component{
    static propTypes = {
        title:React.PropTypes.string,
        textSize:React.PropTypes.number,
        axisTitleSize:React.PropTypes.number,
        axisLableSize:React.PropTypes.number,
        xAxisTitle:React.PropTypes.string,
        yAxisTitle:React.PropTypes.string,
        allowsUserInteraction:React.PropTypes.boolean,
        hightLightColor:React.PropTypes.array,
        geoId:React.PropTypes.number,
        chartDatas:React.PropTypes.array,
        ...View.propTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTLineChartView {...props} ref="LineChartView"></RCTLineChartView>
    }
}

var RCTLineChartView = requireNativeComponent('RCTLineChartView',SMLineChartView);

export default SMLineChartView;
