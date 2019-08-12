/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: AR高精度采集
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"
let SMeasureView = NativeModules.SMeasureView

addNewRecord = () => {
  try {
    return SMeasureView.addNewRecord()
  } catch (error) {
    console.error(error)
  }
}

undoDraw = () => {
  try {
    return SMeasureView.undoDraw()
  } catch (error) {
    console.error(error)
  }
}

clearAll = () => {
  try {
    return SMeasureView.clearAll()
  } catch (error) {
    console.error(error)
  }
}

setEnableSupport = (value) => {
  try {
    return SMeasureView.setEnableSupport(value)
  } catch (error) {
    console.error(error)
  }
}

isSupportedARCore = () => {
  try {
    return SMeasureView.isSupportedARCore()
  } catch (error) {
    console.error(error)
  }
}

saveDataset = (datasourceName, datasetName) => {
  try {
    return SMeasureView.saveDataset(datasourceName, datasetName)
  } catch (error) {
    console.error(error)
  }
}

export default {
  addNewRecord,
  undoDraw,
  clearAll,
  setEnableSupport,
  isSupportedARCore,
  saveDataset,
}