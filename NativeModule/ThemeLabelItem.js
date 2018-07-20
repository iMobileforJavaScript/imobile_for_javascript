/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: yangshanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/

import { NativeModules } from 'react-native'
let TLI = NativeModules.JSThemeLabelItem

import TextStyle from './TextStyle'

/**
 * 标签专题图子项类
 */
export default class ThemeLabelItem {
  
  async createObj() {
    try {
      let id = await TLI.createObj()
      let themeLabelItem = new ThemeLabelItem()
      themeLabelItem._SMThemeLabelItemId = id
      return themeLabelItem
    } catch (e) {
      console.log(e)
    }
  }
  
  /**
   * 返回标签专题图子项的名称
   * @returns {Promise}
   */
  async getCaption() {
    try {
      return await TLI.getCaption(this._SMThemeLabelItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回标签专题图子项的分段起始值
   * @returns {Promise}
   */
  async getEnd() {
    try {
      return await TLI.getEnd(this._SMThemeLabelItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回标签专题图子项所对应的显示风格
   * @returns {Promise}
   */
  async getStyle() {
    try {
      let textStyleId = await TLI.getStyle(this._SMThemeLabelItemId)
      let textStyle = new TextStyle()
      textStyle._SMTextStyleId = textStyleId
      return textStyle
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 回标签专题图子项是否可见
   * @returns {Promise}
   */
  async isVisible() {
    try {
      return await TLI.isVisible(this._SMThemeLabelItemId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置标签专题图子项的名称
   * @param value
   * @returns {Promise.<void>}
   */
  async setCaption(value) {
    try {
      await TLI.setCaption(this._SMThemeLabelItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置标签专题图子项的分段终止值
   * @param value
   * @returns {Promise.<void>}
   */
  async setEnd(value) {
    try {
      await TLI.setEnd(this._SMThemeLabelItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置标签专题图子项的分段起始值
   * @param value
   * @returns {Promise.<void>}
   */
  async setStart(value) {
    try {
      await TLI.setStart(this._SMThemeLabelItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置标签专题图子项所对应的显示风格
   * @param textStyle
   * @returns {Promise.<void>}
   */
  async setStyle(textStyle) {
    try {
      await TLI.setStyle(this._SMThemeLabelItemId, textStyle._SMTextStyleId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置标签专题图子项是否可见
   * @param value
   * @returns {Promise.<void>}
   */
  async setVisible(value) {
    try {
      await TLI.setVisible(this._SMThemeLabelItemId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回标签专题图子项格式化字符串
   * @returns {Promise.<string>}
   */
  async toString() {
    try {
      return await TLI.toString(this._SMThemeLabelItemId)
    } catch (e) {
      console.error(e)
    }
  }
}
