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
import * as Datasource from './SDatasource'
import { EventConst } from '../../constains/index'
let SMap = NativeModules.SMap
const dpi = PixelRatio.get()

const nativeEvt = new NativeEventEmitter(SMap)

export default (function () {
  /**
   * 获取许可文件状态
   * @returns {*}
   */
  function getEnvironmentStatus () {
    try {
      return SMap.getEnvironmentStatus()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 比例尺缩放事件
   * @param handler
   */
  function addScaleChangeDelegate(handler) {
      try {
        if(Platform.OS === 'ios'){
          nativeEvt.addListener(EventConst.MAP_SCALEVIEW_CHANGE,result=>{
            if(typeof handler.scaleViewChange === "function"){
              handler.scaleViewChange(result);
            }
          })
        }else {
          DeviceEventEmitter.addListener(EventConst.MAP_SCALEVIEW_CHANGE,result=>{
            if(typeof handler.scaleViewChange === "function"){
              handler.scaleViewChange(result);
            }
          })
        }
      }catch (e) {
        console.error(e)
      }
  }
  /**
   * 添加图例的监听事件，会返回相应的图例数据
   * @returns {*}
   */
  function addLegendListener(handler) {
    try {
      let isSuccess = SMap.addLegendListener()
      if(!isSuccess)
        return
      if(Platform.OS === 'ios'){
        nativeEvt.addListener(EventConst.MAP_LEGEND_CONTENT_CHANGE,(result)=>{
          if(typeof handler.legendContentChange === 'function'){
            handler.legendContentChange(result)
          }
        })
      }else {
        DeviceEventEmitter.addListener(EventConst.MAP_LEGEND_CONTENT_CHANGE,(result)=>{
          if(typeof handler.legendContentChange === 'function'){
            handler.legendContentChange(result)
          }
        })
      }
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 移除图例事件监听
   * @returns {*}
   */
  function removeLegendListener() {
    try {
      return SMap.removeLegendListener()
    }catch (e) {
      console.error(e)
    }
  }

  /**
   * 刷新地图
   * @returns {*}
   */
  function refreshMap () {
    try {
      return SMap.refreshMap()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 打开工作空间
   * @param infoDic
   * @returns {Promise}
   */
  function openWorkspace (infoDic) {
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
  function openDatasource (params, value, toHead = true, isVisible = true) {
    try {
      let b = false
      if (typeof value === 'number') {
        value = value >= 0 ? value : -1
        b = SMap.openDatasourceWithIndex(params, value, toHead, isVisible)
      } else {
        value = value || ''
        b = SMap.openDatasourceWithName(params, value, toHead, isVisible)
      }

      SMap.enableRotateTouch(bEnableRotateTouch)
      SMap.enableSlantTouch(bEnableSlantTouch)
      return b
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 仅用于判断在线数据是否可请求到数据
   * @returns {*|Promise.<Maps>}
   */
  function isDatasourceOpen (params) {
    try {
      return SMap.isDatasourceOpen(params)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取工作空间地图列表
   * @returns {*|Promise.<Maps>}
   */
  function getMaps () {
    try {
      return SMap.getMaps()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 保存工作空间
   * @param info 保存工作空间连接信息
   * @returns {*}
   */
  function saveWorkspace (info) {
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
  function getUDBName (value) {
    try {
      return SMap.getUDBName(value)
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
  function getUDBNameOfLabel (value) {
    try {
      return SMap.getUDBNameOfLabel(value)
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
  function openMap (value, viewEntire = false, center = null) {
    try {
      let b = false
      if (typeof value === 'number') {
        b = SMap.openMapByIndex(value, viewEntire, center)
      } else {
        b = SMap.openMapByName(value, viewEntire, center)
      }
      SMap.enableRotateTouch(bEnableRotateTouch)
      SMap.enableSlantTouch(bEnableSlantTouch)
      return b
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 检查地图是否有改动
   * @param name
   * @returns {*|Promise}
   */
  function mapIsModified () {
    try {
      return SMap.mapIsModified()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 保存地图
   * @param name
   * @param autoNaming 为true的话若有相同名字的地图则自动命名
   * @returns {*}
   */
  function saveMap (name = '', autoNaming = true) {
    try {
      return SMap.saveMap(name, autoNaming)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 地图另存为
   * @param name
   * @returns {*|*|Promise}
   */
  function saveAsMap (name = '') {
    try {
      return SMap.saveAsMap(name)
    } catch (e) {
      console.error(e)
      return e
    }
  }

  /**
   * 关闭地图
   */
  function closeMap () {
    try {
      return SMap.closeMap()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 关闭工作空间
   */
  function closeWorkspace () {
    try {
      return SMap.closeWorkspace()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 关闭地图组件
   */
  function closeMapControl () {
    try {
      return SMap.closeMapControl()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置MapControl的action
   */
  function setAction (actionType) {
    try {
      return SMap.setAction(actionType)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取MapControl的action
   */
  function getAction () {
    try {
      return SMap.getAction()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 地图放大缩小
   */
  function zoom (scale = 2) {
    try {
      return SMap.zoom(scale)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 地图放大缩小
   */
  function setScale (scale) {
    try {
      if (scale === undefined) return false
      return SMap.setScale(scale)
    } catch (e) {
      console.error(e)
    }
  }

  var bEnableRotateTouch = false
  /**
   * 地图手势旋转是否可用
   */
  function isEnableRotateTouch () {
    try {
      return bEnableRotateTouch
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置地图手势旋转是否可用
   */
  function enableRotateTouch (enable) {
    try {
      if (enable === undefined) return false
      bEnableRotateTouch = enable
      return SMap.enableRotateTouch(enable)
    } catch (e) {
      console.error(e)
    }
  }

  var bEnableSlantTouch = false
  /**
   * 地图手势旋转是否可用
   */
  function isEnableSlantTouch () {
    try {
      return bEnableSlantTouch
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置地图手势俯仰是否可用
   */
  function enableSlantTouch (enable) {
    try {
      if (enable === undefined) return false
      bEnableSlantTouch = enable
      return SMap.enableSlantTouch(enable)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 以面对象region裁减地图map 并保存为 strResultName
   通过图层确定裁减数据集，支持矢量和本地删格数据集，layer可以不参加裁减（不参加，意思是在结果数据集中layer.dataset不变）但同一数据集的layer裁减参数一致（以第一个layer参数为准）
   
   
   返回值说明：裁减完地图尝试以strResultName保存到map.workspace.maps中，若已存在同名则重命名为strResultName#1，把最终命名结果返回
   * @param points
   *   [{x, y}]
   * @param layersInfo
   *   LayerName 需裁减Layer名（实际为裁减Layer对应dataset，裁减结果为新数据集保留到dataset所在datasource，新地图中Layer指向新数据集）
       IsClipInRegion 裁减区域在面内还是面外
       IsErase 是否擦除模式
       IsExactClip 是否精确裁减（删格涂层才有该选项）
       DatasourceTarget
       DatasetTarget
     Eg:
       @"[{\"LayerName\":\"%@\",\"IsClipInRegion\":false,\"IsErase\":false,\"IsExactClip\":true},\
       {\"LayerName\":\"%@\",\"DatasourceTarget\":\"%@\",\"IsErase\":false,\"IsExactClip\":true},\
       {\"LayerName\":\"%@\",\"IsExactClip\":false,\"DatasourceTarget\":\"%@\",\"DatasetTarget\":\"%@\"}]"
   * @param mapName 另存为新地图
   * @param ofModule 另存为新地图模块
   * @param addition 另存为新地图额外信息（例如：exp中模板信息）
   * @param isPrivate 另存为新地图的是否是用户目录
   * @returns {*}
   */
  function clipMap (points = [], layersInfo = [], mapName = null, ofModule = '', addition, isPrivate = true) {
    let _points = []
    if (Platform.OS === 'android') {
      points.forEach(point => {
        _points.push({
          x: point.x * dpi,
          y: point.y * dpi,
        })
      })
    } else {
      _points = points
    }
    return SMap.clipMap(_points, layersInfo, mapName, ofModule, addition, isPrivate)
  }

  /**
   * 移动到当前位置
   */
  function moveToCurrent () {
    try {
      return SMap.moveToCurrent()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 移动到指定位置
   * 默认北京
   */
  function moveToPoint (point = {x: 116.35805, y: 39.70361}) {
    try {
      if (point.x === undefined || point.y === undefined) return
      return SMap.moveToPoint(point)
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
    return SMap.submit()
  }

  cancel = () => {
    return SMap.cancel()
  }

  let longPressDetector, singleTapDetector, doubleTapDetector, touchBeganDetector, touchEndDetector, scrollDetector
  let gestureHandlers
  /**
   * 手势监听
   * @memberOf MapControl
   * @param {object} events - 传入一个对象作为参数，该对象可以包含两个属性：longPressHandler和scrollHandler。两个属性的值均为function类型，分部作为长按与滚动监听事件的处理函数。
   * @returns {Promise.<void>}
   */
  setGestureDetector = handlers => {
    try {
      gestureHandlers = handlers
      if (longPressDetector && singleTapDetector && doubleTapDetector && touchBeganDetector && touchEndDetector && scrollDetector) return
      if (gestureHandlers) {
        SMap.setGestureDetector()
      } else {
        throw new Error('setGestureDetector need callback functions as first two argument!')
      }
      //差异化
      if (Platform.OS === 'ios') {
        if (typeof gestureHandlers.longPressHandler === 'function') {
          longPressDetector = nativeEvt.addListener(EventConst.MAP_LONG_PRESS, function (e) {
            // longPressHandler && longPressHandler(e)
            gestureHandlers.longPressHandler(e)
          })
        }

        if (typeof gestureHandlers.singleTapHandler === 'function') {
          singleTapDetector = nativeEvt.addListener(EventConst.MAP_SINGLE_TAP, function (e) {
            gestureHandlers.singleTapHandler(e)
          })
        }

        if (typeof gestureHandlers.doubleTapHandler === 'function') {
          doubleTapDetector = nativeEvt.addListener(EventConst.MAP_DOUBLE_TAP, function (e) {
            gestureHandlers.doubleTapHandler(e)
          })
        }

        if (typeof gestureHandlers.touchBeganHandler === 'function') {
          touchBeganDetector = nativeEvt.addListener(EventConst.MAP_TOUCH_BEGAN, function (e) {
            gestureHandlers.touchBeganHandler(e)
          })
        }

        if (typeof gestureHandlers.touchEndHandler === 'function') {
          touchEndDetector = nativeEvt.addListener(EventConst.MAP_TOUCH_END, function (e) {
            gestureHandlers.touchEndHandler(e)
          })
        }

        if (typeof gestureHandlers.scrollHandler === 'function') {
          scrollDetector = nativeEvt.addListener(EventConst.MAP_SCROLL, function (e) {
            gestureHandlers.scrollHandler(e)
          })
        }
      } else {
        if (typeof gestureHandlers.longPressHandler === 'function') {
          longPressDetector = DeviceEventEmitter.addListener(EventConst.MAP_LONG_PRESS, function (e) {
            // longPressHandler && longPressHandler(e)
            gestureHandlers.longPressHandler(e)
          })
        }

        if (typeof gestureHandlers.singleTapHandler === 'function') {
          singleTapDetector = DeviceEventEmitter.addListener(EventConst.MAP_SINGLE_TAP, function (e) {
            gestureHandlers.singleTapHandler(e)
          })
        }

        if (typeof gestureHandlers.doubleTapHandler === 'function') {
          doubleTapDetector = DeviceEventEmitter.addListener(EventConst.MAP_DOUBLE_TAP, function (e) {
            gestureHandlers.doubleTapHandler(e)
          })
        }

        if (typeof gestureHandlers.touchBeganHandler === 'function') {
          touchBeganDetector = DeviceEventEmitter.addListener(EventConst.MAP_TOUCH_BEGAN, function (e) {
            gestureHandlers.touchBeganHandler(e)
          })
        }

        if (typeof gestureHandlers.touchEndHandler === 'function') {
          touchEndDetector = DeviceEventEmitter.addListener(EventConst.MAP_TOUCH_END, function (e) {
            gestureHandlers.touchEndHandler(e)
          })
        }

        if (typeof gestureHandlers.scrollHandler === 'function') {
          scrollDetector = DeviceEventEmitter.addListener(EventConst.MAP_SCROLL, function (e) {
            gestureHandlers.scrollHandler(e)
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
      gestureHandlers = null
      if (longPressDetector) {
        longPressDetector.remove()
        longPressDetector = null
      }
      if (singleTapDetector) {
        singleTapDetector.remove()
        singleTapDetector = null
      }
      if (doubleTapDetector) {
        doubleTapDetector.remove()
        doubleTapDetector = null
      }
      if (touchBeganDetector) {
        touchBeganDetector.remove()
        touchBeganDetector = null
      }
      if (touchEndDetector) {
        touchEndDetector.remove()
        touchEndDetector = null
      }
      if (scrollDetector) {
        scrollDetector.remove()
        scrollDetector = null
      }
    } catch (e) {
      console.error(e)
    }
  }
  
  let geometrySelectedListener
  let geometryMultiSelectedListener
  let geometryHandlers
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
        geometryHandlers = events
        if (geometrySelectedListener || geometryMultiSelectedListener) return
        let success = await SMap.addGeometrySelectedListener()
        if (!success) return
        //差异化
        if (Platform.OS === 'ios') {
          geometrySelectedListener = nativeEvt.addListener(EventConst.MAP_GEOMETRY_SELECTED, function (e) {
            if (typeof geometryHandlers.geometrySelected === 'function') {
              geometryHandlers.geometrySelected(e)
            } else {
              console.error('Please set a callback to the first argument.')
            }
          })
          geometryMultiSelectedListener = nativeEvt.addListener(EventConst.MAP_GEOMETRY_MULTI_SELECTED, function (e) {
            if (typeof geometryHandlers.geometryMultiSelected === 'function') {
              geometryHandlers.geometryMultiSelected(e)
            } else {
              console.error('Please set a callback to the first argument.')
            }
          })
        } else {
          geometrySelectedListener = DeviceEventEmitter.addListener(EventConst.MAP_GEOMETRY_SELECTED, function (e) {
            if (typeof geometryHandlers.geometrySelected === 'function') {
              geometryHandlers.geometrySelected(e)
            } else {
              console.error('Please set a callback to the first argument.')
            }
          })
          geometryMultiSelectedListener = DeviceEventEmitter.addListener(EventConst.MAP_GEOMETRY_MULTI_SELECTED, function (e) {
            if (typeof geometryHandlers.geometryMultiSelected === 'function') {
              geometryHandlers.geometryMultiSelected(e)
            } else {
              console.error('Please set a callback to the first argument.')
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
      geometryHandlers = null
      if (geometrySelectedListener) {
        geometrySelectedListener.remove()
        geometrySelectedListener = null
      }
      if (geometryMultiSelectedListener) {
        geometryMultiSelectedListener.remove()
        geometryMultiSelectedListener = null
      }
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
      return SMap.appointEditGeometry(geoID, layerName)
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
  function isModified () {
    try {
      return SMap.isModified()
    } catch (error) {
      console.log(error)
    }
  }

  function getMapName () {
    try {
      return SMap.getMapName()
    } catch (error) {
      console.log(error)
    }
  }

  /**
   * 保存地图为XML
   */
  function saveMapToXML (filePath) {
    try {
      return SMap.saveMapToXML(filePath)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 以xml方式加载地图
   */
  function openMapFromXML (filePath) {
    try {
      return SMap.openMapFromXML(filePath)
    } catch (e) {
      console.error(e)
    }
  }

    /**
   * 获取地图对应的数据源别名
   */
  function showMarker (longitude,latitude,tag) {
    try {
      return SMap.showMarker(longitude,latitude,tag)
    } catch (e) {
      console.error(e)
    }
  }
    /**
   * 获取地图对应的数据源别名
   */
  function deleteMarker (tag) {
    try {
      return SMap.deleteMarker(tag)
    } catch (e) {
      console.error(e)
    }
  }

  
  /**
   * 获取地图对应的数据源别名
   */
  function getMapDatasourcesAlias () {
    try {
      return SMap.getMapDatasourcesAlias()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 根据名称/序号关闭数据源
   * value = '' 或 value = -1 则全部关闭
   */
  function workspaceIsModified () {
    try {
      return SMap.workspaceIsModified()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 根据地图名称获取地图的index, 若name为空，则返回当前地图的index
   * @param mapName
   * @returns {*}
   */
  function getMapIndex (mapName) {
    try {
      return SMap.getMapIndex(mapName)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导入工作空间
   * @param info
   * @param toFile  UDB等文件的所在文件夹（option）
   * @param breplaceDatasource   同名替换文件
   * @returns {*}
   */
  function importWorkspace (info = {}, toFile = '', breplaceDatasource = false) {
    try {
      return SMap.importWorkspace(info, toFile, breplaceDatasource)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导出工作空间
   * @param arrMapnames  地图名字
   * @param strFileName  导出完整路径（包含工作空间后缀名）
   * @param fileReplace  同名替换文件
   * @param extra        额外信息
   * @returns {*}
   */
  function exportWorkspace (arrMapnames = [], strFileName = '', fileReplace = false, extra = {}) {
    try {
      return SMap.exportWorkspace(arrMapnames, strFileName, fileReplace, extra)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 导出工作空间
   * @param mapName  地图名字（不含后缀）
   * @param exportWorkspacePath        导出的工作空间绝对路径（含后缀）
   * @param params { IsPrivate, IsReplaceSymbol, Module }
   * @returns {*}
   */
  function exportWorkspaceByMap (mapName, exportWorkspacePath, params = {}) {
    try {
      return SMap.exportWorkspaceByMap(mapName,exportWorkspacePath,params)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取地图信息
   * @returns {*}
   */
  function getMapInfo () {
    try {
      return SMap.getMapInfo()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 添加数据集
   * @returns {*}
   */
  function addDatasetToMap (params) {
    try {
      return SMap.addDatasetToMap(params)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导出(保存)工作空间中地图到模块
   * @param strMapAlians
   * @param nModule
   * @param withAddition 需要删除标注图层 filterLayers 标注图层数组
   * @param isNew  若为false，则自动判断名字是否存在，若存在，保存并导出覆盖原来的xml；若不存在，则创建新的xml。
   *               若为true，创建新的xml地图文件
   * @param bResourcesModified  若为false，则导出所有的Resources；
   *                            若为true，则导出是用的Resources
   * @param bPrivate  是否是用户私有(在User/下)
   * @returns {*}
   */
  function saveMapName (strMapAlians = '', nModule = '', withAddition = {}, isNew = false, bResourcesModified = false, bPrivate = true) {
    try {
      return SMap.saveMapName(strMapAlians, nModule, withAddition, isNew, bResourcesModified, bPrivate)
    } catch (e) {
      console.error(e)
      return e
    }
  }

  /**
   * 导入文件工作空间到程序目录
   * @param infoDic
   * @param strDirPath
   * @param bPrivate
   * @returns {*}
   */
  function importWorkspaceInfo (infoDic, strDirPath, bPrivate = true) {
    try {
      console.log(infoDic,strDirPath,bPrivate)
      return SMap.importWorkspaceInfo(infoDic, strDirPath, bPrivate)
    } catch (e) {
      console.error(e)
    }
  }


    /**
   * 导入数据源到程序目录
   * @param filePath
   * @param nModule
   * @returns {*}
   */
  function importDatasourceFile (filePath, nModule = '') {
    try {
      return SMap.importDatasourceFile(filePath,nModule)
    } catch (e) {
      console.error(e)
    }
  }

  
  /**
   * 大工作空间打开本地地图
   * @param strMapName
   * @param nModule 模块名（文件夹名）
   * @param isPrivate { Module, IsPrivate, IsReplaceSymbol }
   * @returns {*}
   */
  function openMapName (strMapName, params = {}) {
    try {
      // if (params.Module === undefined) {
      //   params.srcModule = ''
      // }
      // if (params.IsPrivate === undefined) {
      //   params.bPrivate = false
      // }
      // if (params.IsReplaceSymbol === undefined) {
      //   params.bPrivate = false
      // }
      return SMap.openMapName(strMapName, params)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 移除指定地图
   * @param value
   *        value = -1 或者 value = '' 移除所有地图
   * @returns {*}
   */
  function removeMap (value) {
    try {
      if (value === undefined) return
      if (typeof value === 'number') {
        return SMap.removeMapByIndex(value)
      } else {
        return SMap.removeMapByName(value)
      }
    } catch (e) {
      console.error(e)
      return e
    }
  }

  /**设置是否反走样 */
  function setAntialias (value) {
    try {
      return SMap.setAntialias(value)
    } catch (e) {
      console.error(e)
    }
  }

  /**获取是否反走样 */
  function isAntialias () {
    try {
      return SMap.isAntialias()
    } catch (e) {
      console.error(e)
    }
  }

  /**设置是否固定比例尺 */
  function setVisibleScalesEnabled (value) {
    try {
      return SMap.setVisibleScalesEnabled(value)
    } catch (e) {
      console.error(e)
    }
  }

  /**获取是否固定比例尺 */
  function isVisibleScalesEnabled () {
    try {
      return SMap.isVisibleScalesEnabled()
    } catch (e) {
      console.error(e)
    }
  }

  /**检查是否有打开的地图 */
  function isAnyMapOpened () {
    try {
      return SMap.isAnyMapOpened()
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 把指定地图中的图层添加到当前打开地图中
   * @param srcMapName
   * @param params { IsReplaceSymbol = true, Module = '', IsPrivate = true }
   * @returns {*}
   */
  function addMap (srcMapName = '', params = {}) {
    try {
      if (!srcMapName) return false
      // if (params.Module === undefined) {
      //   params.Module = ''
      // }
      // if (params.IsPrivate === undefined) {
      //   params.IsPrivate = true
      // }
      // if (params.IsReplaceSymbol === true) {
      //   params.IsPrivate = true
      // }
      return SMap.addMap(srcMapName, params)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 批量添加图层
   */
  function addLayers (datasetNames, datasourceName) {
    try {
      return SMap.addLayers(datasetNames, datasourceName)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 全副显示图层
   */
  function setLayerFullView (name) {
    try {
      return SMap.setLayerFullView(name)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导入符号库
   * @param path
   * @param isReplace 是否替换
   * @returns {*}
   */
  function importSymbolLibrary (path, isReplace = true) {
    try {
      return SMap.importSymbolLibrary(path, isReplace)
    } catch (e) {
      console.error(e)
    }
  }

  /**获取是否压盖 */
  function isOverlapDisplayed () {
    try {
      return SMap.isOverlapDisplayed()
    } catch (e) {
      console.error(e)
    }
  }

  /**设置是否压盖 */
  function setOverlapDisplayed (value) {
    try {
      return SMap.setOverlapDisplayed(value)
    } catch (e) {
      console.error(e)
    }
  }

  /**获取工作空间内地图的名称，返回一个数组，
   * path：工作空间的绝对路径
   * */
  function getMapsByFile (path) {
    try {
      return SMap.getMapsByFile(path)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 显示全幅
   * @returns {*|Promise.<void>}
   */
  function viewEntire () {
    try {
      return SMap.viewEntire()
    } catch (e) {
      console.error(e)
    }
  }

  // /**
  //  * 框选
  //  * 第一次设置框选；再次使用，会清除Selection
  //  * @returns {*}
  //  */
  // function selectByRectangle(){
  //   try{
  //     return SMap.selectByRectangle()
  //   }catch (e) {
  //     console.error(e)
  //   }
  // }

  /**
   * 设置Selection样式
   * @returns {*}
   */
  function setSelectionStyle (layerPath = '', style = {}) {
    try {
      return SMap.setSelectionStyle(layerPath, JSON.stringify(style))
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 清除Selection
   * @returns {*}
   */
  function clearSelection () {
    try {
      return SMap.clearSelection()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 开启动态投影
   * @returns {*|Promise.<void>}
   */
  function setDynamicProjection () {
    try {
      return SMap.setDynamicProjection()
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 新建标注数据集
   * @param name
   * @param userpath
   * @param type    标注图层类型（tour，normal）
   * @returns {*}
   */
  function newTaggingDataset (name, userpath, editable = true, type = 'normal') {
    try {
      return SMap.newTaggingDataset(name, userpath, editable, type)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 移除标注数据集
   * @returns {*|Promise.<void>}
   */
  function removeTaggingDataset (name,userpath) {
    try {
      return SMap.removeTaggingDataset(name,userpath)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导入标注数据集
   * @returns {*|Promise.<void>}
   */
  function openTaggingDataset (userpath) {
    try {
      return SMap.openTaggingDataset(userpath)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取默认标注
   * @returns {*|Promise.<void>}
   */
  function getDefaultTaggingDataset (userpath) {
    try {
      return SMap.getDefaultTaggingDataset(userpath)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 判断是否有标注图层
   * @returns {*|Promise.<void>}
   */
  function isTaggingLayer (userpath) {
    try {
      return SMap.isTaggingLayer(userpath)
    } catch (e) {
      console.error(e)
    }
  }


  /**
   * 判断是否有标注图层，并获取当前标注图层信息
   * @returns {*|Promise.<void>}
   */
  function getCurrentTaggingLayer (userpath) {
    try {
      return SMap.getCurrentTaggingLayer(userpath)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取当前标注
   * @returns {*|Promise.<void>}
   */
  function getCurrentTaggingDataset (name) {
    try {
      return SMap.getCurrentTaggingDataset(name)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取标注图层
   * @returns {*|Promise.<void>}
   */
  function getTaggingLayers (userpath) {
    try {
      return SMap.getTaggingLayers(userpath)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取标注图层个数
   * @returns {*|Promise.<void>}
   */
  function getTaggingLayerCount (userpath) {
    try {
      return SMap.getTaggingLayerCount(userpath)
    } catch (e) {
      console.error(e)
    }
  }


  /**
   * 设置标注面随机色
   * @returns {*|Promise.<void>}
   */
  function setTaggingGrid (name,userpath) {
    try {
      return SMap.setTaggingGrid(name,userpath)
    } catch (e) {
      console.error(e)
    }
  }


  /**
   * 设置MapControl 画笔样式
   */
  function setMapControlStyle(style) {
    try {
      if (!style) return
      if (style.strokeColor instanceof Array) {
        style.strokeColor = (style.strokeColor[3] * 255) << 24 | style.strokeColor[0] << 16 | style.strokeColor[1] << 8 | style.strokeColor[2]
      }
      
      function colorRgb2Hex (arr) {
        if (Platform.OS === 'ios') {
          return (arr[3] * 255) << 24 | arr[2] << 16 | arr[1] << 8 | arr[0]
        }
        return (arr[3] * 255) << 24 | arr[0] << 16 | arr[1] << 8 | arr[2]
      }
      if (style.nodeColor instanceof Array) {
        style.nodeColor = colorRgb2Hex(style.nodeColor)
      }
      if (style.strokeFillColor instanceof Array) {
        style.strokeFillColor = colorRgb2Hex(style.strokeFillColor)
      }
      if (style.objectColor instanceof Array) {
        style.objectColor = colorRgb2Hex(style.objectColor)
      }
      return SMap.setMapControlStyle(style)
    } catch (e) {
      console.error(e)
    }
  }


  /**
   * 设置标注默认的结点，线，面颜色
   *
   * @deprecated 用setMapControlStyle代替
   */
  function setLabelColor() {
    try {
      return SMap.setLabelColor()
    } catch (e) {
      console.error(e)
    }
  }

  // /**
  //  * 更新图例
  //  * @deprecated 用setMapControlStyle代替
  //  */
  // function updateLegend() {
  //   try {
  //     return SMap.updateLegend()
  //   } catch (e) {
  //     console.error(e)
  //   }
  // }

  /**
   * 初始化标绘符号库
   */
  function initPlotSymbolLibrary(plotSymbolPaths,isFirst,newName,isDefaultNew) {
    try {
      return SMap.initPlotSymbolLibrary(plotSymbolPaths,isFirst,newName,isDefaultNew)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置标绘符号
   */
  function setPlotSymbol(libId,symbolCode) {
    try {
      return SMap.setPlotSymbol(libId,symbolCode)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 新建cad图层
   */
  function addCadLayer(layerName){
    try {
      return SMap.addCadLayer(layerName)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导入标绘库数据
   * @param fromPath  标绘库数据路径
   */
  function importPlotLibData(fromPath){
    try{
      return SMap.importPlotLibData(fromPath)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 移除标绘库
   * @param plotSymbolIds  标绘库数据id
   */
  function removePlotSymbolLibraryArr(plotSymbolIds){
    try{
      return SMap.removePlotSymbolLibraryArr(plotSymbolIds)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 根据标绘库获取标绘库名称
   * @param {标绘库id} libId 
   */
  function getPlotSymbolLibNameById(libId){
    try{
      return SMap.getPlotSymbolLibNameById(libId)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 初始化态势推演
   */
  function initAnimation(){
    try{
      return SMap.initAnimation()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 读取态势推演xml文件
   */
  function readAnimationXmlFile(filePath){
    try{
      return SMap.readAnimationXmlFile(filePath)
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 播放态势推演动画
   */
  function animationPlay(){
    try{
      return SMap.animationPlay()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 暂停态势推演动画
   */
  function animationPause(){
    try{
      return SMap.animationPause()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 重置态势推演动画
   */
  function animationReset(){
    try{
      return SMap.animationReset()
    } catch (e){
      console.error(e)
    }
  }

   /**
   * 停止态势推演动画
   */
  function animationStop(){
    try{
      return SMap.animationStop()
    } catch (e){
      console.error(e)
    }
  }

  /**
   * 关闭态势推演动画
   */
  function animationClose(){
    try{
      return SMap.animationClose()
    } catch (e){
      console.error(e)
    }
  }
  

  

  /************************************** 地图编辑历史操作 ****************************************/
  /**
   * 地图撤销
   * @param index
   * @returns {*|Promise.<void>|Promise|Promise.<boolean>}
   */
  function undo (index) {
    try {
      if (index === undefined) {
        return SMap.undo()
      } else {
        return SMap.undoWithIndex(index)
      }

    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 地图恢复
   * @param index
   * @returns {*|Promise|Promise.<boolean>}
   */
  function redo (index) {
    try {
      if (index === undefined) {
        return SMap.redo()
      } else {
        return SMap.redoWithIndex(index)
      }
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 地图操作记录移除
   * @param index1 移除指定位置的记录
   * @param index2 若有，则移除 index1 到 index2 范围的记录
   * @returns {*}
   */
  function removeHistory (index1, index2) {
    try {
      if (index1 === undefined && index2 === undefined) return false
      if (index2 === undefined) {
        return SMap.remove(index1)
      } else {
        return SMap.removeRange(index1, index2)
      }
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 清除地图操作记录
   * @returns {*}
   */
  function clearHistory () {
    try {
      return SMap.clear()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 把对地图操作记录到历史
   * @returns {*}
   */
  function addMapHistory () {
    try {
      return SMap.addMapHistory()
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取地图操作记录数量
   * @returns {*}
   */
  function getMapHistoryCount () {
    try {
      return SMap.getMapHistoryCount()
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取当前地图操作记录index
   * @returns {*}
   */
  function getMapHistoryCurrentIndex () {
    try {
      return SMap.getMapHistoryCurrentIndex()
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 添加数据集属性字段
   * @returns {*|Promise.<void>}
   */
  function addRecordset (dataname, recname, name, userpath) {
    try {
      return SMap.addRecordset(dataname, recname, name, userpath)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置最小比例尺
   * @returns {*|Promise.<void>}
   */
  function setMinVisibleScale (value, number) {
    try {
      return SMap.setMinVisibleScale(value, number)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 设置最大比例尺
   * @returns {*|Promise.<void>}
   */
  function setMaxVisibleScale (value, number) {
    try {
      return SMap.setMaxVisibleScale(value, number)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 添加文字标注
   * @returns {*|Promise.<void>}
   */
  function addTextRecordset (value, name,userpath, x, y) {
    try {
      return SMap.addTextRecordset(value, name,userpath, x, y)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 获取屏幕坐标点
   * @returns {*|Promise.<void>}
   */
  function getGestureDetector () {
    try {
      return SMap.getGestureDetector()
    } catch (e) {
      console.error(e)
    }
  }

  let SMapExp = {
    getEnvironmentStatus,
    refreshMap,
    openWorkspace,
    openDatasource,
    saveWorkspace,
    closeWorkspace,
    closeMapControl,
    getMaps,
    setAction,
    getAction,
    openMap,
    saveMap,
    saveAsMap,
    isDatasourceOpen,

    /** 地图工具 **/
    zoom,
    setScale,
    enableRotateTouch,
    isEnableRotateTouch,
    isEnableSlantTouch,
    enableSlantTouch,
    setAntialias,
    isAntialias,
    setVisibleScalesEnabled,
    isVisibleScalesEnabled,
    clipMap,

    moveToCurrent,
    moveToPoint,
    closeMap,
    getUDBName,
    getUDBNameOfLabel,
    submit,
    cancel,
    setGestureDetector,
    deleteGestureDetector,
    addGeometrySelectedListener,
    removeGeometrySelectedListener,
    appointEditGeometry,
    getSymbolGroups,
    findSymbolsByGroups,
    isModified,
    getLayersNames,
    getMapName,
    saveMapToXML,
    openMapFromXML,
    getMapDatasourcesAlias,
    workspaceIsModified,
    getMapIndex,
    importWorkspace,
    getMapInfo,
    exportWorkspace,
    addDatasetToMap,
    saveMapName,
    importWorkspaceInfo,
    importDatasourceFile,
    openMapName,
    removeMap,
    mapIsModified,
    isAnyMapOpened,

    addMap,
    addLayers,
    setLayerFullView,
    importSymbolLibrary,
    isOverlapDisplayed,
    setOverlapDisplayed,
    getMapsByFile,
    viewEntire,
    exportWorkspaceByMap,
    setDynamicProjection,
    // selectByRectangle,
    setSelectionStyle,
    clearSelection,
    newTaggingDataset,
    removeTaggingDataset,
    openTaggingDataset,
    getDefaultTaggingDataset,
    getCurrentTaggingDataset,
    isTaggingLayer,
    getCurrentTaggingLayer,
    getTaggingLayers,
    getTaggingLayerCount,
    setTaggingGrid,
    setMapControlStyle,
    setLabelColor,
    //updateLegend,

    showMarker,
    deleteMarker,

    initPlotSymbolLibrary,
    setPlotSymbol,
    addCadLayer,
    importPlotLibData,
    removePlotSymbolLibraryArr,
    getPlotSymbolLibNameById,
    initAnimation,
    readAnimationXmlFile,
    animationPlay,
    animationPause,
    animationReset,
    animationStop,
    animationClose,
    undo,
    redo,
    removeHistory,
    clearHistory,
    addMapHistory,
    getMapHistoryCount,
    getMapHistoryCurrentIndex,
    
    addRecordset,
    setMinVisibleScale,
    setMaxVisibleScale,
    addTextRecordset,
    getGestureDetector,
    addLegendListener,
    removeLegendListener,
    addScaleChangeDelegate,
  }
  Object.assign(SMapExp, MapTool, LayerManager, Datasource, MapSettings)

  return SMapExp
})()
