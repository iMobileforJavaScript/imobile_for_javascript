/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: AI分类
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"
let SAIClassifyView = NativeModules.SAIClassifyView

startPreview = () => {
  try {
    return SAIClassifyView.startPreview()
  } catch (error) {
    console.error(error)
  }
}

captureImage = () => {
  try {
    return SAIClassifyView.captureImage()
  } catch (error) {
    console.error(error)
  }
}

dispose = () => {
  try {
    return SAIClassifyView.dispose()
  } catch (error) {
    console.error(error)
  }
}

setModelName = (value) => {
  try {
    return SAIClassifyView.setModelName(value)
  } catch (error) {
    console.error(error)
  }
}

setLabelName = (value) => {
  try {
    return SAIClassifyView.setLabelName(value)
  } catch (error) {
    console.error(error)
  }
}

setInputSize = (value) => {
  try {
    return SAIClassifyView.setInputSize(value)
  } catch (error) {
    console.error(error)
  }
}

setQuant = (value) => {
  try {
    return SAIClassifyView.setQuant(value)
  } catch (error) {
    console.error(error)
  }
}

stopPreview = () => {
  try {
    return SAIClassifyView.stopPreview()
  } catch (error) {
    console.error(error)
  }
}

initAIClassify = (datasourceAlias, datasetName, language) => {
  try {
    return SAIClassifyView.initAIClassify(datasourceAlias, datasetName, language)
  } catch (error) {
    console.error(error)
  }
}

modifyLastItem = (params) => {
  try {
    return SAIClassifyView.modifyLastItem(params)
  } catch (error) {
    console.error(error)
  }
}

getImagePath = (uri) => {
  try {
    return SAIClassifyView.getImagePath(uri)
  } catch (error) {
    console.error(error)
  }
}

clearBitmap = () => {
  try {
    return SAIClassifyView.clearBitmap()
  } catch (error) {
    console.error(error)
  }
}

export default {
  startPreview,
  captureImage,
  dispose,
  setModelName,
  setLabelName,
  setInputSize,
  setQuant,
  stopPreview,
  initAIClassify,
  modifyLastItem,//编辑最新添加的对象
  getImagePath,
  clearBitmap,
}