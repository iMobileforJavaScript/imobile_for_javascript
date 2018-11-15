/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:底层组件
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ 
  Image,
  Text,
  View,
  StyleSheet,
  TouchableHighlight 
} from 'react-native'

export default class ScrollPageTwoButton extends Component{
  render(){
    return(
      <TouchableHighlight style={[styles.buttonStyle,{backgroundColor:this.props.backgroundColor}]} onPress={this.props.clickButton} underlayColor={'rgba(34,26,38,0.1)'}>
        <View style={styles.innerContainer}>
           <Image style={styles.imageStyle} source={this.props.source}/>
           <View style={styles.textStyle}>
             <Text>{this.props.text}</Text>
           </View>
        </View>
      </TouchableHighlight>                                     
    );
  }
};

var styles = StyleSheet.create({
  buttonStyle:{
    display:'flex',
    flexDirection:'column',
    height:60,
    alignSelf:'center',
    justifyContent:'space-between',
    backgroundColor:'#F5FCFF',
  },
  innerContainer:{
    backgroundColor:'transparent',
  },
  imageStyle:{
    height:28,
    width:28,
    margin:1,
    alignSelf:'center',
    backgroundColor:'transparent',
  },
  textStyle:{
    height:28,
    margin:1,
    alignItems:'center',
    justifyContent: 'center',
    backgroundColor:'transparent',
  }
});