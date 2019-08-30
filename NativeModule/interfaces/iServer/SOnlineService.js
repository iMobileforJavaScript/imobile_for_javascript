import { NativeModules, Platform, NativeEventEmitter, DeviceEventEmitter } from 'react-native'
import { EventConst } from '../../constains'
let OnlineServiceNative = NativeModules.SOnlineService
/*获取ios原生层的回调*/
const callBackIOS = new NativeEventEmitter(OnlineServiceNative)
let objDownloadCallBackResult
let bIsFirstDownload = true
function init () {
  OnlineServiceNative.init()
}
/** 仅支持android*/
function getAndroidSessionID () {
  if (Platform.OS === 'android') {
    return OnlineServiceNative.getSessionID()
  }
  return 'undefined'
}
/** 仅支持android*/
function syncAndroidCookie () {
  if (Platform.OS === 'android') {
    return OnlineServiceNative.syncCookie('https://www.supermapol.com/')
  }
  return 'undefined'
}

/** 仅支持android*/
function cacheImage (imageUrl, saveImagePath) {
  if (Platform.OS === 'android') {
    return OnlineServiceNative.cacheImage(imageUrl, saveImagePath)
  }
  return '不支持ios的缓存'
}
function removeCookie () {
  return OnlineServiceNative.removeCookie()
}

function objCallBack () {
  return new NativeEventEmitter(OnlineServiceNative)
}

let uploadFileListener, uploadingFileListener
function uploadFile (path, dataName, handler) {
  uploadFileListener && uploadFileListener.remove()
  uploadingFileListener && uploadingFileListener.remove()
  if (Platform.OS === 'ios' && handler) {
    if (typeof handler.onProgress === 'function') {
      uploadingFileListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (obj) {
        handler.onProgress(obj.progress)
      })
    }
    if (typeof handler.onResult === 'function') {
      uploadFileListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (value) {
        handler.onResult(value)
      })
    }
  } else {
    if (typeof handler.onProgress === 'function') {
      uploadingFileListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (progress) {
        handler.onProgress(progress)
      })
    }
    if (typeof handler.onResult === 'function' && handler) {
      uploadFileListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (result) {
        handler.onResult(result)
      })
    }
  }
  
  OnlineServiceNative.upload(path, dataName)
}

function uploadFilebyType (path, dataName,dataType, handler) {
  uploadFileListener && uploadFileListener.remove()
  uploadingFileListener && uploadingFileListener.remove()
  if (Platform.OS === 'ios' && handler) {
    if (typeof handler.onProgress === 'function') {
      uploadingFileListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (obj) {
        handler.onProgress(obj.progress)
      })
    }
    if (typeof handler.onResult === 'function') {
      uploadFileListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (value) {
        handler.onResult(value)
      })
    }
  } else {
    if (typeof handler.onProgress === 'function') {
      uploadingFileListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (progress) {
        handler.onProgress(progress)
      })
    }
    if (typeof handler.onResult === 'function' && handler) {
      uploadFileListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (result) {
        handler.onResult(result)
      })
    }
  }
  
  OnlineServiceNative.uploadByType(path, dataName, dataType)
}

let downloadingListener
let downloadedListener
let downloadfailureListener
function downloadFileWithCallBack(path, dataName, handler) {
  downloadingListener && downloadingListener.remove()
  downloadedListener && downloadedListener.remove()
  downloadfailureListener && downloadfailureListener.remove()
  if (Platform.OS === 'ios' && handler) {
    if (typeof handler.onProgress === 'function') {
      downloadingListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (obj) {
        handler.onProgress(obj.progress);
      })
    }
    if (typeof handler.onResult === 'function') {
      downloadedListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED, function (value) {
        handler.onResult(value);
      })
    }
    if (typeof handler.onResult === 'function') {
      downloadfailureListener =  callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (value) {
        handler.onResult(value);
      })
    }
  }else{
    if (typeof handler.onProgress === 'function'&& handler) {
      downloadingListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (progress) {
        handler.onProgress(progress);
      })
    }
    if (typeof handler.onResult === 'function'&& handler) {
      downloadedListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED, function (result) {
        handler.onResult(result);
      })
    }
    if (typeof handler.onResult === 'function'&& handler) {
      downloadfailureListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (result) {
        handler.onResult(result);
      })
    }
  }
  OnlineServiceNative.download(path, dataName)
}

function downloadFile (path, onlineDataName) {
  OnlineServiceNative.download(path, onlineDataName)
}
function cancelDownload () {
  if (Platform.OS === 'ios') {
    OnlineServiceNative.cancelDownload()
  }
}
function downloadFileWithDataId (path, dataNameId) {
  OnlineServiceNative.downloadWithDataId(path, dataNameId)
}
function login (userName, password) {
  if (userName === undefined || password === undefined) {
    return
  }
  return OnlineServiceNative.login(userName, password)
}

function getUserInfo () {
  
  return OnlineServiceNative.getUserInfo()
}

function getUserInfoBy (name, type) {
  
  return OnlineServiceNative.getUserInfoBy(name, type)
}

function loginWithPhoneNumber (phoneNumber, password) {
  if (phoneNumber === undefined || password === undefined) {
    return
  }
  return OnlineServiceNative.loginWithPhone(phoneNumber, password)
}

function logout () {
  return OnlineServiceNative.logout()
}

function getDataList (currentPage, pageSize) {
  if (currentPage === undefined ||
    pageSize === undefined) {
    return
  }
  return OnlineServiceNative.getDataList(currentPage, pageSize)
}

function getServiceList (currentPage, pageSize) {
  if (currentPage === undefined ||
    pageSize === undefined) {
    return
  }
  return OnlineServiceNative.getServiceList(currentPage, pageSize)
}

