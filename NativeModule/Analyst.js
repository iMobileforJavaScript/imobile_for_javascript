import { NativeModules } from 'react-native';
let BA = NativeModules.JSBufferAnalyst;
let M = NativeModules.JSMap;

async function bufferAnalyst(map, selection, params) {
  try {
    return await BA.analyst(map._SMMapId, selection._SMSelectionId, params);
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
}