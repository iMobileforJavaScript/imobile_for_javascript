/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 Description: 工作空间操作类
 **********************************************************************************/
import { NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform } from 'react-native'
import * as MapTool from './SMapTool'
import * as LayerManager from './SLayerManager'
import { EventConst } from '../constains'
let SMap = NativeModules.SMap

const nativeEvt = new NativeEventEmitter(SMap);

export default (function () {
  /**
   * 打开工作空间
   * @param infoDic
   * @returns {Promise}
   */
  function openWorkspace(infoDic) {
    try {
      const type = infoDic.server.split('.').pop()
      Object.assign(infoDic, { type: getWorkspaceType(type) })
      return SMap.openWorkspace(infoDic)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 以打开数据源的方式打开工作空间
   * @param params
   * @param value    图层 index / name
   * @returns {*}
   */
  function openDatasource(params, value) {
    try {
      if (typeof value === 'number') {
        value = value >= 0 ? value : -1
        return SMap.openDatasourceWithIndex(params, value)
      } else {
        value = value || ''
        return SMap.openDatasourceWithName(params, value)
      }
    } catch (e) {
      console.error(e)
    }
  }


  /**
   * 保存工作空间
   * @param info 保存工作空间连接信息
   * @returns {*}
   */
  function saveWorkspace(info) {
    try {
      if (info === null) {
        return SMap.saveWorkspace()
      } else {
        return SMap.saveWorkspaceWithInfo(info)
      }
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取UDB中数据集名称
   * @param params
   * @param value    UDB在内存中路径
   * @returns {*}
   */
  function getUDBName(value) {
    try {
      return SMap.getUDBName(value)
    } catch (e) {
      console.error(e)
    }
  }


  /**
   * 移除指定图层
   * @param params
   * @param value    图层 index
   * @returns {*}
   */
  function removeLayer(value) {
    try {
      return SMap.removeLayerWithIndex(value)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   *
   * @param value       序号或名称
   * @param viewEntire  (option)
   * @param center      (option)
   * @returns {*}
   */
  function openMap(value, viewEntire = true, center = null) {
    try {
      if (typeof value === 'number') {
        return SMap.openMapByIndex(value, viewEntire, center)
      } else {
        return SMap.openMapByName(value, viewEntire, center)
      }
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 检查地图是否有改动
   * @param name
   * @returns {*|Promise}
   */
  function mapIsModified() {
    try {
      return SMap.mapIsModified()
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 保存地图
   * @param name
   * @returns {*|Promise}
   */
  function saveMap(name = '') {
    try {
      return SMap.saveMap(name)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 关闭地图
   */
  function closeMap() {
    try {
      return SMap.closeMap()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 关闭工作空间
   */
  function closeWorkspace() {
    try {
      return SMap.closeWorkspace()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 关闭地图组件
   */
  function closeMapControl() {
    try {
      return SMap.closeMapControl()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置MapControl的action
   */
  function setAction(actionType) {
    try {
      return SMap.setAction(actionType)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 地图放大缩小
   */
  function zoom(scale = 2) {
    try {
      return SMap.zoom(scale)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 地图放大缩小
   */
  function moveToCurrent() {
    try {
      return SMap.moveToCurrent()
    } catch (e) {
      console.error(e)
    }
  }

  getWorkspaceType = (type) => {
    let value
    switch (type) {
      case 'SMWU':
      case 'smwu':
        value = 9
        break
      case 'SXWU':
      case 'sxwu':
        value = 8
        break
      case 'SMW':
      case 'smw':
        value = 5
        break
      case 'SXW':
      case 'sxw':
        value = 4
        break
      case 'UDB':
      case 'udb':
        value = 219
        break
      default:
        value = 1
        break
    }
    return value
  }

  submit = () => {
    SMap.submit()
  }

  getLayers = () => {
    SMap.getLayers()
  }

  /**
   * 手势监听
   * @memberOf MapControl
   * @param {object} events - 传入一个对象作为参数，该对象可以包含两个属性：longPressHandler和scrollHandler。两个属性的值均为function类型，分部作为长按与滚动监听事件的处理函数。
   * @returns {Promise.<void>}
   */
  setGestureDetector = handlers => {
    try {
      if (handlers) {
        SMap.setGestureDetector()
      } else {
        throw new Error("setGestureDetector need callback functions as first two argument!")
      }
      //差异化
      if (Platform.OS === 'ios') {
        if (typeof handlers.longPressHandler === "function") {
          nativeEvt.addListener(EventConst.MAP_LONG_PRESS, function (e) {
            // longPressHandler && longPressHandler(e)
            handlers.longPressHandler(e)
          })
        }

        if (typeof handlers.singleTapHandler === "function") {
          nativeEvt.addListener(EventConst.MAP_SINGLE_TAP, function (e) {
            handlers.singleTapHandler(e)
          })
        }

        if (typeof handlers.doubleTapHandler === "function") {
          nativeEvt.addListener(EventConst.MAP_DOUBLE_TAP, function (e) {
            handlers.doubleTapHandler(e)
          })
        }

        if (typeof handlers.touchBeganHandler === "function") {
          nativeEvt.addListener(EventConst.MAP_TOUCH_BEGAN, function (e) {
            handlers.touchBeganHandler(e)
          })
        }

        if (typeof handlers.touchEndHandler === "function") {
          nativeEvt.addListener(EventConst.MAP_TOUCH_END, function (e) {
            handlers.touchEndHandler(e)
          })
        }

        if (typeof handlers.scrollHandler === "function") {
          nativeEvt.addListener(EventConst.MAP_SCROLL, function (e) {
            handlers.scrollHandler(e)
          })
        }
      } else {
        if (typeof handlers.longPressHandler === "function") {
          DeviceEventEmitter.addListener(EventConst.MAP_LONG_PRESS, function (e) {
            // longPressHandler && longPressHandler(e)
            handlers.longPressHandler(e)
          })
        }

        if (typeof handlers.singleTapHandler === "function") {
          DeviceEventEmitter.addListener(EventConst.MAP_SINGLE_TAP, function (e) {
            handlers.singleTapHandler(e)
          })
        }

        if (typeof handlers.doubleTapHandler === "function") {
          DeviceEventEmitter.addListener(EventConst.MAP_DOUBLE_TAP, function (e) {
            handlers.doubleTapHandler(e)
          })
        }

        if (typeof handlers.touchBeganHandler === "function") {
          DeviceEventEmitter.addListener(EventConst.MAP_TOUCH_BEGAN, function (e) {
            handlers.touchBeganHandler(e)
          })
        }

        if (typeof handlers.touchEndHandler === "function") {
          DeviceEventEmitter.addListener(EventConst.MAP_TOUCH_END, function (e) {
            handlers.touchEndHandler(e)
          })
        }

        if (typeof handlers.scrollHandler === "function") {
          DeviceEventEmitter.addListener(EventConst.MAP_SCROLL, function (e) {
            handlers.scrollHandler(e)
          })
        }
      }

    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 移除手势监听
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  deleteGestureDetector = () => {
    try {
      SMap.deleteGestureDetector()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 添加对象修改前监听器
   * @memberOf MapControl
   * @param events - events:{geometrySelected: e => {...},geometryMultiSelected e => {...}}
   * geometrySelected 单个集合对象被选中事件的回调函数，参数e为获取结果 e:{layer:--, id:--} layer:操作的图层，操作对象id.
   * geometryMultiSelected 多个集合对象被选中事件的回调函数，参数e为获取结果数组：e:{geometries:[layer:--,id:--]}
   * @returns {Promise.<*>}
   */
  addGeometrySelectedListener = events => {
    (async function () {
      try {
        let success = await SMap.addGeometrySelectedListener()
        if (!success) return
        //差异化
        if (Platform.OS === 'ios') {
          nativeEvt.addListener(EventConst.MAP_GEOMETRY_SELECTED, function (e) {
            if (typeof events.geometrySelected === 'function') {
              events.geometrySelected(e)
            } else {
              console.error("Please set a callback to the first argument.")
            }
          })
          nativeEvt.addListener(EventConst.MAP_GEOMETRY_MULTI_SELECTED, function (e) {
            if (typeof events.geometryMultiSelected === 'function') {
              events.geometryMultiSelected(e)
            } else {
              console.error("Please set a callback to the first argument.")
            }
          })
        } else {
          DeviceEventEmitter.addListener(EventConst.MAP_GEOMETRY_SELECTED, function (e) {
            if (typeof events.geometrySelected === 'function') {
              events.geometrySelected(e)
            } else {
              console.error("Please set a callback to the first argument.")
            }
          })
          DeviceEventEmitter.addListener(EventConst.MAP_GEOMETRY_MULTI_SELECTED, function (e) {
            if (typeof events.geometryMultiSelected === 'function') {
              events.geometryMultiSelected(e)
            } else {
              console.error("Please set a callback to the first argument.")
            }
          })
        }
        return success
      } catch (e) {
        console.error(e)
      }
    })()
  }

  /**
   * 移除对象选中监听器。
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  removeGeometrySelectedListener = () => {
    try {
      SMap.removeGeometrySelectedListener()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 指定编辑几何对象
   * @param geoID
   * @param layerName
   */
  appointEditGeometry = (geoID, layerName) => {
    try {
      SMap.appointEditGeometry(geoID, layerName)
    } catch (e) {
      console.error(e)
    }
  }

  getSymbolGroups = (type = '', path = '') => {
    try {
      return SMap.getSymbolGroups(type, path)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取指定SymbolGroup中所有的symbol
   * @param type
   * @param path
   */
  findSymbolsByGroups = (type = '', path = '') => {
    try {
      return SMap.findSymbolsByGroups(type, path)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取图层名字
   */
  getLayersNames = () => {
    try {
      return SMap.getLayersNames()
    } catch (e) {
      console.error(e)
    }
  }

  let SMapExp = {
    openWorkspace,
    openDatasource,
    saveWorkspace,
    closeWorkspace,
    closeMapControl,
    setAction,
    openMap,
    saveMap,
    zoom,
    moveToCurrent,
    removeLayer,
    closeMap,
    getUDBName,
    getLayers,
    submit,
    setGestureDetector,
    deleteGestureDetector,
    addGeometrySelectedListener,
    removeGeometrySelectedListener,
    appointEditGeometry,
    getSymbolGroups,
    findSymbolsByGroups,
    getLayersNames,
  }
  Object.assign(SMapExp, MapTool, LayerManager)

  return SMapExp
})()