/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: AI识别控制类
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"
let SAIDetectView = NativeModules.SAIDetectView

//初始化
initAIDetect = (language) => {
  try {
    return SAIDetectView.initAIDetect(language)
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
setDetectInfo = (params) => {
  try {
    return SAIDetectView.setDetectInfo(params)
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
isPolymerize = () => {
  try {
    return SAIDetectView.isPolymerize()
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

// 是否开启跟踪计数
getIsCountTrackedMode = () => {
  try {
    return SAIDetectView.getIsCountTrackedMode()
  } catch (error) {
    console.error(error)
  }
}

//保存预览图
savePreviewBitmap = () => {
  try {
    return SAIDetectView.savePreviewBitmap()
  } catch (error) {
    console.error(error)
  }
}

//设置POI投射是否开启
setProjectionModeEnable = (value) => {
  try {
    return SAIDetectView.setProjectionModeEnable(value)
  } catch (error) {
    console.error(error)
  }
}

//设置POI是否避让
setPOIOverlapEnable = (value) => {
  try {
    return SAIDetectView.setPOIOverlapEnable(value)
  } catch (error) {
    console.error(error)
  }
}

//设置是否开启某个识别类型
setDetectItemEnable = (name, value) => {
  try {
    return SAIDetectView.setDetectItemEnable(name, value)
  } catch (error) {
    console.error(error)
  }
}

//是否绘制检测名称
setDrawTileEnable = (value) => {
  try {
    return SAIDetectView.setDrawTileEnable(value)
  } catch (error) {
    console.error(error)
  }
}

//是否绘制检测的可信度
setDrawConfidenceEnable = (value) => {
  try {
    return SAIDetectView.setDrawConfidenceEnable(value)
  } catch (error) {
    console.error(error)
  }
}

//是否统一颜色
setSameColorEnable = (value) => {
  try {
    return SAIDetectView.setSameColorEnable(value)
  } catch (error) {
    console.error(error)
  }
}

//设置统一的颜色值
setSameColor = (value) => {
  try {
    return SAIDetectView.setSameColor(value)
  } catch (error) {
    console.error(error)
  }
}

//设置识别框的宽度
setStrokeWidth = (value) => {
  try {
    return SAIDetectView.setStrokeWidth(value)
  } catch (error) {
    console.error(error)
  }
}

isProjectionModeEnable = () => {
  try {
    return SAIDetectView.isProjectionModeEnable()
  } catch (error) {
    console.error(error)
  }
}

isPOIOverlapEnable = () => {
  try {
    return SAIDetectView.isPOIOverlapEnable()
  } catch (error) {
    console.error(error)
  }
}

isDrawTileEnable = () => {
  try {
    return SAIDetectView.isDrawTileEnable()
  } catch (error) {
    console.error(error)
  }
}

isDrawConfidenceEnable = () => {
  try {
    return SAIDetectView.isDrawConfidenceEnable()
  } catch (error) {
    console.error(error)
  }
}

checkIfSensorsAvailable = () => {
  try {
    return SAIDetectView.checkIfSensorsAvailable()
  } catch (error) {
    console.error(error)
  }
}

checkIfCameraAvailable = () => {
  try {
    return SAIDetectView.checkIfCameraAvailable()
  } catch (error) {
    console.error(error)
  }
}

checkIfAvailable = () => {
  try {
    return SAIDetectView.checkIfAvailable()
  } catch (error) {
    console.error(error)
  }
}

getDetectInfo = () => {
  try {
    return SAIDetectView.getDetectInfo()
  } catch (error) {
    console.error(error)
  }
}

startCamera = () => {
  try {
    return SAIDetectView.startCamera()
  } catch (error) {
    console.error(error)
  }
}

clearClickAIRecognition = () => {
  try {
    return SAIDetectView.clearClickAIRecognition()
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
  isPolymerize,
  setPolymerizeThreshold,
  setPolySize,
  getTrackedCount,
  resetTrackedCount,
  startCountTrackedObjs,
  stopCountTrackedObjs,
  getIsCountTrackedMode,
  savePreviewBitmap,
  setProjectionModeEnable,
  setPOIOverlapEnable,
  setDetectItemEnable,
  setDrawTileEnable,
  setDrawConfidenceEnable,
  setSameColorEnable,
  setSameColor,
  setStrokeWidth,
  isProjectionModeEnable,
  isPOIOverlapEnable,
  isDrawTileEnable,
  isDrawConfidenceEnable,
  checkIfSensorsAvailable,
  checkIfCameraAvailable,
  checkIfAvailable,
  getDetectInfo,
  startCamera,
  clearClickAIRecognition,
}