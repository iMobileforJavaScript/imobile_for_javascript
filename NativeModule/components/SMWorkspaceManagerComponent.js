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
  View,
  Alert,
} from 'react-native';

//imobile类引入
import workspaceModule from '../Workspace.js';
import util from '../utility/utility.js';

//视图类引入
import TitlePage from './SMTitlePage.js';
import ScrollPage from './SMScrollPage.js';
import WorkspaceSaveAsPage from './SMWorkspaceSaveAsPage.js';
import OuterListComponent from './SMOuterListComponent.js';
import DsMapInfo from './SMDsMapInfoComponent.js';
import DsCreatePage from './SMDsCreatePage.js';
import DsListComponent from './SMOuterListComponent.js';


export default class WorkspaceManagerComponent extends Component {
  constructor(props){
    super(props);
    
    var paths = props.path.split('/');
    var nameWithType = paths[paths.length-1];

    this.state = {title:{display:true,text:'工作空间管理',backBtnDisplay:true,clickBtn:this._quit},
                  scrollPage:{display:true,text:nameWithType},
                  wsSaveAsPage:{display:false},
                  dmInfoPage:{display:false},
                  dsCreatePage:{display:false},
                  dsListPage:{display:false},
                };

    var workspaceM = new workspaceModule();
    (async function () {
      //------------------------util只适用于iOS------------------------//!!
      var filePath = await util.appendingHomeDirectory(props.path);
      var workspace = await workspaceM.createObj();
      await workspace.open(filePath);     
      this.setState({
        coreData:{workspace:workspace,filePath: filePath,fileName:nameWithType,workspaceOpen:true},
      });
    }).bind(this)();
  }

  _toWsInfoPage = ()=>{
    //this is scrollPage one btn,it means show workspace map&datasource info.
    var fileName = this.state.coreData.fileName;
    var nameArr = fileName.split('.');
    var nameWithoutType = nameArr[0];

    this.setState({
      title:{display:true,text:nameWithoutType,backBtnDisplay:true,clickBtn:this._toMainPage,},
      scrollPage:{display:false},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:true},
      dsCreatePage:{display:false},
      dsListPage:{display:false},
    });
  }

  _wsSaveBtnPress = ()=>{
    //this is scrollPage Two btn One,it means save workspace.
    if(this.state.coreData.workspace){
      (async function(){
        var isSave = await this.state.coreData.workspace.saveWorkspace();
        if(isSave){
          Alert.alert(
            '保存工作空间成功',
          );
        }else{
          Alert.alert(
            '保存工作空间失败',
          );
        }
      }).bind(this)();
    }
  }

  _toSaveAsPage = ()=>{
    this.setState({
      title:{display:true,text:'另存工作空间为',backBtnDisplay:false},
      scrollPage:{display:false},
      wsSaveAsPage:{display:true},
      dmInfoPage:{display:false},
      dsCreatePage:{display:false},
      dsListPage:{display:false},
    });
  }

  _wsCloseBtnPress = ()=>{
  //this is scrollPage Two btn Three,it means close workspace
  (async function () {
    if(! this.state.coreData.workspaceOpen){
      return
    }
    var workspace = this.state.coreData.workspace;
    var filePath = this.state.coreData.filePath;
    var fileName = this.state.coreData.fileName;
    var isClose = await workspace.closeWorkspace();   
    console.log('isClose:'+isClose);
    this.setState({
      coreData:{workspace:workspace,filePath: filePath,fileName:fileName,workspaceOpen:!isClose},
      title:{display:true,text:'工作空间管理',backBtnDisplay:true,clickBtn:this._quit},
      scrollPage:{display:true,text:'未命名工作空间'},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:false},
      dsCreatePage:{display:false},
      dsListPage:{display:false},
    });
  }).bind(this)();
  }

  _toDsCreatePage = ()=>{
    this.setState({
      title:{display:true,text:'新建数据源',backBtnDisplay:true,clickBtn:this._toWsInfoPage,},
      scrollPage:{display:false},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:false},
      dsCreatePage:{display:true},
      dsListPage:{display:false},
    });
  }

  _toDsList =()=>{
    // this is Ds&map info scroll pageOne btn press ,it means to show dsListView.
    this.setState({
      title:{display:true,text:'数据源',backBtnDisplay:true,clickBtn:this._toWsInfoPage},
      scrollPage:{display:false},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:false},
      dsCreatePage:{display:false},
      dsListPage:{display:true},
    });
  }

  _toMapList =()=>{
    console.log('go to map list');
  }

  _toMainPage = ()=>{
    var scrollText;
    var open = this.state.coreData.workspaceOpen;
    if(open){
      scrollText = this.state.coreData.fileName;
    }else{
      scrollText = '未命名工作空间';
    }
    this.setState({
      title:{display:true,text:'工作空间管理',backBtnDisplay:true,clickBtn:this._quit},
      scrollPage:{display:true,text:scrollText},
      wsSaveAsPage:{display:false},
      dmInfoPage:{display:false},
      dsCreatePage:{display:false},
      dsListPage:{display:false},
    });
  }

//WorkspaceSaveAsPage 回调函数，可以用于返回另存workspace的id（目前未实现）
  _workSpaceIdCallback = (isSaveAs)=>{
    this._toMainPage;
  }

//外部回调方法,提供给外部通知点击了退出按钮
  _quit = ()=>{
    //this.props.quitCallback('quit');
  }

  render() {
    return (
      <View style={styles.container}>
        {this.state.title.display && <TitlePage text={this.state.title.text} backBtnDisplay={this.state.title.backBtnDisplay} clickBtn={this.state.title.clickBtn}/>}
        {this.state.scrollPage.display && <ScrollPage clickPageOneBtn={this._toWsInfoPage}
        clickPageTwoBtnOne={this._wsSaveBtnPress} clickPageTwoBtnTwo={this._toSaveAsPage}
        clickPageTwoBtnThree={this._wsCloseBtnPress} pageOneText={this.state.scrollPage.text}/>}
        {this.state.wsSaveAsPage.display && <WorkspaceSaveAsPage workspace={this.state.coreData.workspace} filePath={this.state.coreData.filePath} fileName={this.state.coreData.fileName} clickBtnTwo={this._toMainPage} callBack={this._workSpaceIdCallback}/>}
        {this.state.dmInfoPage.display && <DsMapInfo clickPageOneBtn={this._toDsList} clickPageTwoBtnOne={this._toDsCreatePage} clickMapInfoBtn={this._toMapList}/>}
        {this.state.dsCreatePage.display && <DsCreatePage/>}
        {this.state.dsListPage.display && <DsListComponent workspace={this.state.coreData.workspace}/>}
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
