/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: 违章采集控制类
 **********************************************************************************/
import {
  NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform,
} from "react-native"
import { EventConst } from '../constains/index'

let SIllegallyParkView = NativeModules.SIllegallyParkView
const nativeEvt = new NativeEventEmitter(SIllegallyParkView)

/**
 * 添加多媒体采集图片点击回调事件
 * @param handler
 */
function setIllegallyParkListener(handlers) {
  try {
    if (handlers && typeof handlers.callback === 'function'){
      if(Platform.OS === 'ios'){
        nativeEvt.addListener(EventConst.ILLEGALLYPARK, function (e) {
          handlers.callback(e);
        });
      }else {
        DeviceEventEmitter.addListener(EventConst.ILLEGALLYPARK, function (e) {
          handlers.callback(e);
        });
      }
    }

  } catch (error) {
    console.error(error);
  }
}

onStart = () => {
  try {
    return SIllegallyParkView.onStart()
  } catch (error) {
    console.error(error)
  }
}

onStop = () => {
  try {
    return SIllegallyParkView.onStop()
  } catch (error) {
    console.error(error)
  }
}

onDestroy = () => {
  try {
    return SIllegallyParkView.onDestroy()
  } catch (error) {
    console.error(error)
  }
}

export default {
  setIllegallyParkListener,
  onStart,
  onStop,
  onDestroy,
}