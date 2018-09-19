import { NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform } from 'react-native';
import { EventConst } from './constains'
let OS = NativeModules.JSOnlineService;
const nativeEvt = new NativeEventEmitter(OS);

//OnlinService
export default class OnlineService {

  //  Onlin 下载数据文件
  //  String path  文件保存路径
  //  String username   用户名（用于登陆online）
  //  String passworld    密码
  //  String filename     文件名称

  async download(path, filename, handlers) {
    try {
      if (Platform.OS === 'ios' && handlers) {
        if (typeof handlers.onProgress === 'function') {
          nativeEvt.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (e) {
            handlers.onProgress(e)
          })
        }
        if (typeof handlers.onComplete === 'function') {
          nativeEvt.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED, function (e) {
            handlers.onComplete(e)
          })
        }
        if (typeof handlers.onFailure === 'function') {
          nativeEvt.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (e) {
            handlers.onFailure(e)
          })
        }
      } else if (Platform.OS === 'android' && handlers) {
        if (typeof handlers.onProgress === "function") {
          DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (e) {
             handlers.onProgress(e);
          });
        }
        if (typeof handlers.onComplete === "function") {
          DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADED, function (e) {
            handlers.onComplete(e);
          });
        }
        if (typeof handlers.onFailure === "function") {
          DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, function (e) {
            handlers.onFailure(e);
          });
        }
      }
      OS.download(path, filename)
    } catch (e) {
      console.error(e);
    }
  }
  async upload(path, filename) {
    try {
      if (Platform.OS === 'ios' && handlers) {
        // if (typeof handlers.onProgress === 'function') {
        //   nativeEvt.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (e) {
        //     handlers.onProgress(e)
        //   })
        // }
        if (typeof handlers.onComplete === 'function') {
          nativeEvt.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (e) {
            handlers.onComplete(e)
          })
        }
        if (typeof handlers.onFailure === 'function') {
          nativeEvt.addListener(EventConst.ONLINE_SERVICE_UPLOADFAILURE, function (e) {
            handlers.onFailure(e)
          })
        }
      } else if (Platform.OS === 'android' && handlers) {
        // if (typeof handlers.onProgress === "function") {
        //   DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_DOWNLOADING, function (e) {
        //     handlers.onProgress(e);
        //   });
        // }
        if (typeof handlers.onComplete === "function") {
          DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADED, function (e) {
            handlers.onComplete(e);
          });
        }
        if (typeof handlers.onFailure === "function") {
          DeviceEventEmitter.addListener(EventConst.ONLINE_SERVICE_UPLOADFAILURE, function (e) {
            handlers.onFailure(e);
          });
        }
      }
      OS.upload(path, filename)
    } catch (e) {
      console.error(e);
    }
  }
  async login(username, passworld) {
    try {
      let result = await OS.login(username, passworld)
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  async logout() {
    try {
      let result = await OS.logout()
      return result;
    } catch (e) {
      console.error(e);
    }
  }
}