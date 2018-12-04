import {NativeModules, Platform, NativeEventEmitter} from 'react-native';
import {EventConst} from '../../constains'
let OnlineServiceNative = NativeModules.SOnlineService;
/*获取ios原生层的回调*/
const callBackIOS = new NativeEventEmitter(OnlineServiceNative);
let objDownloadCallBackResult;
let bIsFirstDownload = true;
function init() {
  OnlineServiceNative.init();
  // if(Platform.OS === 'ios'){
  //   callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (obj) {
  //     objDownloadCallBackResult=obj;
  //   });
  // }

}

function objCallBack(){
  return callBackIOS;
}

function uploadFile(path, dataName, handler) {
  console.log("progress: 0");
  if (Platform.OS === 'ios' && handler) {
    if (typeof handler.onProgress === 'function') {
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (obj) {
        console.log("progress: " + obj.progress);
        let downloadId = obj.id;
        handler.onProgress(obj.progress);
      })
    }
    if (typeof handler.onResult === 'function') {
      callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (value) {
        handler.onResult(value);
      })
    }
  }
  OnlineServiceNative.upload(path, dataName);
}



function downloadFile(path, onlineDataName) {
  // if (Platform.OS === 'ios' && handler) {
  //   if (typeof handler.onProgress === 'function') {
  //     callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (obj) {
  //       console.log("progress:" + obj.progress);
  //       let downloadId = obj.id;
  //       if (downloadId === onlineDataName) {
  //         handler.onProgress(obj.progress);
  //       }
  //     })
  //   }
  //   if (typeof handler.onResult === 'function') {
  //     callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED, function (bResult) {
  //       handler.onResult(bResult);
  //     })
  //     callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (strErrorInfo) {
  //       handler.onResult(strErrorInfo);
  //     })
  //   }
  // }
  // else if (Platform.OS === 'android' && handler) {
  //
  // }
  OnlineServiceNative.download(path, onlineDataName);
}

async function login(userName, password) {
  if (userName === 'undefined' || password === 'undefined') {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.login(userName, password);
}

async function logout() {
  return OnlineServiceNative.logout();
}

async function getDataList(currentPage, pageSize) {
  if (currentPage === undefined ||
    pageSize === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getDataList(currentPage, pageSize);
}

async function getServiceList(currentPage, pageSize) {
  if (currentPage === undefined ||
    pageSize === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getServiceList(currentPage, pageSize);
}

async function registerWithEmail(email, nickname, password) {
  if (email === undefined ||
    nickname === undefined ||
    password === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.registerWithEmail(email, nickname, password);
}

async function registerWithPhone(phoneNumber, smsVerifyCode, nickname, password) {
  if (phoneNumber === undefined ||
    smsVerifyCode === undefined ||
    nickname === undefined ||
    password === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.registerWithPhone(phoneNumber, smsVerifyCode, nickname, password);
}

async function sendSMSVerifyCode(phoneNumber) {
  if (phoneNumber === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.sendSMSVerifyCode(phoneNumber);
}

async function verifyCodeImage() {
  return OnlineServiceNative.verifyCodeImage();
}

async function retrievePassword(account, verifyCode, isPhoneAccount) {
  if (account === undefined ||
    verifyCode === undefined ||
    isPhoneAccount === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePassword(account, verifyCode, isPhoneAccount);
}

async function retrievePasswordSecond(firstResult) {
  if (firstResult === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePasswordSecond(firstResult);
}

async function retrievePasswordThrid(secondResult, safeCode) {
  if (secondResult === undefined ||
    safeCode === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePasswordThrid(secondResult, safeCode);
}

async function retrievePasswordFourth(thridResult, newPassword) {
  if (thridResult === undefined ||
    newPassword === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.retrievePasswordFourth(thridResult, newPassword);
}

async function deleteData(dataName) {
  if (dataName === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.deleteData(dataName);
}

async function deleteService(dataName) {
  if (dataName === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.deleteService(dataName);
}

async function changeDataVisibility(dataName, isPublic) {
  if (dataName === undefined ||
    isPublic === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.changeDataVisibility(dataName, isPublic);
}

async function changeServiceVisibility(serviceName, isPublic) {
  if (serviceName === undefined ||
    isPublic === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.changeServiceVisibility(serviceName, isPublic);
}

async function getAllUserDataList(currentPage) {
  if (currentPage === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getAllUserDataList(currentPage);
}

async function getAllUserSymbolLibList(currentPage) {
  if (currentPage === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.getAllUserSymbolLibList(currentPage);
}

async function publishService(dataName) {
  if (dataName === undefined) {
    console.log('params have undefined');
    return;
  }
  return OnlineServiceNative.publishService(dataName);
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
  deleteData,
  deleteService,
  changeDataVisibility,
  changeServiceVisibility,
  getAllUserDataList,
  getAllUserSymbolLibList,
  publishService,
}