/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will Chen (Created on 2016/6/15)
 E-mail: pridehao@gmail.com
 Description:地图主控件

 **********************************************************************************/
import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
  requireNativeComponent,
  View,
  StyleSheet,
  ViewPropTypes,
  NativeModules,
} from 'react-native';
let resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');

let MV = NativeModules.JSMapView;
/**
 * ServerMapView视图标签，提供onGetInstance属性，该属性值的类型为函数，
 * 且函数参数为从Native层返回的MapViewId，在使用该标签时，必须通过此属性获得MapViewId
 */
const STARTPOINT = require('./../resource/startpoint.png');
const DESTPOINT = require('./../resource/destpoint.png');

class SMMapView extends Component {
  state = {
    startPoint: {},
    callouts: [],
    path: require('./../resource/startpoint.png'),
    map:{
      flex: 1,
      alignSelf: 'stretch',
      backgroundColor: '#ffbcbc',
      alignItems: 'center',
      justifyContent: 'center',
      overflow: 'hidden',
      flexDirection: 'column',
    },
  }

  static propTypes = {
    onGetInstance: PropTypes.func,
    callouts: PropTypes.array,
    addCalloutByLongPress: PropTypes.bool,
    ...ViewPropTypes,
  };

  static defaultProps = {
    callouts: [],
    addCalloutByLongPress: false,
  }

  constructor() {
    super();
    this._onChange = this._onChange.bind(this);
  }

  componentWillMount() {
    this.setState({
      callouts: this.props.callouts,
    });
    this.mapView = {}
  }
  
  _addCallout = async (x, y, pointName = 'aa') => {
    await MV.addCallOut(x, y, pointName);
    return {x, y}
  }

  _onChange(event) {
    if (!this.props.onGetInstance) {
      return;
    }
    this.mapView._SMMapViewId = event.nativeEvent.mapViewId;
    this.props.onGetInstance(this.mapView);
  }

  render() {
    var props = { ...this.props };
    props.returnId = true;

    return (
      <View style={this.state.map}>
        <RCTMapView {...props} style={styles.map} onChange={this._onChange} />
      </View>
    );
  }
}

var RCTMapView = requireNativeComponent('RCTMapView', SMMapView, {
  nativeOnly: {
    returnId: true,
    onChange: true,
  }
});

SMMapView.Image = {
  STARTPOINT,
  DESTPOINT,
}

var styles = StyleSheet.create({
  views: {
    flex: 1,
    alignSelf: 'stretch',
    backgroundColor: '#ffbcbc',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
    flexDirection: 'column',
  },
  map: {
    flex: 1,
    alignSelf: 'stretch',
  },
  pic: {
    position: 'absolute',
    top: -100,
    left: -100,
  },
  view: {
    height: 1,
    width: '100%',
  },
});

export default SMMapView;
