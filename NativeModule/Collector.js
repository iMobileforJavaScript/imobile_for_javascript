/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules, NativeEventEmitter } from 'react-native'
let C = NativeModules.JSCollector
let GPSElementType = NativeModules.JSGPSElementType

import Geometry from './Geometry'
import ElementLine from './ElementLine'
import ElementPoint from './ElementPoint'
import ElementPolygon from './ElementPolygon'
import Point2D from './Point2D'
import GeoStyle from './GeoStyle'

const nativeEvt = new NativeEventEmitter(C)

/**
 * GPS式几何对象采集类
 * */
export default class Collector {
  async createObj() {
    try {
      let collectorId = await C.createObj()
      let collector = new Collector()
      collector._SMCollectorId = collectorId
      return collector
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 添加点,GPS获取的点
   * @param map
   *
   * @param point2D
   * --------------------
   * @param x
   * @param y
   *
   * @returns {Promise.<boolean>}
   */
  async addGPSPoint () {
    try {
      let result = false
      if (arguments.length === 3) {
        // let point2D = await new Point2D().createObj(arguments[1], arguments[2])
        // console.warn('addGPSPoint:' + result + ': '
        //   + (await point2D.getX()) + ' | ' + (await point2D.getY()))
        result = await C.addGPSPointByXY(this._SMCollectorId, arguments[0]._SMMapId, arguments[1], arguments[2])
      } else if (arguments.length === 2) {
        result = await C.addGPSPointByPoint(this._SMCollectorId, arguments[0]._SMMapId, arguments[1]._SMPoint2DId)
      } else {
        result = await C.addGPSPoint(this._SMCollectorId)
      }
      
      return result
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 关闭GPS
   * @returns {Promise.<void>}
   */
  async closeGPS () {
    try {
      await C.closeGPS(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 创建指定类型的采集对象
   * @param type
   * @returns {Promise.<Promise|*|Element|{$$typeof, type, key, ref, props, _owner}>}
   */
  async createElement (type) {
    try {
      return await C.createElement(this._SMCollectorId, type)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取当前的几何对象
   * @returns {Promise.<Geometry>}
   */
  async getCurGeometry () {
    try {
      let id = await C.getCurGeometry(this._SMCollectorId)
      let geometry = new Geometry()
      geometry._SMGeometryId = id
      return geometry
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取当前编辑节点的宽度,单位是10mm
   * @returns {Promise}
   */
  async getEditNodeWidth () {
    try {
      return await C.getEditNodeWidth(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取当前采集对象
   * @returns {Promise.<void>}
   */
  async getElement () {
    try {
      let { id, type } = await C.getElement(this._SMCollectorId)
      let element
      switch (type) {
        case GPSElementType.POINT:
          element = new ElementPoint()
          element._SMElementId = id
          break
        case GPSElementType.LINE:
          element = new ElementLine()
          element._SMElementId = id
          break
        case GPSElementType.POLYGON:
          element = new ElementPolygon()
          element._SMElementId = id
          break
      }
      return element
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取当前位置
   * @returns {Promise.<Point2D>}
   */
  async getGPSPoint () {
    try {
      let id = await C.getGPSPoint(this._SMCollectorId)
      let point2D = new Point2D()
      point2D._SMPoint2DId = id
      return point2D
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取绘制风格采集对象的绘制风格
   * @returns {Promise.<GeoStyle>}
   */
  async getStyle () {
    try {
      let id = await C.getStyle(this._SMCollectorId)
      let geoStyle = new GeoStyle()
      geoStyle._SMGeoStyleId = id
      return geoStyle
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取是否采用手势打点
   * @returns {Promise}
   * @constructor
   */
  async IsSingleTapEnable () {
    try {
      return await C.IsSingleTapEnable(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 定位地图到当前位置
   * @returns {Promise.<void>}
   */
  async moveToCurrent () {
    try {
      await C.moveToCurrent(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 定位地图到当前位置
   * @returns {Promise}
   */
  async openGPS () {
    try {
      return await C.openGPS(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 重做操作
   * @returns {Promise}
   */
  async redo () {
    try {
      await C.redo(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置定位变化监听
   * @param handlers
   * @returns {Promise.<void>}
   */
  async setCollectionChangedListener (handlers) {
    try {
      if(handlers){
        await C.setCollectionChangedListener(this._SMCollectorId)
      } else{
        throw new Error("setGestureDetector need callback functions as first two argument!")
      }
      if(typeof handlers.collectionChanged === "function"){
        nativeEvt.addListener("com.supermap.RN.Mapcontrol.collection_change",function (e) {
          let point2D = new Point2D()
          point2D._SMPoint2DId = e.pointId
          handlers.collectionChanged({
            ...e,
            point2D,
          })
        })
      }
      if(typeof handlers.onSensorChanged === "function"){
        nativeEvt.addListener("com.supermap.RN.Mapcontrol.collection_sensor_change",function (e) {
          handlers.onSensorChanged(e)
        })
      }
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置用于存储采集数据的数据集
   * @param dataset
   * @returns {Promise.<void>}
   */
  async setDataset (dataset) {
    try {
      await C.setDataset(this._SMCollectorId, dataset._SMDatasetId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置当前编辑节点的宽度,单位是10mm
   * @param value
   * @returns {Promise.<void>}
   */
  async setEditNodeWidth (value) {
    try {
      await C.setEditNodeWidth(this._SMCollectorId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置地图控件
   * @param mapControl
   * @returns {Promise.<void>}
   */
  async setMapControl (mapControl) {
    try {
      await C.setMapControl(this._SMCollectorId, mapControl._SMMapControlId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置GPS式几何对象采集类关联的主控件
   * @param mapView
   * @returns {Promise.<void>}
   */
  async setMapView (mapView) {
    try {
      await C.setMapView(this._SMCollectorId, mapView._SMMapViewId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置是否采用手势打点
   * @param value
   * @returns {Promise.<void>}
   */
  async setSingleTapEnable (value) {
    try {
      await C.setSingleTapEnable(this._SMCollectorId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置采集对象的绘制风格
   * @param style
   * @returns {Promise.<void>}
   */
  async setStyle (style) {
    try {
      await C.setStyle(this._SMCollectorId, style._SMGeoStyleId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 显示提示信息
   * @param value
   * @returns {Promise.<void>}
   */
  async showInfo (value) {
    try {
      await C.showInfo(this._SMCollectorId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 提交
   * @returns {Promise.<Promise|*|{default, type}|Promise.<Promise|*|{phasedRegistrationNames}>>}
   */
  async submit () {
    try {
      return await C.submit(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 回退操作
   * @returns {Promise.<void>}
   */
  async undo () {
    try {
      await C.undo(this._SMCollectorId)
    } catch (e) {
      console.error(e)
    }
  }
}
