import {NativeModules, Platform, NativeEventEmitter,DeviceEventEmitter} from 'react-native';
import {EventConst} from '../../constains'
let OnlineServiceNative = NativeModules.SOnlineService;
/*获取ios原生层的回调*/
const callBackIOS = new NativeEventEmitter(OnlineServiceNative);
let objDownloadCallBackResult;
let bIsFirstDownload = true;
function init() {
  OnlineServiceNative.init();
}
/** 仅支持android*/
function getAndroidSessionID() {
  if(Platform.OS === 'android'){
    return OnlineServiceNative.getSessionID()
  }
  return 'undefined'
}
/** 仅支持android*/
function syncAndroidCookie() {
  if(Platform.OS === 'android'){
    return OnlineServiceNative.syncCookie('https://www.supermapol.com/')
  }
  return 'undefined'
}

/** 仅支持android*/
function cacheImage(imageUrl,saveImagePath) {
  if(Platform.OS === 'android'){
    return OnlineServiceNative.cacheImage(imageUrl,saveImagePath)
  }
  return '不支持ios的缓存'
}
function removeCookie() {
  return OnlineServiceNative.removeCookie()
}

function objCallBack(){
  return new NativeEventEmitter(OnlineServiceNative);
}

function uploadFile(path, dataName, handler) {
  if (Platform.OS === 'ios' && handler) {
    if (typeof handler.onProgress === 'function') {
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (obj) {
        console.log("progress: " + obj.progress);
        handler.onProgress(obj.progress);
      })
    }
    if (typeof handler.onResult === 'function') {
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (value) {
        handler.onResult(value);
      })
    }
  }else{
    if (typeof handler.onProgress === 'function'&& handler) {
      DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (progress) {
        handler.onProgress(progress);
      })
    }
    if (typeof handler.onResult === 'function'&& handler) {
      DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (result) {
        handler.onResult(result);
      })
    }
  }
  OnlineServiceNative.upload(path, dataName);
}


function downloadFileWithCallBack(path, dataName, handler) {

  if (Platform.OS === 'ios' && handler) {
    if (typeof handler.onProgress === 'function') {
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (obj) {
        console.log("progress: " + obj.progress);
        handler.onProgress(obj.progress);
      })
    }
    if (typeof handler.onResult === 'function') {
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED, function (value) {
        handler.onResult(value);
      })
    }
    if (typeof handler.onResult === 'function') {
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (value) {
        handler.onResult(value);
      })
    }
  }else{
    if (typeof handler.onProgress === 'function'&& handler) {
      DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (progress) {
        handler.onProgress(progress);
      })
    }
    if (typeof handler.onResult === 'function'&& handler) {
      DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED, function (result) {
        handler.onResult(result);
      })
    }
    if (typeof handler.onResult === 'function'&& handler) {
      DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (result) {
        handler.onResult(result);
      })
    }
  }
  OnlineServiceNative.download(path, dataName);
}

