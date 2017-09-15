/**
 * Created by will on 2016/9/7.
 */
let React = require('react');
let {
    requireNativeComponent,
    View,
    ViewPropTypes,
}=require('react-native');

class SMTimeLineView extends React.Component{
    static propTypes = {
        mapId:React.PropTypes.string,
        ...ViewPropTypes,
    };

    _refresh = (event) => {
        console.log(event.nativeEvent.enableRedraw);
    }

    render(){
        var props = {...this.props};
        return <RCTLegendView {...props} onChange={this._refresh} ref="LegendView"></RCTLegendView>
    }
}

var RCTLegendView = requireNativeComponent('RCTLegendView',SMLegendView);

export default SMLegendView;
