/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native'
let CE = NativeModules.JSCollectorElement

import Geometry from './Geometry'
import Rectangle2D from './Rectangle2D'

/**
 * 采集对象类
 * */
export default class CollectorElement {
  
  /**
   * 添加点
   * @param point2D
   * @returns {Promise.<void>}
   */
  async addPoint (point2D) {
    try {
      await CE.addPoint(this._SMCollectorElementId, point2D._SMPoint2DId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 通过 Geomotry 构造采集对象
   * @param geometry
   * @returns {Promise}
   */
  async fromGeometry (geometry) {
    try {
      return await CE.fromGeometry(this._SMCollectorElementId, geometry._SMGeometryId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的边框范围
   * @returns {Promise.<Rectangle2D>}
   */
  async getBounds () {
    try {
      let id = await CE.getBounds(this._SMCollectorElementId)
      let rectangle2D = new Rectangle2D()
      rectangle2D._SMRectangle2DId = id
      return rectangle2D
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的 Geometry
   * @returns {Promise.<Geometry>}
   */
  async getGeometry () {
    try {
      let id = await CE.getGeometry(this._SMCollectorElementId)
      let geometry = new Geometry()
      geometry._SMGeometryId = id
      return geometry
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的几何对象类型
   * @returns {Promise}
   */
  async getGeometryType () {
    try {
      return await CE.getGeometryType(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的点串
   * @returns {Promise}
   */
  async getGeoPoints () {
    try {
      return await CE.getGeoPoints(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的ID
   * @returns {Promise.<Promise|Promise.<Promise|number>|number>}
   */
  async getID () {
    try {
      return await CE.getID(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的名称
   * @returns {Promise.<Promise|string|Promise.<Promise|string|Boolean|Promise.<void>>|Promise.<void>|Boolean>}
   */
  async getName () {
    try {
      return await CE.getName(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的备注信息
   * @returns {Promise}
   */
  async getNotes () {
    try {
      return await CE.getNotes(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取单击事件监听器
   * @returns {Promise.<void>}
   */
  async getOnClickListenner () {
    try {
      // await CE.getOnClickListenner(this._SMCollectorElementId)
      // TODO 获取单击事件监听器
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取点串分组信息（仅适用于通过Geomotry构造的动态数据）
   * @returns {Promise}
   */
  async getPart () {
    try {
      return await CE.getPart(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取采集对象的类型
   * @returns {Promise.<void>}
   */
  async getType () {
    try {
      await CE.getType(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取用户数据
   * @returns {Promise}
   */
  async getUserData () {
    try {
      return await CE.getUserData(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置采集对象的名称
   * @param valye
   * @returns {Promise.<void>}
   */
  async setName (valye) {
    try {
      await CE.setName(this._SMCollectorElementId, valye)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置采集对象的备注信息
   * @param value
   * @returns {Promise.<void>}
   */
  async setNotes (value) {
    try {
      await CE.setNotes(this._SMCollectorElementId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置点击监听器
   * @returns {Promise.<void>}
   */
  async setOnClickListenner () {
    try {
      // TODO 设置点击监听器
      // await CE.setOnClickListenner(this._SMCollectorElementId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置用户数据
   * @param value
   * @returns {Promise.<void>}
   */
  async setUserData (value) {
    try {
      await CE.setUserData(this._SMCollectorElementId, value)
    } catch (e) {
      console.error(e)
    }
  }
}
