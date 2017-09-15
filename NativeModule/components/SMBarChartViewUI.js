
let React = require('react');
let {
    requireNativeComponent,
    View,
    ViewPropTypes,
}=require('react-native');

class SMBarChartView extends React.Component{
    static propTypes = {
        data:React.PropTypes.array,
        title:React.PropTypes.string,
        textSize:React.PropTypes.number,
        isValueAlongXAxis:React.PropTypes.bool,
        axisTitleSize:React.PropTypes.number,
        axisLableSize:React.PropTypes.number,
        xAxisTitle:React.PropTypes.string,
        yAxisTitle:React.PropTypes.string,
        hightLightColor:React.PropTypes.array,
        ...ViewPropTypes,
    };
    
    
    render(){
        var props = {...this.props};
        return <RCTBarChartView {...props} ref="BarChartView"></RCTBarChartView>
    }
}

var RCTBarChartView = requireNativeComponent('RCTBarChartView',SMBarChartView);

export default RCTBarChartView;
