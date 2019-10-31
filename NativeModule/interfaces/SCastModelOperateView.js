/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: AR投放,查看,操纵
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"

let SCastModelOperateView = NativeModules.SCastModelOperateView

onResume = () => {
  try {
    return SCastModelOperateView.onResume()
  } catch (error) {
    console.error(error)
  }
}

onPause = () => {
  try {
    return SCastModelOperateView.onPause()
  } catch (error) {
    console.error(error)
  }
}

onDestroy = () => {
  try {
    return SCastModelOperateView.onDestroy()
  } catch (error) {
    console.error(error)
  }
}

export default {
  onResume,
  onPause,
  onDestroy,
}