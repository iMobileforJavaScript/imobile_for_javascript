/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 Description: 工作空间操作类
 **********************************************************************************/
import { NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform, PixelRatio } from 'react-native'
import * as MapTool from './SMapTool'
import * as MapSettings from './SMapSettings'
import * as LayerManager from './SLayerManager'
import * as Plot from './SPlot'
import * as Datasource from './SDatasource'
import { EventConst } from '../../constains/index'
let SMapSuspension = NativeModules.SMapSuspension
const dpi = PixelRatio.get()

const nativeEvt = new NativeEventEmitter(SMapSuspension)

export default (function () {

  /**
   * 打开指定mapview
   * @returns {*}
   */
  function openMap (mapid) {
    try {
      return SMapSuspension.openMap(mapid)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 打开地图
   * @returns {*}
   */
  function openMapByName (strMapName, params = {}) {
    try {
      return SMapSuspension.openMapByName(strMapName, params)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 关闭地图
   * @returns {*}
   */
  function closeMap () {
    try {
      return SMapSuspension.closeMap()
    } catch (e) {
      console.error(e)
    }
  }

  let SMapSuspensionExp = {
    openMap,
    openMapByName,
    closeMap,
  }
  Object.assign(SMapSuspensionExp)

  return SMapSuspensionExp
})()
