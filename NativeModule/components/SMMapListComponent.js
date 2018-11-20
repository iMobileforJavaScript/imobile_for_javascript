/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:maplist控件。
 
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
    this.state = {
      data: false,
    };

    var dataArr = [];
    var workspace = props.workspace;
    (async function ( ) {
      var maps = await workspace.getMaps();
      var mapcount = await maps.getCount();
      for(var i=0;i<=mapcount-1;i++){
        var mapname = await maps.get(i);
        var dataItem = {key:'_SMMap'+i,Text:mapname,Image:require('../resource/map_1.png')};
        dataArr.push(dataItem);
      }

      this.setState({
        data: dataArr,
      });
    }).bind(this)();

 
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
    marginLeft:25,
    backgroundColor:'transparent',
  },
  itemText: {
    marginLeft:10,
    lineHeight:50,
  }
});