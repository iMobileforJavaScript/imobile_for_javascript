/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  PixelRatio,
} from 'react-native';

import ScrollPage from './SMScrollPage.js';
import ScrollPageOneBtn from './SMScrollPageOneButton.js';

export default class DsMapInfoComponent extends Component {
  render() {
    return (
      <View>
      <View style={[styles.container,{backgroundColor:this.props.backgroundColor}]}>
        <ScrollPage pageOneText={'数据源'} pageTwoButtonOneText={'新建数据源'} pageTwoButtonTwoText={'打开数据源'} pageTwoButtonThreeText={'关闭数据源'}
        pageOneImageOne={require('../resource/datasource.png')} clickPageOneBtn={this.props.clickPageOneBtn} clickPageTwoBtnOne={this.props.clickPageTwoBtnOne}/>
        <ScrollPageOneBtn imageOne={require('../resource/map.png')} text={'地图'} imageTwo={require('../resource/arrow.png') } clickButton={this.props.clickMapInfoBtn}/>
      </View>
      <View style={styles.separator}/>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  separator: {
    height: 1 / PixelRatio.get(),
    backgroundColor: '#bbbbbb',
    marginLeft: 15,
  },
});