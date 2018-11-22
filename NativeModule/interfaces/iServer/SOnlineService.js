import {NativeModules,Platform,NativeEventEmitter} from 'react-native';
import { EventConst } from '../../constains'
let OnlineServiceNative = NativeModules.SOnlineService;
/*获取ios原生层的回调*/
const callBackIOS = new NativeEventEmitter(OnlineServiceNative);
export default class SOnlineService{
  constructor(){

    OnlineServiceNative.init();
  }
  async download (path,fileName,handler){
    if(Platform.OS === 'ios' && handler){
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING,function(value){
        console.log("download progress = "+value.progress);
      })
      // if(typeof handler.onProgress === 'function'){
      //   callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING,function(value){
      //    console.log("download progress = "+value);
      //   })
      // }
      // if(typeof handler.onComplete === 'function'){
      //   callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED,function(value) {
      //     console.log("完成下载"+value);
      //   })
      // }
      // if (typeof handlers.onFailure === 'function') {
      //   callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (e) {
      //     handlers.onFailure(e)
      //   })
      // }
    }
    else if(Platform.OS === 'android' && handler){

    }

    OnlineServiceNative.download(path,fileName);
  }
  async login(userName,password) {
    if(userName === 'undefined' || password === 'undefined'){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.login(userName,password);
    console.log(result);
    return result;
  }
  async logout(){
    let bLogoutResult = await OnlineServiceNative.logout();
    console.log(result);
    return bLogoutResult;
  }

  async getDataList(currentPage,pageSize){
    if(currentPage === undefined ||
      pageSize === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getDataList(currentPage,pageSize);
    console.log(result);
    return result;
  }

  async getServiceList(currentPage,pageSize){
    if(currentPage === undefined ||
      pageSize === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getServiceList(currentPage,pageSize);
    console.log(result);
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
    console.log(result);
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
    console.log(password);
    return result;
  }
  async sendSMSVerifyCode(phoneNumber){
    if(phoneNumber === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.sendSMSVerifyCode(phoneNumber);
    console.log(result);
    return result;
  }
  async upload(path,fileName){
    if(path === undefined ||
      fileName === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.upload(path,fileName);
    console.log(result);
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
    console.log(result);
    return result;
  }
  async retrievePasswordSecond(firstResult){
    if(firstResult === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.retrievePasswordSecond(firstResult);
    console.log(result);
    return result;
  }
  async retrievePasswordThrid(secondResult,safeCode){
    if(secondResult === undefined ||
      safeCode === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.retrievePasswordThrid(secondResult,safeCode);
    console.log(result);
    return result;
  }
  async retrievePasswordFourth(thridResult,newPassword){
    if(thridResult === undefined ||
      newPassword === undefined){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.retrievePasswordFourth(thridResult,newPassword);
    console.log(result);
    return result;
  }
  async deleteData(dataName){
    if(dataName === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.deleteData(dataName);
    console.log(result);
    return result;
  }
  async deleteService(dataName){
    if(dataName === undefined ){
      console.log('params have undefined');
      return;
    }
    console.log(result);
    let result = await OnlineServiceNative.deleteService(dataName);
  }
  async changeDataVisibility(dataName,isPublic){
    if(dataName === undefined ||
      isPublic === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.changeDataVisibility(dataName,isPublic);
    console.log(result);
    return result;
  }
  async changeServiceVisibility(serviceName,isPublic){
    if(serviceName === undefined ||
      isPublic === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.changeServiceVisibility(serviceName,isPublic);
    console.log(result);
    return result;
  }
  async getAllUserDataList(currentPage){
    if(currentPage === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getAllUserDataList(currentPage);
    console.log(result);
    return result;
  }
  async getAllUserSymbolLibList(currentPage){
    if(currentPage === undefined ){
      console.log('params have undefined');
      return;
    }
    let result = await OnlineServiceNative.getAllUserSymbolLibList(currentPage);
    console.log(result);
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