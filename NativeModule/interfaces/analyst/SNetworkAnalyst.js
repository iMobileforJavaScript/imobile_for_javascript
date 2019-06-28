import {
  NativeModules,
  DeviceEventEmitter,
  NativeEventEmitter,
  Platform,
} from 'react-native'
import { EventConst } from '../../constains/index'
import FacilityAnalyst from './SFacilityAnalyst'
// let Analyst = NativeModules.SNetworkAnalyst
//
// /**
//  * 设置开始点
//  * @param point
//  * @returns {Promise.<void>}
//  */
// async function setStartPoint (point) {
//   return Analyst.setStartPoint(point)
// }
//
// export default {
//   FacilityAnalyst,
//
//   setStartPoint,
// }