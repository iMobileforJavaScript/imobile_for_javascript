import {NativeModules,Platform,NativeEventEmitter} from 'react-native';
import { EventConst } from '../../constains'
let OnlineServiceNative = NativeModules.SOnlineService;
/*获取ios原生层的回调*/
const callBackIOS = new NativeEventEmitter(OnlineServiceNative);
export default class SOnlineService{
  constructor(){
    // this.firstDownload =true;
    OnlineServiceNative.init();
  }
  uploadFile(path,dataName,handler){
    debugger;
    console.log("progress: 0");
    if(Platform.OS === 'ios' && handler){
      if(typeof handler.onProgress === 'function'){
        callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADING,function(obj){
          console.log("progress: "+obj.progress);
          let downloadId = obj.id;
          handler.onProgress(obj.progress);
        })
      }
      if(typeof handler.onResult === 'function'){
        callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADED,function(value) {
          handler.onResult(value);
        })
      }
    }
    OnlineServiceNative.upload(path,dataName);
  }
  downloadFile (path,onlineDataName,handler){
    if(Platform.OS === 'ios' && handler){
      if(typeof handler.onProgress === 'function'){
        callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING,function(obj){
          console.log("progress:"+obj.progress);
          let downloadId = obj.id;
          if(downloadId === onlineDataName){
            handler.onProgress(obj.progress);
          }
        })
      }
      if(typeof handler.onResult === 'function'){
        callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED,function(bResult) {
          handler.onResult(bResult);
        })
        callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE,function(strErrorInfo) {
          handler.onRateChange(strErrorInfo);
        })
      }
    }
    else if(Platform.OS === 'android' && handler){

    }


    OnlineServiceNative.download(path,onlineDataName);
  }
  async login(userName,password) {
    if(userName === 'undefined' || password === 'undefined'){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.login(userName,password);
    return result;
  }
  async logout(){
    let bLogoutResult = await OnlineServiceNative.logout();
    return bLogoutResult;
  }

  async getDataList(currentPage,pageSize){
    if(currentPage === undefined ||
      pageSize === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getDataList(currentPage,pageSize);
    return result;
  }

  async getServiceList(currentPage,pageSize){
    if(currentPage === undefined ||
      pageSize === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getServiceList(currentPage,pageSize);
    return result;
  }

  async registerWithEmail(email,nickname,password){
    if(email === undefined ||
      nickname === undefined ||
      password === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.registerWithEmail(email,nickname,password);
    return result;
  }

  async registerWithPhone(phoneNumber,smsVerifyCode,nickname,password){
    if(phoneNumber === undefined ||
       smsVerifyCode === undefined ||
       nickname === undefined ||
       password === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.registerWithPhone(phoneNumber,smsVerifyCode,nickname,password);
    return result;
  }
  async sendSMSVerifyCode(phoneNumber){
    if(phoneNumber === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.sendSMSVerifyCode(phoneNumber);
    return result;
  }
  async upload(path,fileName){
    if(path === undefined ||
      fileName === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.upload(path,fileName);
    return result;
  }
  async verifyCodeImage(){
    let result = await OnlineServiceNative.verifyCodeImage();
    return result;
  }
  async retrievePassword(account,verifyCode,isPhoneAccount){
    if(account === undefined ||
      verifyCode === undefined ||
      isPhoneAccount === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.retrievePassword(account,verifyCode,isPhoneAccount);
    return result;
  }
  async retrievePasswordSecond(firstResult){
    if(firstResult === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.retrievePasswordSecond(firstResult);
    return result;
  }
  async retrievePasswordThrid(secondResult,safeCode){
    if(secondResult === undefined ||
      safeCode === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.retrievePasswordThrid(secondResult,safeCode);
    return result;
  }
  async retrievePasswordFourth(thridResult,newPassword){
    if(thridResult === undefined ||
      newPassword === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.retrievePasswordFourth(thridResult,newPassword);
    return result;
  }
  async deleteData(dataName){
    if(dataName === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.deleteData(dataName);
    return result;
  }
  async deleteService(dataName){
    if(dataName === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.deleteService(dataName);
  }
  async changeDataVisibility(dataName,isPublic){
    if(dataName === undefined ||
      isPublic === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.changeDataVisibility(dataName,isPublic);
    return result;
  }
  async changeServiceVisibility(serviceName,isPublic){
    if(serviceName === undefined ||
      isPublic === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.changeServiceVisibility(serviceName,isPublic);
    return result;
  }
  async getAllUserDataList(currentPage){
    if(currentPage === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getAllUserDataList(currentPage);
    return result;
  }
  async getAllUserSymbolLibList(currentPage){
    if(currentPage === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getAllUserSymbolLibList(currentPage);
    return result;
  }

  async publishService(dataName){
    if(dataName === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.publishService(dataName);
    return result;
  }
}