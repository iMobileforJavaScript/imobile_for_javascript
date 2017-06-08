 /**
 * Created by will on 2016/10/8.
 */
let React = require('react');
let {requireNativeComponent,View}=require('react-native');

class SMScaleView extends React.Component{
    static propTypes = {
        mapId:React.PropTypes.string,
        ...View.propTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTScaleView {...props} ref="ScaleView"></RCTScaleView>
    }
}

var RCTScaleView = requireNativeComponent('RCTScaleView',SMScaleView);

export default RCTScaleView;
