/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';

//imobile类引入
import workspaceModule from '../Workspace.js';

//视图类引入
import TitlePage from './SMTitlePage.js';
import ScrollPage from './SMScrollPage.js';
import WorkspaceSaveAsPage from './SMWorkspaceSaveAsPage.js';
import OuterListComponent from './SMOuterListComponent.js';
import DsMapInfo from './SMDsMapInfoComponent.js';
import DsCreatePage from './SMDsCreatePage.js';


export default class WorkspaceManagerComponent extends Component {
  constructor(props){
    super(props);

    var workspaceId = this.props.workspaceId;

    this.state = {title:{display:true,text:'工作空间管理',backBtnDisplay:true,clickBtn:this._quit},
                  scrollPage:{display:true,},
                  wsSaveAsPage:{display:false},
                  dmInfoPage:{display:false},
                  dsCreatePage:{display:false},
                };
  }

  _toWsInfoPage = ()=>{
    this.setState({
      title:{display:true,text:'World',backBtnDisplay:true,clickBtn:this._toMainPage,},
      scrollPage:{display:false},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:true},
      dsCreatePage:{display:false},
    });
  }
  _wsSaveBtnPress = ()=>{console.log('this is scrollPage Two btn One,it means save workspace')}
  _toSaveAsPage = ()=>{
    this.setState({
      title:{display:true,text:'另存工作空间为',backBtnDisplay:false},
      scrollPage:{display:false},
      wsSaveAsPage:{display:true},
      dmInfoPage:{display:false},
      dsCreatePage:{display:false},
    });
  }
  _wsCloseBtnPress = ()=>{console.log('this is scrollPage Two btn Three,it means close workspace')}
  _toDsCreatePage = ()=>{
    this.setState({
      title:{display:true,text:'新建数据源',backBtnDisplay:true,clickBtn:this._toWsInfoPage,},
      scrollPage:{display:false},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:false},
      dsCreatePage:{display:true},
    });
  }
  _toMainPage = ()=>{
    this.setState({
      title:{display:true,text:'工作空间管理',backBtnDisplay:true,clickBtn:this._quit},
      scrollPage:{display:true,},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:false},
      dsCreatePage:{display:false},
    });
  }
//WorkspaceSaveAsPage 回调函数，用于返回另存workspace的id
  _workSpaceIdCallback = (workspaceId)=>{
    console.log('the workspace id is:'+ workspaceId);
  }

//外部回调方法,提供给外部通知点击了退出按钮
  _quit = ()=>{
    this.props.quitCallback('quit');
  }

  render() {
    return (
      <View style={styles.container}>
        {this.state.title.display && <TitlePage text={this.state.title.text} backBtnDisplay={this.state.title.backBtnDisplay} clickBtn={this.state.title.clickBtn}/>}
        {this.state.scrollPage.display && <ScrollPage clickPageOneBtn={this._toWsInfoPage}
        clickPageTwoBtnOne={this._wsSaveBtnPress} clickPageTwoBtnTwo={this._toSaveAsPage}
        clickPageTwoBtnThree={this._wsCloseBtnPress}/>}
        {this.state.wsSaveAsPage.display && <WorkspaceSaveAsPage clickBtnTwo={this._toMainPage} callBack={this._workSpaceIdCallback}/>}
        {this.state.dmInfoPage.display && <DsMapInfo clickPageTwoBtnOne={this._toDsCreatePage}/>}
        {this.state.dsCreatePage.display && <DsCreatePage/>}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    display:'flex',
    flexDirection:'column',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('reactNativeLearnProject', () => reactNativeLearnProject);
