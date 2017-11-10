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

//imobile类引入
import workspaceModule from '../Workspace.js';
import dataSources from '../Datasources.js';
//子组件倒入
import OuterListItem from './SMOuterListItem.js';

export default class OuterListComponent extends Component {
  constructor(props){
    super(props);

    this.state = {
      data: false,
    };

    //数据获取
    var dataArr = [];
    var workspace = props.workspace;
    (async function ( ) {
      var dataSources = await workspace.getDatasources();
      var count = await dataSources.getCount();
      for (var i=0; i<=count-1;i++){
        var dsName = await dataSources.getAlias(i);
        var dataItem = {key:'_SMDs'+i,Text:dsName,Image:require('../resource/DsList.png'),Index:i};
        dataArr.push(dataItem);
      }

      this.setState({
        data: dataArr,
      });
      // this.state = {
      //   data: dataArr,
      // };

      this.forceUpdate();//强制渲染方法--应尽量不使用此方法，考虑优化
    }).bind(this)();

 
  }
//item渲染方法
  _renderItem=({item})=>(
    <OuterListItem Image={item.Image} Text={item.Text} Index={item.Index} workspace={this.props.workspace}/>
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