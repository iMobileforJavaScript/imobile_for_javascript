/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:地图另存页面。
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ ScrollView,
        Image,
        Text,
        View,
        TextInput,
        StyleSheet,
        Dimensions,
        TouchableHighlight } from 'react-native'

var SaveAsPage = React.createClass({
                                   
  render() {
    return(
      <View style={styles.container}>
           <Text style={styles.tips}>工作空间将另存至原工作空间同级目录。</Text>
           <View style={styles.inputContainerStyle}>
             <TextInput style={styles.textInputStyle} placeholder='工作空间名称'></TextInput>
             <TextInput style={styles.textInputStyle} placeholder='工作空间密码'></TextInput>
             <TextInput style={styles.textInputStyle} placeholder='工作空间密码确认'></TextInput>
             <TouchableHighlight style={styles.saveButton}>
             <Text style={styles.saveButtonText}>保存</Text>
             </TouchableHighlight>
           </View>
      </View>
           );
  }
    
});

var styles = StyleSheet.create({
                                 container: {
                                   backgroundColor:'white',
                                   display:'flex',
                                   flexDirection:'column',
                                   justifyContent:'space-around',
                                 },
                                 tips: {
                                   height:40,
                                   alignSelf:'center',
                                   backgroundColor:'white',
                                 },
                                 inputContainerStyle: {
                                   height:450,
                                   display:'flex',
                                   flexDirection:'column',
                                   justifyContent:'space-between',
                                 },
                                 textInputStyle: {
                                   alignSelf:'center',
                                   backgroundColor:'white',
                                   height: 50,
                                   width: 0.8*Dimensions.get('window').width,
                                   borderWidth:0.5,
                                   borderColor:'#E0E2E0',
                                 },
                                 saveButton:{
                                   padding:10,
                                   alignSelf:'center',
                                   width:75,
                                   height:40,
                                   backgroundColor:'#E0E2E0',
                                 },
                                   saveButtonText:{
                                   alignSelf:'center',
                                },
                                 });

module.exports = SaveAsPage;
