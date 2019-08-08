import { NativeModules, Platform, NativeEventEmitter, DeviceEventEmitter} from 'react-native';
import { EventConst } from '../../constains'
let IPortalServiceNative = NativeModules.SIPortalService;
const callBackIOS = new NativeEventEmitter(IPortalServiceNative)

function init() {
    if(Platform.OS === 'ios') {
        return IPortalServiceNative.init()
    }
}

function login (serverUrl, userName, password, remember) {
    return IPortalServiceNative.login(serverUrl, userName, password, remember)
}

function logout () {
    IPortalServiceNative.logout()
}

function getIPortalCookie() {
    if(Platform.OS === 'android') {
        return IPortalServiceNative.getIPortalCookie()
    }
}

function getMyAccount() {
    return IPortalServiceNative.getMyAccount()
}

function getMyDatas(page, pageSize) {
    return IPortalServiceNative.getMyDatas(page, pageSize)
}

function deleteMyData(id) {
    return IPortalServiceNative.deleteMyData(id)
}

let  uploadingFileListener
function uploadData (path, fileName, cb) {
  uploadingFileListener && uploadingFileListener.remove()
  if (Platform.OS === 'ios') {
    uploadingFileListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (progress) {
        cb(progress)
    })
  } else {
    uploadingFileListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADING, function (progress) {
        cb(progress)
      })
  }
  
  return IPortalServiceNative.uploadData(path, fileName)
}

let downloadListener
function downloadMyData(path, id, cb) {
    downloadListener && downloadListener.remove()
    if(Platform.OS === 'android') {
        downloadListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (progress) {
            cb(progress);
          })
    } else {
        downloadListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (progress) {
            cb(progress);
          })
    }
    return IPortalServiceNative.downloadMyData(path, id)
}

function downloadMyDataByName(path, name, cb) {
    downloadListener && downloadListener.remove()
    if(Platform.OS === 'android') {
        downloadListener = DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (progress) {
            cb(progress);
          })
    } else {
        downloadListener = callBackIOS.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (progress) {
            cb(progress);
          })
    }
    return IPortalServiceNative.downloadMyDataByName(path, name)
}

function getMyServices(page, pageSize) {
    return IPortalServiceNative.getMyServices(page, pageSize)
}

function deleteMyService(id) {
    return IPortalServiceNative.deleteMyService(id)
}

function publishService(id) {
    if(Platform.OS === 'ios') {
    return IPortalServiceNative.publishService(id)
    }
}

function setServicesShareConfig(id, isPublic) {
    if(Platform.OS === 'ios') {
    return IPortalServiceNative.setServicesShareConfig(id, isPublic)
    }
}
export default {
    init,
    login,
    logout,
    getIPortalCookie,
    getMyAccount,
    getMyDatas,
    getMyServices,
    deleteMyData,
    deleteMyService,
    publishService,
    setServicesShareConfig,
    uploadData,
    downloadMyData,
    downloadMyDataByName,
  }