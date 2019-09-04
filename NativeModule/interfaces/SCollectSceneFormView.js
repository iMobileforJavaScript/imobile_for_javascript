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

startRecording = () => {
  try {
    return SCollectSceneFormView.startRecording()
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

initSceneFormView = (datasourceAlias, datasetName, language, UDBpath) => {
  try {
    return SCollectSceneFormView.initSceneFormView(datasourceAlias, datasetName, language, UDBpath)
  } catch (error) {
    console.error(error)
  }
}

saveData = (name) => {
  try {
    return SCollectSceneFormView.saveData(name)
  } catch (error) {
    console.error(error)
  }
}

loadData = (ID) => {
  try {
    return SCollectSceneFormView.loadData(ID)
  } catch (error) {
    console.error(error)
  }
}

clearData = () => {
  try {
    return SCollectSceneFormView.clearData()
  } catch (error) {
    console.error(error)
  }
}

getHistoryData = () => {
  try {
    return SCollectSceneFormView.getHistoryData()
  } catch (error) {
    console.error(error)
  }
}

export default {
  startRecording,
  stopRecording,
  setArSceneViewVisible,
  onDestroy,
  initSceneFormView,
  saveData,
  loadData,
  clearData,
  getHistoryData,
}