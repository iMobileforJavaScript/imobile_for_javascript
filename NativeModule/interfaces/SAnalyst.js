import {
  NativeModules,
} from 'react-native'

let Analyst = NativeModules.SAnalyst
// const nativeEvt = new NativeEventEmitter(Analyst);
// async function bufferAnalyst (layerName, params) {
//   try {
//     return await Analyst.analystBuffer(layerName, params)
//   } catch (e) {
//     console.error(e)
//   }
// }
//
// /**
//  * @DEPRECATED 将被下面的方法代替
//  * @param datasetPath
//  * @param clipDatasetPath
//  * @param analystType
//  * @returns {Promise.<void>}
//  */
// async function overlayAnalyst (datasetPath, clipDatasetPath, analystType) {
//   try {
//     await Analyst.overlayAnalyst(datasetPath, clipDatasetPath, analystType)
//   } catch (error) {
//     console.error(error)
//   }
// }

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

export default {
  // bufferAnalyst,
  // overlayAnalyst,
  
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
}