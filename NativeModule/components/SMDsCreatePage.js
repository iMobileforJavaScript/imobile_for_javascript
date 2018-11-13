/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:数据源创建页面。
 
 **********************************************************************************/

import React, { Component } from 'react';
import{ 
  Text,
  View,
  StyleSheet,
  Dimensions,
  TouchableHighlight,
} from 'react-native'

import ModalDropDown from './SMModalDropdown';
import InputComponent from './SMInputComponent.js'

export default class DsCreatePage extends Component{
                                   
  render() {
    return(
      <View style={styles.container}>
        <Text style={styles.tips}>*新创建的数据源将存储至当前工作空间同级目录*</Text>
        <View style={styles.innerContainer}>
          <InputComponent titleText={'数据源名称'} changeText={this._nameChanged}></InputComponent>
          <ModalDropDown style={styles.dropStyle}
                            textStyle={styles.dropTextStyle}
                            dropdownStyle={styles.dropdownStyle}
                            defaultValue={'文件类型'}
                            options={['SuperMap UDB文件', 'Google KML 文件', 'GeoJson 文件']}/>
          <View>
            <TouchableHighlight style={styles.saveButton}>
              <Text style={styles.saveButtonText}>保存</Text>
            </TouchableHighlight>
          </View>
        </View>
      </View>
           );
  }
    
};

var styles = StyleSheet.create({
  container: {
    backgroundColor:'#F5FCFF',
    display:'flex',
    flexDirection:'column',
    justifyContent:'space-around',
  },
  innerContainer: {
    height:250,
    backgroundColor:'#F5FCFF',
    display:'flex',
    flexDirection:'column',
    justifyContent:'space-between',
  },
  tips: {
    height:40,
    alignSelf:'center',
    backgroundColor:'transparent',
  },
  inputContainerStyle: {
    height:40,

  },
  dropStyle:{
    alignSelf:'center',
    width:0.8*Dimensions.get('window').width,
    height:40,
    backgroundColor:'#F5FCFF',
    borderColor: 'rgba(59,55,56,0.3)',
    borderWidth: 1,
    borderRadius:3,
  },
  dropTextStyle: {
    marginVertical: 11,
    backgroundColor:'#F5FCFF',
    fontSize: 18,
    textAlignVertical: 'center',
    color:'rgba(59,55,56,0.5)',
    alignSelf:'center',
  },
  dropdownStyle: {
    width: 0.8*Dimensions.get('window').width,
    height: 120,
    borderColor: 'rgba(59,55,56,0.3)',
    borderWidth: 2,
    borderRadius: 3,
  },
  saveButton:{
    alignSelf:'center',
    padding:10,
    width:75,
    height:40,
    backgroundColor:'#F5FCFF',
    borderColor: 'rgba(59,55,56,0.3)',
    borderWidth: 1,
    borderRadius:3,
  },
  saveButtonText:{
    alignSelf:'center',
  },
});