/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: yangshanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/

import { NativeModules } from 'react-native'
let TR = NativeModules.JSThemeRange

import Theme from './Theme'
import ThemeRangeItem from './ThemeRangeItem'

/**
 * 分段专题图子项类
 */
export default class ThemeRange extends Theme {
  
  async createObj(){
    try{
      let id = await TR.createObj();
      let themeRange = new ThemeRange();
      themeRange._SMThemeId = id;
      return themeRange;
    }catch (e){
      console.error(e);
    }
  }
  
  async dispose() {
    try {
      return await TR.dispose(this._SMThemeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置分段字段表达式
   * @param value
   * @returns {Promise}
   */
  async setRangeExpression(value) {
    try {
      await TR.setRangeExpression(this._SMThemeId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回分段字段表达式
   * @param value
   * @returns {Promise}
   */
  async getRangeExpression() {
    try {
      return await TR.getRangeExpression(this._SMThemeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 把一个分段专题图子项添加到分段列表的开头
   * @param item
   * @returns {Promise}
   */
  async addToHead(item) {
    try {
      return await TR.addToHead(this._SMThemeId, item._SMThemeRangeItemId)
    } catch (e) {
      console.error(e)
      return false
    }
  }
  
  /**
   * 把一个分段专题图子项添加到分段列表的尾部
   * @param item
   * @returns {Promise}
   */
  async addToTail(item) {
    try {
      return await TR.addToTail(this._SMThemeId, item._SMThemeRangeItemId)
    } catch (e) {
      console.error(e)
      return false
    }
  }
  
  /**
   * 返回分段专题图中分段的个数
   * @returns {Promise.<Promise|Promise.<Promise|Boolean|Promise.<void>|Promise.<Promise.count>|Promise.<number>|Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>>|Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>|Promise.<Promise.count>|Promise.<number>|Promise.<void>|*>}
   */
  async getCount() {
    try {
      return await TR.getCount(this._SMThemeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回指定序号的分段专题图中单值专题图子项
   * @returns {Promise.<Promise|Promise.<Promise|Boolean|Promise.<void>|Promise.<Promise.count>|Promise.<number>|Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>>|Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>|Promise.<Promise.count>|Promise.<number>|Promise.<void>|*>}
   */
  async getItem(value) {
    try {
      let id = await TR.getItem(this._SMThemeId, value)
      let item = new ThemeRangeItem()
      item._SMThemeRangeItemId = id
      return item
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
      return await TR.toString(this._SMThemeId)
    } catch (e) {
      console.error(e)
    }
  }
}
