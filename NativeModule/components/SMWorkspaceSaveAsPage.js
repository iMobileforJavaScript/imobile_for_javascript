/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:工作空间另存控件。
 
 **********************************************************************************/

import React, { Component } from 'react';
import{
  Text,
  View,
  StyleSheet,
  TouchableHighlight 
} from 'react-native'

import InputComponent from './SMInputComponent.js'

let name ='';
let password ='';
let passwordConfirm ='';

export default class WorkspaceSaveAsPage extends Component{  
  constructor(props){
    super(props);
    // this._saveAs = this._saveAs.bind(this);
  }

  _nameChanged = (newText)=>{
    name = newText;
  }

  _passwordChanged = (newText)=>{
    password = newText;
  }

  _passwordConfirmChanged = (newText)=>{
    passwordConfirm = newText;
  }

  _saveAs = ()=>{
    if(name.length>0 && password.length>0 && password===passwordConfirm){
      var homeDirectory;
      var workspace = this.props.workspace;
      var oldFilePath = this.props.filePath;
      var oldFileName = this.props.fileName;
      var isContain = oldFilePath.indexOf(oldFileName);
      if(isContain>=0){
        homeDirectory = oldFilePath.slice(0,isContain); 
      }
      var newFileName = name +'.smwu';
      var newFilePath = homeDirectory + newFileName;

      (async function ( ) {
        var isSaveAs = await workspace.saveWorkspace(newFilePath);
        console.log('save As :'+isSaveAs);//--------------------无法进行密码保存-------------------!
        this.props.callBack(isSaveAs);
      }).bind(this)()
    }else{
      console.log('save failed, please check your save as name and password!');
    }
  }

  render() {
    return(
      <View style={styles.container}>
        <Text style={styles.tips}>*工作空间将另存至原工作空间同级目录*</Text>
        <View style={styles.inputContainerStyle}>
          <InputComponent titleText={'工作空间名称'} changeText={this._nameChanged}></InputComponent>
          <InputComponent titleText={'工作空间密码'} password={true} changeText={this._passwordChanged}></InputComponent>
          <InputComponent titleText={'工作空间密码确认'} password={true} changeText={this._passwordConfirmChanged}></InputComponent>
          <View style={styles.buttonContainer}>
            <TouchableHighlight style={styles.button} underlayColor={'rgba(34,26,38,0.1)'} onPress={this._saveAs}>{/*onPress-> this.props.clickBtnOne 若作为控件使用BtnOne应修改此处*/}
              <Text style={styles.saveButtonText}>保存</Text>
            </TouchableHighlight>
            <TouchableHighlight style={styles.button} underlayColor={'rgba(34,26,38,0.1)'} onPress={this.props.clickBtnTwo}>
              <Text style={styles.saveButtonText}>取消</Text>
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
  tips: {
    lineHeight:40,
    alignSelf:'center',
    backgroundColor:'transparent',
  },
  inputContainerStyle: {
    height:400,
    display:'flex',
    flexDirection:'column',
    justifyContent:'space-between',
    backgroundColor: 'transparent',
  },
  buttonContainer: {
    alignSelf:'center',
    height:40,
    width:200,
    display:'flex',
    flexDirection: 'row',
    justifyContent:'space-between',
    backgroundColor:'transparent',
  },
  button:{
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
