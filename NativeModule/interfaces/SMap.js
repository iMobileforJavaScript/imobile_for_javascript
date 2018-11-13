/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 Description: 工作空间操作类
 **********************************************************************************/
import { NativeModules, Platform } from 'react-native'
import * as MapTool from './SMapTool'
let SMap = NativeModules.SMap

export default (function () {
  /**
   * 打开工作空间
   * @param infoDic
   * @returns {Promise}
   */
  function openWorkspace(infoDic) {
    try {
      const type = infoDic.server.split('.').pop()
      Object.assign(infoDic, {type: getWorkspaceType(type)})
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
   * 打开UDB数据源
   * @param params
   * @param value    图层 index / name
   * @returns {*}
   */
  function openUDBDatasource(params, value) {
    try {
      if (typeof value === 'number') {
        value = value >= 0 ? value : -1
        return SMap.openUDBDatasourceWithIndex(params, value)
      } else {
        value = value || ''
        return SMap.openUDBDatasourceWithIndex(params, value)
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
    var value
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

  let SMapExp = {
    openWorkspace,
    openDatasource,
    closeWorkspace,
    setAction,
    openMap,
    zoom,
    moveToCurrent,
    removeLayer,
    closeMap,
    openUDBDatasource,
    getUDBName,
  }
  Object.assign(SMapExp, MapTool)

  return SMapExp
})()