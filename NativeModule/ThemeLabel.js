/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: yangshanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/

import { NativeModules } from 'react-native'
let TL = NativeModules.JSThemeLabel

import Theme from './Theme'
import TextStyle from './TextStyle'

/**
 * 标签专题图子项类
 */
export default class ThemeLabel extends Theme {
  
  async createObj(){
    try{
      let id = await TL.createObj();
      let themeLabel = new ThemeLabel();
      themeLabel._SMThemeId = id;
      return themeLabel;
    }catch (e){
      console.error(e);
    }
  }
  
  /**
   * 返回标签专题图子项的名称
   * @returns {Promise}
   */
  async getCaption() {
    try {
      return await TL.getCaption(this._SMThemeId)
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
      return await TL.getEnd(this._SMThemeId)
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
      let textStyleId = await TL.getStyle(this._SMThemeId)
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
      return await TL.isVisible(this._SMThemeId)
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
      await TL.setCaption(this._SMThemeId, value)
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
      await TL.setEnd(this._SMThemeId, value)
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
      await TL.setStart(this._SMThemeId, value)
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
      await TL.setStyle(this._SMThemeId, textStyle._SMTextStyleId)
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
      await TL.setVisible(this._SMThemeId, value)
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
      return await TL.toString(this._SMThemeId)
    } catch (e) {
      console.error(e)
    }
  }
}
