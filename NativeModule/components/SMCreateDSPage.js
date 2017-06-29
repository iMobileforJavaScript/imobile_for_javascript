/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:数据源创建页面。
 
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

import ModalDropDown from './SMModalDropdown';

var SaveAsPage = React.createClass({
                                   
  render() {
    return(
      <View style={styles.container}>
           <Text style={styles.tips}>新创建的数据源将存储至当前工作空间同级目录。</Text>
           <View style={styles.inputContainerStyle}>
             <TextInput style={styles.textInputStyle} placeholder='数据源名称'></TextInput>
             <ModalDropDown style={styles.dropStyle}
                            textStyle={styles.dropTextStyle}
                            dropdownStyle={styles.dropdownStyle}
                            defaultValue={'请选择文件类型'}
                            options={['SuperMap UDB文件', 'Google KML 文件', 'GeoJson 文件']}/>
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
                                   height:300,
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
                                 dropStyle:{
                                   alignSelf:'center',
                                   width:0.8*Dimensions.get('window').width,
                                   height:50,
                                   backgroundColor:'#E0E2E0',
                                 },
                                 dropTextStyle: {
                                   marginVertical: 11,
                                   backgroundColor:'#E0E2E0',
                                   fontSize: 18,
                                   textAlignVertical: 'center',
                                 },
                                 dropdownStyle: {
                                   width: 0.8*Dimensions.get('window').width,
                                   height: 80,
                                   borderColor: 'cornflowerblue',
                                   borderWidth: 2,
                                   borderRadius: 3,
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
