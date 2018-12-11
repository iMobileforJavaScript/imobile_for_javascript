/**
 * Created by will on 2017/3/22.
 */
import PropTypes from 'prop-types';
import React, {Component} from 'react';
import {
  requireNativeComponent,
  View,
  StyleSheet,
  ViewPropTypes,
  Platform,
} from 'react-native';
import SceneControl from './../SceneControl';

class SMSceneView extends Component {
  
  _onChange = (event) => {
    if (!this.props.onGetScene) {
      console.error("no onGetScene property!");
      return;
      
    }
    console.log("has SceneControl id:" + event.nativeEvent.sceneControlId);
    
    this.sceneControl = new SceneControl();
    this.sceneControl.sceneControlId = event.nativeEvent.sceneControlId;
    this.props.onGetScene(this.sceneControl);
  };
  
  static propTypes = {
    onGetScene: PropTypes.func,
    ...ViewPropTypes,
  };
  
  render() {
    var props = {...this.props};
    props.returnId = true;
    
    return (
      <View style={styles.views}>
        {Platform.OS === 'android' && <View style={styles.view} />}
        <RCTSceneView {...props} style={styles.map} onChange={this._onChange}/>
        {Platform.OS === 'android' && <View style={styles.view} />}
      </View>
    );
  }
}

var RCTSceneView = requireNativeComponent('RCTSceneView', SMSceneView, {
  nativeOnly: {
    returnId: true,
    onChange: true,
  }
});

var styles = StyleSheet.create({
  views: {
    flex: 1,
    alignSelf: 'stretch',
    backgroundColor: '#ffbcbc',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
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

export default SMSceneView;