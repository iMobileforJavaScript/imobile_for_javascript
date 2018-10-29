import { NativeModules } from 'react-native';
let Analyst = NativeModules.SMAnalyst;
let M = NativeModules.JSMap;

async function bufferAnalyst(map, layer, params) {
  try {
    return await Analyst.analystBuffer(map._SMMapId, layer._SMLayerId, params);
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