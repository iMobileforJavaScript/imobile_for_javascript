/**
 * Created by will on 2016/9/22.
 */
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    requireNativeComponent,
    View,
    ViewPropTypes,
} from 'react-native';

class SMLayerListView extends Component{

    static propTypes = {
        bindMapId:PropTypes.string,
        ...ViewPropTypes,
    };

    render(){
        var props = {...this.props};
        return <RCTLayerListView {...props}></RCTLayerListView>
    }
}

var RCTLayerListView = requireNativeComponent('RCTLayerListView',SMLayerListView);

export default SMLayerListView;