function downloadFile(path, onlineDataName) {
  OnlineServiceNative.download(path, onlineDataName);
}
function cancelDownload() {
  if(Platform.OS === 'ios'){
    OnlineServiceNative.cancelDownload();
  }
}
function downloadFileWithDataId(path, dataNameId) {
  OnlineServiceNative.downloadWithDataId(path, dataNameId);
}
function login(userName, password) {
  if (userName === undefined || password === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.login(userName, password);
}

function getUserInfo() {

  return OnlineServiceNative.getUserInfo();
}

function getUserInfoBy(name,type) {

  return OnlineServiceNative.getUserInfoBy(name,type);
}

function loginWithPhoneNumber(phoneNumber,password){
  if (phoneNumber === undefined || password === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.loginWithPhone(phoneNumber, password);
}

function logout() {
  return OnlineServiceNative.logout();
}

function getDataList(currentPage, pageSize) {
  if (currentPage === undefined ||
    pageSize === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getDataList(currentPage, pageSize);
}

function getServiceList(currentPage, pageSize) {
  if (currentPage === undefined ||
    pageSize === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getServiceList(currentPage, pageSize);
}

function registerWithEmail(email, nickname, password) {
  if (email === undefined ||
    nickname === undefined ||
    password === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.registerWithEmail(email, nickname, password);
}

function registerWithPhone(phoneNumber, smsVerifyCode, nickname, password) {
  if (phoneNumber === undefined ||
    smsVerifyCode === undefined ||
    nickname === undefined ||
    password === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.registerWithPhone(phoneNumber, smsVerifyCode, nickname, password);
}

function sendSMSVerifyCode(phoneNumber) {
  if (phoneNumber === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.sendSMSVerifyCode(phoneNumber);
}

function verifyCodeImage() {
  return OnlineServiceNative.verifyCodeImage();
}

function retrievePassword(account, verifyCode, isPhoneAccount) {
  if (account === undefined ||
    verifyCode === undefined ||
    isPhoneAccount === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePassword(account, verifyCode, isPhoneAccount);
}

function retrievePasswordSecond(firstResult) {
  if (firstResult === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePasswordSecond(firstResult);
}

function retrievePasswordThrid(secondResult, safeCode) {
  if (secondResult === undefined ||
    safeCode === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePasswordThrid(secondResult, safeCode);
}

function retrievePasswordFourth(thridResult, newPassword) {
  if (thridResult === undefined ||
    newPassword === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePasswordFourth(thridResult, newPassword);
}

function deleteData(dataName) {
  if (dataName === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.deleteData(dataName);
}
function deleteDataWithDataId(dataNameId) {
  if (dataNameId === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.deleteDataWithDataId(dataNameId);
}

function deleteService(serviceName) {
  if (serviceName === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.deleteServiceWithServiceName(serviceName);
}
function deleteServiceWithDataName(dataName) {
  if (dataName === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.deleteService(dataName);
}
function deleteServiceWithServiceId(serviceId) {
  if (serviceId === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.deleteServiceWithServiceId(serviceId);
}
function changeDataVisibility(dataName, isPublic) {
  if (dataName === undefined ||
    isPublic === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.changeDataVisibility(dataName, isPublic);
}

function changeDataVisibilityWithDataId(dataNameId, isPublic) {
  if (dataNameId === undefined ||
    isPublic === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.changeDataVisibilityWithDataId(dataNameId, isPublic);
}

function changeServiceVisibility(serviceName, isPublic) {
  if (serviceName === undefined ||
    isPublic === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.changeServiceVisibility(serviceName, isPublic);
}

function changeServiceVisibilityWithServiceId(serviceNameId, isPublic) {
  if (serviceNameId === undefined ||
    isPublic === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.changeServiceVisibilityWithServiceId(serviceNameId, isPublic);
}

function getAllUserDataList(currentPage) {
  if (currentPage === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getAllUserDataList(currentPage);
}

function getAllUserSymbolLibList(currentPage) {
  if (currentPage === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getAllUserSymbolLibList(currentPage);
}

function publishService(dataName) {
  if (dataName === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.publishService(dataName);
}
function publishServiceWithDataId(dataId) {
  if (dataId === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.publishServiceWithDataId(dataId);
}
function modifyPassword(oldPassword, newPassword) {
  return OnlineServiceNative.modifyPassword(oldPassword, newPassword);
}
function modifyNickname(nickname) {
  return OnlineServiceNative.modifyNickname(nickname);
}
function sendVerficationCode(phoneNumber) {
  return OnlineServiceNative.sendVerficationCode(phoneNumber);
}
function bindPhoneNumber(phoneNumber, verifyCode) {
  return OnlineServiceNative.bindPhoneNumber(phoneNumber, verifyCode);
}
function bindEmail(email) {
  return OnlineServiceNative.bindEmail(email);
}
function getSuperMapKnown(){
  return OnlineServiceNative.getSuperMapKnown()
}

export default {
  init,
  uploadFile,
  downloadFile,
  objCallBack,
  login,
  logout,
  getDataList,
  getServiceList,
  registerWithEmail,
  registerWithPhone,
  sendSMSVerifyCode,
  verifyCodeImage,
  retrievePassword,
  retrievePasswordSecond,
  retrievePasswordThrid,
  retrievePasswordFourth,
  getAllUserDataList,
  getAllUserSymbolLibList,
  publishService,
  getAndroidSessionID,
  cacheImage,
  loginWithPhoneNumber,
  deleteData,
  deleteDataWithDataId,
  deleteService,
  deleteServiceWithDataName,
  deleteServiceWithServiceId,
  changeDataVisibility,
  changeServiceVisibility,
  changeServiceVisibilityWithServiceId,
  changeDataVisibilityWithDataId,
  downloadFileWithDataId,
  downloadFileWithCallBack,
  publishServiceWithDataId,
  syncAndroidCookie,
  removeCookie,
  cancelDownload,
  modifyPassword,
  modifyNickname,
  sendVerficationCode,
  bindPhoneNumber,
  bindEmail,
  getUserInfo,
  getUserInfoBy,
  getSuperMapKnown,
}