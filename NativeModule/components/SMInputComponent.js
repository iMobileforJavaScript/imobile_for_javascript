/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:title&input控件,可选参数：backgroundColor;titleText;password;changeText
 
 **********************************************************************************/

import React, { Component } from 'react';
import{
  Text,
  View,
  TextInput,
  StyleSheet,
  Dimensions,
} from 'react-native'

export default class InputComponent extends Component{                               
  render() {
    return(
      <View style={[styles.container,{backgroundColor: this.props.backgroundColor}]}>
        <Text style={styles.title}>{this.props.titleText}</Text>
        <TextInput style={styles.textInputStyle} secureTextEntry={this.props.password} onChangeText={this.props.changeText}/>
      </View>
    );
  }
    
};

var styles = StyleSheet.create({
  container: {
    backgroundColor:'#F5FCFF',
    display:'flex',
    flexDirection:'column',
    justifyContent:'space-between',
  },
  title: {
    lineHeight:40,
    width: 0.8*Dimensions.get('window').width,
    alignSelf:'center',
    backgroundColor:'transparent',
  },
  textInputStyle: {
    alignSelf:'center',
    backgroundColor:'white',
    height: 40,
    width: 0.8*Dimensions.get('window').width,
    borderColor: 'rgba(59,55,56,0.3)',
    borderWidth: 1,
    borderRadius:3,
  },
});
