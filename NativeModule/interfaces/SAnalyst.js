import {
  NativeModules,
} from 'react-native'

let Analyst = NativeModules.SAnalyst
// const nativeEvt = new NativeEventEmitter(Analyst);
async function bufferAnalyst (layerName, params) {
  try {
    return await Analyst.analystBuffer(layerName, params)
  } catch (e) {
    console.error(e)
  }
}

async function clear (map) {
  try {
    await M.clearTrackingLayer(map._SMMapId)
    await map.refresh()
  } catch (e) {
    console.error(e)
  }
}

async function overlayAnalyst (datasetPath, clipDatasetPath, analystType) {
  try {
    await Analyst.overlayAnalyst(datasetPath, clipDatasetPath, analystType)
  } catch (error) {
    console.error(error)
  }
}

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
  try {
    return Analyst.createBuffer(sourceData, resultData, bufferParameter, isUnion, isAttributeRetained, optionParameter)
  } catch (error) {
    console.error(error)
  }
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
  try {
    return Analyst.createMultiBuffer(sourceData, resultData, bufferRadiuses, bufferRadiusUnit, semicircleSegment, isUnion, isAttributeRetained, isRing, optionParameter)
  } catch (error) {
    console.error(error)
  }
}

async function createLineOneSideMultiBuffer (datasetPath, arrBufferRadius, bufferRadiusUnit, semicircleSegment, isLeft, isUnion, isAttributeRetained, isRing) {
  try {
    await Analyst.createLineOneSideMultiBuffer(datasetPath, arrBufferRadius, bufferRadiusUnit, semicircleSegment, isLeft, isUnion, isAttributeRetained, isRing)
  } catch (error) {
    console.error(error)
  }
}

export default {
  bufferAnalyst,
  clear,
  overlayAnalyst,
  createBuffer,
  createMultiBuffer,
  createLineOneSideMultiBuffer,
}