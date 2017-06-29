/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:标题控件（搜索控件子控件）。
 
 **********************************************************************************/
'use strict';

var ReactNative =require('react-native');
var React = require('react');
var {
  PanResponder,
  StyleSheet,
  Text,
  View,
} = ReactNative;

var SMTitle = React.createClass({
                                
  _panResponder: {},
                                
  componentWillMount: function() {
    this._panResponder = PanResponder.create({
      onStartShouldSetPanResponder: this._handleStartShouldSetPanResponder,
      onMoveShouldSetPanResponder: this._handleMoveShouldSetPanResponder,
      onPanResponderGrant: this._handlePanResponderGrant,
      onPanResponderMove: this._handlePanResponderMove,
      onPanResponderRelease: this._handlePanResponderEnd,
      onPanResponderTerminate: this._handlePanResponderEnd,
      });
    },
                                
  render: function() {
    return (
      <View style={styles.container} {...this._panResponder.panHandlers}>
        <Text style={styles.text}>
          {this.props.title}
        </Text>
      </View>
    );
  },
                                
  _handleStartShouldSetPanResponder: function(e: Object, gestureState: Object): boolean {
    return true;
  },
                                
  _handleMoveShouldSetPanResponder: function(e: Object, gestureState: Object): boolean {
    return true;
  },
  _handlePanResponderGrant: function(e: Object, gestureState: Object) {
    console.log('press');
  },
  _handlePanResponderMove: function(e: Object, gestureState: Object) {
                                if(gestureState.dy<-0.5){
                                console.log('手势上滑');
                                }else if(gestureState.dy>0.5){
                                console.log('手势下滑');
                                }
//    this._circleStyles.style.left = this._previousLeft + gestureState.dx;
//    this._circleStyles.style.top = this._previousTop + gestureState.dy;
//    this._updateNativeStyles();
                                },
  _handlePanResponderEnd: function(e: Object, gestureState: Object) {
     console.log('end');
  },
                                
});

var styles = StyleSheet.create({
  container: {
    margin: 10,
    height: 50,
    padding: 0,
    backgroundColor: '#F7F7F7',
  },
  text: {
    fontSize: 19,
    fontWeight: '500',
    textAlign:'center',
  },
});

module.exports = SMTitle;
