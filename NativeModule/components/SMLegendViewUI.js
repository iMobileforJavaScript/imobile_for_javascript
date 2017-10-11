/**
 * Created by will on 2016/9/7.
 */
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    requireNativeComponent,
    ViewPropTypes,
} from 'react-native';

class SMLegendView extends Component{
    static propTypes = {
        mapId:PropTypes.string,
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