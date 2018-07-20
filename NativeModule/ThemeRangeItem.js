/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: yangshanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/

import { NativeModules } from 'react-native'
let TRI = NativeModules.JSThemeRangeItem

import GeoStyle from './GeoStyle'

/**
 * 分段专题图子项类
 */
export default class ThemeRangeItem {
  
  async createObj() {
    try {
      let id = await TRI.createObj()
      let themeRangeItem = new ThemeRangeItem()
      themeRangeItem._SMThemeRangeItemId = id
      return themeRangeItem
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 返回分段专题图子项的名称
   * @returns {Promise}
   */
  async getCaption() {
    try {
      return await TRI.getCaption(this._SMThemeRangeItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回分段专题图子项的分段起始值
   * @returns {Promise}
   */
  async getEnd() {
    try {
      return await TRI.getEnd(this._SMThemeRangeItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回分段专题图子项所对应的显示风格
   * @returns {Promise}
   */
  async getStyle() {
    try {
      let geoStyleId = await TRI.getStyle(this._SMThemeRangeItemId)
      let geoStyle = new GeoStyle()
      geoStyle.SMGeoStyleId = geoStyleId
      return geoStyle
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 回分段专题图子项是否可见
   * @returns {Promise}
   */
  async isVisible() {
    try {
      return await TRI.isVisible(this._SMThemeRangeItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置分段专题图子项的名称
   * @param value
   * @returns {Promise.<void>}
   */
  async setCaption(value) {
    try {
      await TRI.setCaption(this._SMThemeRangeItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置分段专题图子项的分段终止值
   * @param value
   * @returns {Promise.<void>}
   */
  async setEnd(value) {
    try {
      await TRI.setEnd(this._SMThemeRangeItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置分段专题图子项的分段起始值
   * @param value
   * @returns {Promise.<void>}
   */
  async setStart(value) {
    try {
      await TRI.setStart(this._SMThemeRangeItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置分段专题图子项所对应的显示风格
   * @param geoStyle
   * @returns {Promise.<void>}
   */
  async setStyle(geoStyle) {
    try {
      await TRI.setStyle(this._SMThemeRangeItemId, geoStyle.SMGeoStyleId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置分段专题图子项是否可见
   * @param value
   * @returns {Promise.<void>}
   */
  async setVisible(value) {
    try {
      await TRI.setVisible(this._SMThemeRangeItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回分段专题图子项格式化字符串
   * @returns {Promise.<string>}
   */
  async toString() {
    try {
      return await TRI.toString(this._SMThemeRangeItemId)
    } catch (e) {
      console.error(e)
    }
  }
}
