/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: 违章采集控制类
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"

let SIllegallyParkView = NativeModules.SIllegallyParkView

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
  onStart,
  onStop,
  onDestroy,
}