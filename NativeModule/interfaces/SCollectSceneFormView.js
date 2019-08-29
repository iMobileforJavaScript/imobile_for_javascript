/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: AR高精度采集
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"
let SCollectSceneFormView = NativeModules.SCollectSceneFormView

startNewRecording = () => {
  try {
    return SCollectSceneFormView.startNewRecording()
  } catch (error) {
    console.error(error)
  }
}

stopRecording = () => {
  try {
    return SCollectSceneFormView.stopRecording()
  } catch (error) {
    console.error(error)
  }
}

onResume = () => {
  try {
    return SCollectSceneFormView.onResume()
  } catch (error) {
    console.error(error)
  }
}

onPause = () => {
  try {
    return SCollectSceneFormView.onPause()
  } catch (error) {
    console.error(error)
  }
}

onDestroy = () => {
  try {
    return SCollectSceneFormView.onDestroy()
  } catch (error) {
    console.error(error)
  }
}

setArSceneViewVisible = (isVisible) => {
  try {
    return SCollectSceneFormView.setArSceneViewVisible(isVisible)
  } catch (error) {
    console.error(error)
  }
}

export default {
  startNewRecording,
  stopRecording,
  setArSceneViewVisible,
  onResume,
  onPause,
  onDestroy,
}