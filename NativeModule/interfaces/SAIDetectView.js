/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: AI识别
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"
let SAIDetectView = NativeModules.SAIDetectView

initAIDetect = () => {
  try {
    return SAIDetectView.initAIDetect()
  } catch (error) {
    console.error(error)
  }
}

startDetect = () => {
  try {
    return SAIDetectView.startDetect()
  } catch (error) {
    console.error(error)
  }
}

export default {
  initAIDetect,
  startDetect,
}