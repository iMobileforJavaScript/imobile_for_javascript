import {
  NativeModules,
  DeviceEventEmitter,
  NativeEventEmitter,
  Platform,
} from 'react-native'
import { EventConst } from '../../constains/index'
let Analyst = NativeModules.SAnalyst
const nativeEvt = new NativeEventEmitter(Analyst)
const SearchMode = Analyst.SearchMode
const InterpolationAlgorithmType = Analyst.InterpolationAlgorithmType
const PixelFormat = Analyst.PixelFormat
const VariogramMode = Analyst.VariogramMode

/*********************************************** 缓冲分析 *************************************************/

/**
 * 缓冲区分析
 * @param sourceData            { datasource: string, dataset: string }
 * @param resultData            { datasource: string, dataset: string }
 * @param bufferParameter       { endType: string, leftDistance: number, rightDistance: number }
 * @param isUnion               boolean
 * @param isAttributeRetained   boolean
 * @param optionParameter       { showResult: boolean, geoStyle: object }
 * @returns {Promise.<void>}
 */
async function createBuffer (sourceData = {}, resultData = {}, bufferParameter, isUnion, isAttributeRetained, optionParameter) {
  return Analyst.createBuffer(sourceData, resultData, bufferParameter, isUnion, isAttributeRetained, optionParameter)
}

/**
 * 多重缓冲区分析
 * @param sourceData
 * @param resultData
 * @param bufferRadiuses
 * @param bufferRadiusUnit
 * @param semicircleSegment
 * @param isUnion
 * @param isAttributeRetained
 * @param isRing
 * @param optionParameter
 * @returns {Promise.<void>}
 */
async function createMultiBuffer (sourceData = {}, resultData = {}, bufferRadiuses, bufferRadiusUnit, semicircleSegment, isUnion, isAttributeRetained, isRing, optionParameter) {
  return Analyst.createMultiBuffer(sourceData, resultData, bufferRadiuses, bufferRadiusUnit, semicircleSegment, isUnion, isAttributeRetained, isRing, optionParameter)
}

/*********************************************** 叠加分析 *************************************************/
/** 叠加分析-裁剪 **/
async function clip (sourceData = {}, targetData = {}, resultData = {}, optionParameter = {}) {
  if (optionParameter.showResult === undefined) {
    // 默认展示结果
    optionParameter.showResult = true
  }
  return Analyst.clip(sourceData, targetData, resultData, optionParameter)
}

/** 叠加分析-擦除 **/
async function erase (sourceData = {}, targetData = {}, resultData = {}, optionParameter = {}) {
  if (optionParameter.showResult === undefined) {
    // 默认展示结果
    optionParameter.showResult = true
  }
  return Analyst.erase(sourceData, targetData, resultData, optionParameter)
}

/** 叠加分析-同一 **/
async function identity (sourceData = {}, targetData = {}, resultData = {}, optionParameter = {}) {
  if (optionParameter.showResult === undefined) {
    // 默认展示结果
    optionParameter.showResult = true
  }
  return Analyst.identity(sourceData, targetData, resultData, optionParameter)
}

/** 叠加分析-相交 **/
async function intersect (sourceData = {}, targetData = {}, resultData = {}, optionParameter = {}) {
  if (optionParameter.showResult === undefined) {
    // 默认展示结果
    optionParameter.showResult = true
  }
  return Analyst.intersect(sourceData, targetData, resultData, optionParameter)
}

/** 叠加分析-合并 **/
async function union (sourceData = {}, targetData = {}, resultData = {}, optionParameter = {}) {
  if (optionParameter.showResult === undefined) {
    // 默认展示结果
    optionParameter.showResult = true
  }
  return Analyst.union(sourceData, targetData, resultData, optionParameter)
}

/** 叠加分析-更新 **/
async function update (sourceData = {}, targetData = {}, resultData = {}, optionParameter = {}) {
  if (optionParameter.showResult === undefined) {
    // 默认展示结果
    optionParameter.showResult = true
  }
  return Analyst.update(sourceData, targetData, resultData, optionParameter)
}

/** 叠加分析-对称差 **/
async function xOR (sourceData = {}, targetData = {}, resultData = {}, optionParameter = {}) {
  if (optionParameter.showResult === undefined) {
    // 默认展示结果
    optionParameter.showResult = true
  }
  return Analyst.xOR(sourceData, targetData, resultData, optionParameter)
}

/*********************************************** 在线分析 *************************************************/

let onlineAnalystListener
let onlineAnalystHandler
function setOnlineAnalystListener (handler) {
  onlineAnalystHandler = handler
  if (onlineAnalystListener) return
  if (Platform.OS === 'ios') {
    onlineAnalystListener = nativeEvt.addListener(EventConst.ONLINE_ANALYST_RESULT, function (e) {
      if (onlineAnalystHandler && typeof onlineAnalystHandler === 'function') {
        onlineAnalystHandler(e)
        removeOnlineAnalystListener()
      }
    })
  } else {
    onlineAnalystListener = DeviceEventEmitter.addListener(EventConst.ONLINE_ANALYST_RESULT, function (e) {
      if (onlineAnalystHandler && typeof onlineAnalystHandler === 'function') {
        onlineAnalystHandler(e)
        removeOnlineAnalystListener()
      }
    })
  }
}

function removeOnlineAnalystListener () {
  try {
    onlineAnalystHandler = null
    if (onlineAnalystListener) {
      onlineAnalystListener.remove()
      onlineAnalystListener = null
    }
  } catch (e) {
  
  }
}

/**
 * 获取在线分析数据
 * @param ip
 * @param port
 * @param type  获取数据类型 0:源数据 1:密度数据集数据 2:点聚合数据集数据
 * @returns {Promise.<void>}
 */
async function getOnlineAnalysisData (ip, port, type = 0) {
  if (!ip || !port) return
  let data = await Analyst.getOnlineAnalysisData(ip, port, type)
  return JSON.parse(data)
}
/** 在线分析-密度分析 **/
async function densityOnline (serverData = {}, analysisData = {}, handler) {
  setOnlineAnalystListener(handler)
  return Analyst.densityOnline(serverData, analysisData)
}
/** 在线分析-点聚合分析 **/
async function aggregatePointsOnline (serverData = {}, analysisData = {}, handler) {
  setOnlineAnalystListener(handler)
  return Analyst.aggregatePointsOnline(serverData, analysisData)
}

/** 在线分析-泰森多边形 **/
async function thiessenAnalyst (sourceData = {}, resultData = {}, option = {}) {
  return Analyst.thiessenAnalyst(sourceData, resultData, option)
}

/*********************************************** 插值分析 *************************************************/
function interpolate (sourceData = {}, resultData = {}, paramter = {}, field = '', scale = 1, pixelFormat) {
  return Analyst.interpolate(sourceData, resultData, paramter, field, scale, pixelFormat)
}

export default {
  // 缓冲分析
  createBuffer,
  createMultiBuffer,
  
  // 叠加分析
  clip,
  erase,
  identity,
  intersect,
  union,
  update,
  xOR,
  
  // 在线分析
  getOnlineAnalysisData,
  densityOnline,
  aggregatePointsOnline,
  
  // 临近分析
  thiessenAnalyst,
  
  // 插值分析
  interpolate,
  
  // 常量
  SearchMode,
  InterpolationAlgorithmType,
  PixelFormat,
  VariogramMode,
}