/**
 * Created by will on 2016/7/27.
 */
let React = require('react');
let {requireNativeComponent,
    View,
    ViewPropTypes,
} = require('react-native');
import PropTypes from 'prop-types';

class SMCallOut extends React.Component{
    constructor(){
        super();
        this._onChange = this._onChange.bind(this);
    }

    state = {
        viewId:0,
    }

    static propTypes = {
        viewId: PropTypes.number,
        ...ViewPropTypes,
    };

    _onChange = (event) => {
        console.log("callout viewId:"+event.nativeEvent.callOutId);
        this.setState({
            viewId:event.nativeEvent.callOutId
        })
    }

    render(){
        var props = {...this.props};
        props.returnId = true;
        return <RCTCallOut {...props} onChange={this._onChange}></RCTCallOut>;
    }
}

var RCTCallOut = requireNativeComponent('RCTCallOut',SMCallOut,{nativeOnly:{
    returnId:true,
}});

export default SMCallOut;