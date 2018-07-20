/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: yangshanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/

import { NativeModules } from 'react-native'
let TUI = NativeModules.JSThemeUniqueItem

import GeoStyle from './GeoStyle'

/**
 * 单值专题图子项类
 */
export default class ThemeUniqueItem {
  
  async createObj() {
    try {
      let id = await TUI.createObj()
      let themeUniqueItem = new ThemeUniqueItem()
      themeUniqueItem._SMThemeUniqueItemId = id
      return themeUniqueItem
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 返回单值专题图子项的名称
   * @returns {Promise}
   */
  async getCaption() {
    try {
      return await TUI.getCaption(this._SMThemeUniqueItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回单值专题图子项的单值
   * @returns {Promise}
   */
  async getUnique() {
    try {
      return await TUI.getUnique(this._SMThemeUniqueItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回单值专题图子项所对应的显示风格
   * @returns {Promise}
   */
  async getStyle() {
    try {
      let geoStyleId = await TUI.getStyle(this._SMThemeUniqueItemId)
      let geoStyle = new GeoStyle()
      geoStyle._SMGeoStyleId = geoStyleId
      return geoStyle
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 回单值专题图子项是否可见
   * @returns {Promise}
   */
  async isVisible() {
    try {
      return await TUI.isVisible(this._SMThemeUniqueItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置单值专题图子项的名称
   * @param value
   * @returns {Promise.<void>}
   */
  async setCaption(value) {
    try {
      await TUI.setCaption(this._SMThemeUniqueItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置单值专题图子项的单值
   * @param value
   * @returns {Promise.<void>}
   */
  async setUnique(value) {
    try {
      await TUI.setUnique(this._SMThemeUniqueItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置单值专题图子项所对应的显示风格
   * @param geoStyle
   * @returns {Promise.<void>}
   */
  async setStyle(geoStyle) {
    try {
      await TUI.setStyle(this._SMThemeUniqueItemId, geoStyle.SMGeoStyleId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置单值专题图子项是否可见
   * @param value
   * @returns {Promise.<void>}
   */
  async setVisible(value) {
    try {
      await TUI.setVisible(this._SMThemeUniqueItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回单值专题图子项格式化字符串
   * @returns {Promise.<string>}
   */
  async toString() {
    try {
      return await TUI.toString(this._SMThemeUniqueItemId)
    } catch (e) {
      console.error(e)
    }
  }
}
