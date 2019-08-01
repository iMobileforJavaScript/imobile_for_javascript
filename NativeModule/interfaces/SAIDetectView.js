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

//初始化
initAIDetect = () => {
  try {
    return SAIDetectView.initAIDetect()
  } catch (error) {
    console.error(error)
  }
}

//开始识别
startDetect = () => {
  try {
    return SAIDetectView.startDetect()
  } catch (error) {
    console.error(error)
  }
}

//停止识别
pauseDetect = () => {
  try {
    return SAIDetectView.pauseDetect()
  } catch (error) {
    console.error(error)
  }
}

//停止识别,回收资源
dispose = () => {
  try {
    return SAIDetectView.dispose()
  } catch (error) {
    console.error(error)
  }
}

//设置模型文件等信息,先于初始化调用
setDetectInfo = (modelName, lableName) => {
  try {
    return SAIDetectView.setDetectInfo(modelName, lableName)
  } catch (error) {
    console.error(error)
  }
}

//设置识别类型
setDetectArrayToUse = (array) => {
  try {
    return SAIDetectView.setDetectArrayToUse(array)
  } catch (error) {
    console.error(error)
  }
}

//是否正在识别
isDetect = () => {
  try {
    return SAIDetectView.isDetect()
  } catch (error) {
    console.error(error)
  }
}

//获取当前设置的识别类型
getDetectArrayToUse = () => {
  try {
    return SAIDetectView.getDetectArrayToUse()
  } catch (error) {
    console.error(error)
  }
}

//获取所有可用的识别分类
getAllDetectArrayProvide = () => {
  try {
    return SAIDetectView.getAllDetectArrayProvide()
  } catch (error) {
    console.error(error)
  }
}

//清除识别对象
clearDetectObjects = () => {
  try {
    return SAIDetectView.clearDetectObjects()
  } catch (error) {
    console.error(error)
  }
}

//设置是否聚合模式
setIsPolymerize = (value) => {
  try {
    return SAIDetectView.setIsPolymerize(value)
  } catch (error) {
    console.error(error)
  }
}

//返回是否聚合模式
isPolynerize = () => {
  try {
    return SAIDetectView.isPolynerize()
  } catch (error) {
    console.error(error)
  }
}

//设置聚合模式阀值(int)
setPolymerizeThreshold = (x, y) => {
  try {
    return SAIDetectView.setPolymerizeThreshold(x, y)
  } catch (error) {
    console.error(error)
  }
}

//设置聚合模式宽高(int)
setPolySize = (width, height) => {
  try {
    return SAIDetectView.setPolySize(width, height)
  } catch (error) {
    console.error(error)
  }
}

//获取当前跟踪计数结果
getTrackedCount = () => {
  try {
    return SAIDetectView.getTrackedCount()
  } catch (error) {
    console.error(error)
  }
}

//重置跟踪计数结果
resetTrackedCount = () => {
  try {
    return SAIDetectView.resetTrackedCount()
  } catch (error) {
    console.error(error)
  }
}

// 开始跟踪计数
startCountTrackedObjs = () => {
  try {
    return SAIDetectView.startCountTrackedObjs()
  } catch (error) {
    console.error(error)
  }
}

// 停止跟踪计数
stopCountTrackedObjs = () => {
  try {
    return SAIDetectView.stopCountTrackedObjs()
  } catch (error) {
    console.error(error)
  }
}

//
savePreviewBitmap = () => {
  try {
    return SAIDetectView.savePreviewBitmap()
  } catch (error) {
    console.error(error)
  }
}

export default {
  initAIDetect,
  startDetect,
  pauseDetect,
  dispose,
  setDetectInfo,
  setDetectArrayToUse,
  isDetect,
  getDetectArrayToUse,
  getAllDetectArrayProvide,
  clearDetectObjects,
  setIsPolymerize,
  isPolynerize,
  setPolymerizeThreshold,
  setPolySize,
  getTrackedCount,
  resetTrackedCount,
  startCountTrackedObjs,
  stopCountTrackedObjs,
  savePreviewBitmap,
}