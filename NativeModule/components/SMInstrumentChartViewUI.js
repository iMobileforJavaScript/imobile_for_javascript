/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:仪表盘。
 
 **********************************************************************************/
let React = require('react');
let {requireNativeComponent,View}=require('react-native');

class SMInstrumentChartView extends React.Component{
    static propTypes = {
        isShowCurValue:React.PropTypes.bool,
        minValue:React.PropTypes.number,
        maxValue:React.PropTypes.number,
        splitCount:React.PropTypes.number,
        startAngle:React.PropTypes.number,
        endAngle:React.PropTypes.number,
        backgroundColor:React.PropTypes.array,
        gradient:React.PropTypes.string,
        ...View.propTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTInstrumentChartView {...props} ref="InstrumentChartView"></RCTInstrumentChartView>
    }
}

var RCTInstrumentChartView = requireNativeComponent('RCTInstrumentChartView',SMInstrumentChartView);

export default SMInstrumentChartView;
