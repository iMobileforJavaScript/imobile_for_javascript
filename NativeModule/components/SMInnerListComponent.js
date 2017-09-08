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

export default class InnerListComponent extends Component {
//item渲染方法
  _renderItem=({item})=>(
    <View style={styles.itemContainer}>
      <Image style={styles.itemImage} source={item.image}/>
      <Text style={styles.itemText}>{item.text}</Text>
    </View>
  );

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

const styles = StyleSheet.create({
  itemContainer: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'flex-start',
    width: Dimensions.get('window').width,
    height: 50,
  },
  itemImage: {
    width:40,
    height:40,
    marginTop:5,
    marginBottom:5,
    marginLeft:25,
    backgroundColor:'white',
  },
  itemText: {
    marginLeft:25,
    lineHeight:50,
  }
});