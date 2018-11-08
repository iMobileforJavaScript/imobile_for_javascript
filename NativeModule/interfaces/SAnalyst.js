
import { NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform } from 'react-native';
import { Map3DEventConst } from '../constains'
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

async function setMeasureLineAnalyst(handlers) {
    try {
      if (Platform.OS === 'ios' && handlers) {
        if (typeof handlers.callback === 'function') {
          nativeEvt.addListener(Map3DEventConst.ANALYST_MEASURELINE, function (e) {
            handlers.callback(e)
          })
        }
      } else if (Platform.OS === 'android' && handlers) {
        if (typeof handlers.callback === "function") {
          DeviceEventEmitter.addListener(Map3DEventConst.ANALYST_MEASURELINE, function (e) {
             handlers.callback(e);
          });
        }
      }
    await Analyst.setMeasureLineAnalyst()
  } catch (e) {
    console.error(e);
  }
}

async function setMeasureSquareAnalyst(handlers) {
  try {
    if (Platform.OS === 'ios' && handlers) {
      if (typeof handlers.callback === 'function') {
        nativeEvt.addListener(Map3DEventConst.ANALYST_MEASURESQUARE, function (e) {
          handlers.callback(e)
        })
      }
    } else if (Platform.OS === 'android' && handlers) {
      if (typeof handlers.callback === "function") {
        DeviceEventEmitter.addListener(Map3DEventConst.ANALYST_MEASURESQUARE, function (e) {
           handlers.callback(e);
        });
      }
    }
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