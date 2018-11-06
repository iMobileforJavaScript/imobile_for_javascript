import { NativeModules } from 'react-native';
let Analyst = NativeModules.SAnalyst;

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

async function setMeasureLineAnalyst() {
  try {
    await Analyst.setMeasureLineAnalyst()
  } catch (e) {
    console.error(e);
  }
}

async function setMeasureSquareAnalyst() {
  try {
    await Analyst.setMeasureSquareAnalyst()
  } catch (e) {
    console.error(e);
  }
}

async function closeAnalysis() {
  try {
    await Analyst.closeAnalysis()
  } catch (e) {
    console.error(e);
  }
}
export default {
  bufferAnalyst,
  clear,
  setMeasureLineAnalyst,
  setMeasureSquareAnalyst,
  closeAnalysis,
}