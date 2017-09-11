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
  constructor(props){
    super(props);
    //数据获取
    
    this.state = {
      data: [{key:'_SMDs001',Text:'aaa',image:require('../resource/star.png')},{key:'_SMDs002',Text:'bbb',image:require('../resource/star.png')},{key:'_SMDs003',Text:'bbb',image:require('../resource/star.png')}],
    };
  }
//item渲染方法
  _renderItem=({item})=>(
    <OuterListItem style={{backgroundColor:'white'}} Image={item.image} Text={item.Text}/>
  );

//分割线组件
  _separator=()=>{
    return <View style={{height:1 / PixelRatio.get(),backgroundColor: '#bbbbbb',marginLeft: 15,}}/>
  }

  render() {
    return (
      <FlatList data={this.state.data}
                renderItem={this._renderItem}
                ItemSeparatorComponent={this._separator}/>
    );
  }
}