 /**
 * Created by will on 2016/10/8.
 */
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    requireNativeComponent,
    ViewPropTypes,
} from 'react-native';

class SMScaleView extends Component{
    static propTypes = {
        mapControlId:PropTypes.string,
        ...ViewPropTypes,
    };


    render(){
        var props = {...this.props};
        return <RCTScaleView {...props} ref="ScaleView"></RCTScaleView>
    }
}

var RCTScaleView = requireNativeComponent('RCTScaleView',SMScaleView);

export default RCTScaleView;
