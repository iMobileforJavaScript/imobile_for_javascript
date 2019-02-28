import {
  NativeModules,
  DeviceEventEmitter,
  NativeEventEmitter,
  Platform
} from 'react-native';
import {
  EventConst
} from '../constains'
let Analyst = NativeModules.SAnalyst;
const nativeEvt = new NativeEventEmitter(Analyst);
async function bufferAnalyst(layerName, params) {
  try {
    return await Analyst.analystBuffer(layerName, params);
  } catch (e) {
    console.error(e);
  }
}

async function clear(map) {
  try {
    await M.clearTrackingLayer(map._SMMapId)
    await map.refresh()
  } catch (e) {
    console.error(e);
  }
}

async function setOverlayParameterOfoperationRetainedFields(operationRetainedFields){
  try {
     await Analyst.setOverlayParameterOfoperationRetainedFields(operationRetainedFields)
  } catch (error) {
    console.error(error);
  }
}

async function setOverlayParameterOfsourceRetainedFields(sourceRetainedFields){
  try {
     await Analyst.setOverlayParameterOfsourceRetainedFields(sourceRetainedFields)
  } catch (error) {
    console.error(error);
  }
}

async function setOverlayParameterOftolerance(tolerance){
  try {
    await Analyst.setOverlayParameterOftolerance(tolerance)
  } catch (error) {
    console.error(error);
  }
}

async function overlayAnalyst(datasourceName,dataset,clipDataset,analystType){
  try {
    await Analyst.overlayAnalyst(datasourceName,dataset,clipDataset,analystType)
  } catch (error) {
    console.error(error);
  }
}

async function setBufferParameterOfEndType(EndType){
  try {
    await Analyst.setBufferParameterOfEndType(EndType)
  } catch (error) {
    console.error(error);
  }
}

async function setBufferParameterOfleftDistance(leftDistance){
  try {
    await Analyst.setBufferParameterOfleftDistance(leftDistance)
  } catch (error) {
    console.error(error);
  }
}

async function  setBufferParameterOfradiusUnit(radiusUnit){
  try {
    await Analyst.setBufferParameterOfradiusUnit(radiusUnit)
  } catch (error) {
    console.error(error);
  }
}

async function setBufferParameterOfrightDistance(rightDistance){
  try {
    await Analyst.setBufferParameterOfrightDistance(rightDistance)
  } catch (error) {
    console.error(error);
  }
}

async function setBufferParameterOfsemicircleLineSegment(semicircleLineSegment){
  try {
    await Analyst.setBufferParameterOfsemicircleLineSegment(semicircleLineSegment)
  } catch (error) {
    console.error(error);
  }
}

async function createbuffer( datasourceName, dataset, isUnion, isAttributeRetained){
  try {
    await Analyst.createbuffer( datasourceName, dataset, isUnion, isAttributeRetained)
  } catch (error) {
    console.error(error);
  }
}

async function createMultiBuffer( datasourceName, dataset, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isUnion,  isAttributeRetained, isRing){
  try {
    await Analyst.createMultiBuffer(datasourceName, dataset, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isUnion,  isAttributeRetained, isRing)
  } catch (error) {
    console.error(error);
  }
}

async function createLineOneSideMultiBuffer( datasourceName, dataset, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isLeft,  isUnion,  isAttributeRetained,  isRing){
  try {
    await Analyst.createLineOneSideMultiBuffer(datasourceName, dataset, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isLeft,  isUnion,  isAttributeRetained,  isRing)
  } catch (error) {
    console.error(error);
  }
}

async function setQueryParameterOfattributeFilter(attributeFilter){
  try {
    await Analyst.setQueryParameterOfattributeFilter(attributeFilter)
  } catch (error) {
    console.error(error);
  }
}

async function setQueryParameterOfcursorType(cursorType){
  try {
    await Analyst.setQueryParameterOfcursorType(cursorType)
  } catch (error) {
    console.error(error);
  }
}

async function setQueryParameterOfgroupBy(groupBy){
  try {
    await Analyst.setQueryParameterOfgroupBy(groupBy)
  } catch (error) {
    console.error(error);
  }
}

async function setQueryParameterOfhasGeometry(hasGeometry){
  try {
    await Analyst.setQueryParameterOfhasGeometry(hasGeometry)
  } catch (error) {
    console.error(error);
  }
}

async function setQueryParameterOforderBy(orderBy){
  try {
    await Analyst.setQueryParameterOforderBy(orderBy)
  } catch (error) {
    console.error(error);
  }
}

async function setQueryParameterOfresultFields(resultFields){
  try {
    await Analyst.setQueryParameterOfresultFields(resultFields)
  } catch (error) {
    console.error(error);
  }
}

async function setQueryParameterOfspatialQueryMode(spatialQueryMode){
  try {
    await Analyst.setQueryParameterOfspatialQueryMode(spatialQueryMode)
  } catch (error) {
    console.error(error);
  }
}

async function query(datasourceName,datasetName){
  try {
    await Analyst.query(datasourceName,datasetName)
  } catch (error) {
    console.error(error);
  }
}

export default {
  bufferAnalyst,
  clear,
  setOverlayParameterOfoperationRetainedFields,
  setOverlayParameterOfsourceRetainedFields,
  setOverlayParameterOftolerance,
  overlayAnalyst,
  setBufferParameterOfEndType,
  setBufferParameterOfleftDistance,
  setBufferParameterOfradiusUnit,
  setBufferParameterOfrightDistance,
  setBufferParameterOfsemicircleLineSegment,
  createbuffer,
  createMultiBuffer,
  createLineOneSideMultiBuffer,
  setQueryParameterOfattributeFilter,
  setQueryParameterOfcursorType,
  setQueryParameterOfgroupBy,
  setQueryParameterOfhasGeometry,
  setQueryParameterOforderBy,
  setQueryParameterOfresultFields,
  setQueryParameterOfspatialQueryMode,
  query,
}