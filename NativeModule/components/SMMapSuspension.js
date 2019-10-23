/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will Chen (Created on 2016/6/15)
 E-mail: pridehao@gmail.com
 Description:地图主控件

 **********************************************************************************/
import PropTypes from 'prop-types';
import React, {Component} from 'react';
import {
  requireNativeComponent,
  View,
  StyleSheet,
  ViewPropTypes,
  NativeModules,
  Dimensions,
  Platform,
} from 'react-native';
import {
  SMapSuspension,
} from 'imobile_for_reactnative'
import {scaleSize} from '../../../../src/utils/screen'

let resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');

let MV = NativeModules.JSMapView;
/**
 * ServerMapView视图标签，提供onGetInstance属性，该属性值的类型为函数，
 * 且函数参数为从Native层返回的MapViewId，在使用该标签时，必须通过此属性获得MapViewId
 */
const STARTPOINT = require('./../resource/startpoint.png');
const DESTPOINT = require('./../resource/destpoint.png');
export const HEADER_HEIGHT = scaleSize(88) + (Platform.OS === 'ios' ? 20 : 0)

class SMMapSuspension extends Component {

  static propTypes = {
    onGetInstance: PropTypes.func,
    addCalloutByLongPress: PropTypes.bool,
    ...ViewPropTypes,
  };

  static defaultProps = {
    addCalloutByLongPress: false,
  }

  constructor() {
    super();
    this._onChange = this._onChange.bind(this);
    this.state = {
      show: false,
      left: 0,
      top: 0,
    }
  }


  setVisible = (iShow, params = {}) => {
    let ex = params.x - scaleSize(200)
    let ey = params.y - scaleSize(200) + HEADER_HEIGHT
    this.setState({show: iShow, left: ex, top: ey})
  }

  componentWillMount() {
    this.mapView = {}
  }

  _onChange(event: Event) {
    this.mapView._SMMapViewId = event.nativeEvent.mapViewId;
    SMapSuspension.openMap(this.mapView._SMMapViewId)
    GLOBAL.ToolBar.changeMapSuspension(GLOBAL.AIMAPITEM)
  }

  render() {
    var props = {...this.props};
    props.returnId = true;
    if (this.state.show) {
      return (
          <View style={{
            position: 'absolute',
            height: scaleSize(400), width: scaleSize(400), left: this.state.left, top: this.state.top,
            backgroundColor: 'transparent',
          }
          }>
            <MapSuspension {...props} style={styles.map} onChange={this._onChange}/>
          </View>
      );
    } else {
      return true
    }
  }
}

var MapSuspension = requireNativeComponent('RCTMapViewSus', SMMapSuspension, {
  nativeOnly: {
    returnId: true,
    onChange: true,
  }
});

SMMapSuspension.Image = {
  STARTPOINT,
  DESTPOINT,
}

var styles = StyleSheet.create({
  map: {
    flex: 1,
    alignSelf: 'stretch',
  },
});

export default SMMapSuspension;
