import {
  NativeModules,
} from 'react-native';

let Analyst = NativeModules.SAnalyst;
// const nativeEvt = new NativeEventEmitter(Analyst);
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


async function overlayAnalyst(datasetPath,clipDatasetPath,analystType){
  try {
    await Analyst.overlayAnalyst(datasetPath,clipDatasetPath,analystType)
  } catch (error) {
    console.error(error);
  }
}

async function createbuffer( datasetPath, isUnion, isAttributeRetained){
  try {
    await Analyst.createbuffer( datasetPath, isUnion, isAttributeRetained)
  } catch (error) {
    console.error(error);
  }
}

async function createMultiBuffer(  datasetPath, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isUnion,  isAttributeRetained, isRing){
  try {
    await Analyst.createMultiBuffer( datasetPath, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isUnion,  isAttributeRetained, isRing)
  } catch (error) {
    console.error(error);
  }
}

async function createLineOneSideMultiBuffer( datasetPath, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isLeft,  isUnion,  isAttributeRetained,  isRing){
  try {
    await Analyst.createLineOneSideMultiBuffer( datasetPath, arrBufferRadius,  bufferRadiusUnit,  semicircleSegment,  isLeft,  isUnion,  isAttributeRetained,  isRing)
  } catch (error) {
    console.error(error);
  }
}

export default {
  bufferAnalyst,
  clear,
  overlayAnalyst,
  createbuffer,
  createMultiBuffer,
  createLineOneSideMultiBuffer,
}