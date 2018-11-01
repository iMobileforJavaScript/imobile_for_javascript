import { NativeModules } from 'react-native';
let Analyst = NativeModules.SAnalyst;
let M = NativeModules.JSMap;

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

export default {
  bufferAnalyst,
  clear,
}