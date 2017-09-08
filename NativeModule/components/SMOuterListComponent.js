/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:内层list控件。
 
 **********************************************************************************/

import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  Dimensions,
  Image,
  FlatList,
  PixelRatio,
  TouchableHighlight
} from 'react-native';

import OuterListItem from './SMOuterListItem.js';

export default class OuterListComponent extends Component {
//item渲染方法
  _renderItem=({item})=>(
    <OuterListItem style={{backgroundColor:'white'}} Image={item.image} Text={item.Text}/>
  );

  _press=()=>{
    console.log('this is test');
  }
//分割线组件
  _separator=()=>{
    return <View style={{height:1 / PixelRatio.get(),backgroundColor: '#bbbbbb',marginLeft: 15,}}/>
  }

  render() {
    return (
      <FlatList data={this.props.data}
                renderItem={this._renderItem}
                ItemSeparatorComponent={this._separator}/>
    );
  }
}