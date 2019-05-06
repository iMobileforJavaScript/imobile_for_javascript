/**
 * email Asort@qq.com
 * https://github.com/AsortKeven
 * Asort
 */
import { NativeModules, Platform } from 'react-native'
const SMRLegendView = NativeModules.SMRLegendView

/**
 *  地图图例
 * @param isShow
 * @param orientation
 * @returns {*}
 */
function legendLayer(isShow,orientation = 'portrait') {
  try {
    return SMRLegendView.legendLayer(isShow,orientation)
  } catch (e) {
    console.error(e)
  }
}

export {
  legendLayer
}