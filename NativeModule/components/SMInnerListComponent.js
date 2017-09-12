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
} from 'react-native';

//imobile类引入
import workspaceModule from '../Workspace.js';
import dataSources from '../Datasources.js';
import dataSource from '../Datasource.js';
import dataSet from '../Dataset.js';

export default class InnerListComponent extends Component {
  constructor(props){
    super(props);
    var dataArr = [];
    var index = props.index;
    var workspace = props.workspace;
    (async function ( ) {
      var dataSources = await workspace.getDatasources();
      var dataSource = await dataSources.get(index);
      var dSetCount = await dataSource.getDatasetCount();
      for(var i=0;i<=dSetCount-1;i++){
        var dataset = await dataSource.getDataset(i);
        var name = await dataset.getName();
        var dataItem = {key:'_SMDset'+i,Text:name,Image:require('../resource/datasetList.png')};
        dataArr.push(dataItem);
      }

      this.state = {
        data: dataArr,
      };
      this.forceUpdate();//强制渲染方法--应尽量不使用此方法，考虑优化
    }).bind(this)();

    this.state = {
      data: false,
    };
  }

//item渲染方法
  _renderItem=({item})=>(
    <View style={styles.itemContainer}>
      <Image style={styles.itemImage} source={item.Image}/>
      <Text style={styles.itemText}>{item.Text}</Text>
    </View>
  );

//分割线组件
  _separator=()=>{
    return <View style={{height:1 / PixelRatio.get(),backgroundColor: '#bbbbbb',marginLeft: 60,}}/>
  }

  render() {
    return (
      <FlatList data={this.state.data}
                renderItem={this._renderItem}
                ItemSeparatorComponent={this._separator}/>
    );
  }
}

const styles = StyleSheet.create({
  itemContainer: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'flex-start',
    width: Dimensions.get('window').width,
    height: 50,
  },
  itemImage: {
    width:35,
    height:40,
    marginTop:5,
    marginBottom:5,
    marginLeft:70,
    backgroundColor:'transparent',
  },
  itemText: {
    marginLeft:10,
    lineHeight:50,
  }
});