function registerWithEmail (email, nickname, password) {
  if (email === undefined ||
    nickname === undefined ||
    password === undefined) {
    return
  }
  return OnlineServiceNative.registerWithEmail(email, nickname, password)
}

function registerWithPhone (phoneNumber, smsVerifyCode, nickname, password) {
  if (phoneNumber === undefined ||
    smsVerifyCode === undefined ||
    nickname === undefined ||
    password === undefined) {
    return
  }
  return OnlineServiceNative.registerWithPhone(phoneNumber, smsVerifyCode, nickname, password)
}

function sendSMSVerifyCode (phoneNumber) {
  if (phoneNumber === undefined) {
    return
  }
  return OnlineServiceNative.sendSMSVerifyCode(phoneNumber)
}

function verifyCodeImage () {
  return OnlineServiceNative.verifyCodeImage()
}

function retrievePassword (account, verifyCode, isPhoneAccount) {
  if (account === undefined ||
    verifyCode === undefined ||
    isPhoneAccount === undefined) {
    return
  }
  return OnlineServiceNative.retrievePassword(account, verifyCode, isPhoneAccount)
}

function retrievePasswordSecond (firstResult) {
  if (firstResult === undefined) {
    return
  }
  return OnlineServiceNative.retrievePasswordSecond(firstResult)
}

function retrievePasswordThrid (secondResult, safeCode) {
  if (secondResult === undefined ||
    safeCode === undefined) {
    return
  }
  return OnlineServiceNative.retrievePasswordThrid(secondResult, safeCode)
}

function retrievePasswordFourth (thridResult, newPassword) {
  if (thridResult === undefined ||
    newPassword === undefined) {
    return
  }
  return OnlineServiceNative.retrievePasswordFourth(thridResult, newPassword)
}

function deleteData (dataName) {
  if (dataName === undefined) {
    return
  }
  return OnlineServiceNative.deleteData(dataName)
}
function deleteDataWithDataId (dataNameId) {
  if (dataNameId === undefined) {
    return
  }
  return OnlineServiceNative.deleteDataWithDataId(dataNameId)
}

function deleteService (serviceName) {
  if (serviceName === undefined) {
    return
  }
  return OnlineServiceNative.deleteServiceWithServiceName(serviceName)
}
function deleteServiceWithDataName (dataName) {
  if (dataName === undefined) {
    return
  }
  return OnlineServiceNative.deleteService(dataName)
}
function deleteServiceWithServiceId (serviceId) {
  if (serviceId === undefined) {
    return
  }
  return OnlineServiceNative.deleteServiceWithServiceId(serviceId)
}
function changeDataVisibility (dataName, isPublic) {
  if (dataName === undefined ||
    isPublic === undefined) {
    return
  }
  return OnlineServiceNative.changeDataVisibility(dataName, isPublic)
}

function changeDataVisibilityWithDataId (dataNameId, isPublic) {
  if (dataNameId === undefined ||
    isPublic === undefined) {
    return
  }
  return OnlineServiceNative.changeDataVisibilityWithDataId(dataNameId, isPublic)
}

function changeServiceVisibility (serviceName, isPublic) {
  if (serviceName === undefined ||
    isPublic === undefined) {
    return
  }
  return OnlineServiceNative.changeServiceVisibility(serviceName, isPublic)
}

function changeServiceVisibilityWithServiceId (serviceNameId, isPublic) {
  if (serviceNameId === undefined ||
    isPublic === undefined) {
    return
  }
  return OnlineServiceNative.changeServiceVisibilityWithServiceId(serviceNameId, isPublic)
}

function getAllUserDataList (currentPage) {
  if (currentPage === undefined) {
    return
  }
  return OnlineServiceNative.getAllUserDataList(currentPage)
}

function getAllUserSymbolLibList (currentPage) {
  if (currentPage === undefined) {
    return
  }
  return OnlineServiceNative.getAllUserSymbolLibList(currentPage)
}

function publishService (dataName) {
  if (dataName === undefined) {
    return
  }
  return OnlineServiceNative.publishService(dataName)
}
function publishServiceWithDataId (dataId) {
  if (dataId === undefined) {
    return
  }
  return OnlineServiceNative.publishServiceWithDataId(dataId)
}
function modifyPassword (oldPassword, newPassword) {
  return OnlineServiceNative.modifyPassword(oldPassword, newPassword)
}
function modifyNickname (nickname) {
  return OnlineServiceNative.modifyNickname(nickname)
}
function sendVerficationCode (phoneNumber) {
  return OnlineServiceNative.sendVerficationCode(phoneNumber)
}
function bindPhoneNumber (phoneNumber, verifyCode) {
  return OnlineServiceNative.bindPhoneNumber(phoneNumber, verifyCode)
}
function bindEmail (email) {
  return OnlineServiceNative.bindEmail(email)
}
function getSuperMapKnown () {
  return OnlineServiceNative.getSuperMapKnown()
}

let reverseGeocodingListener
function reverseGeocoding (longitude, latitude, handler) {
  
  reverseGeocodingListener && reverseGeocodingListener.remove()
  if (typeof handler.onResult === 'function' && handler) {
    if (Platform.OS === 'ios') {
      
      reverseGeocodingListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_REVERSEGEOCODING, function (result) {
        handler.onResult(result)
      })
    } else {
      reverseGeocodingListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_REVERSEGEOCODING, function (result) {
        handler.onResult(result)
      })
    }
  }
  return OnlineServiceNative.reverseGeocoding(longitude, latitude)
}
export default {
  init,
  uploadFile,
  uploadFilebyType,
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
  reverseGeocoding,
}