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
  
  constructor(){
    super()
    Object.defineProperty(this,"_SMThemeRangeId",{
      get:function () {
        return this._SMThemeId
      },
      set:function (_SMThemeRangeId) {
        this._SMThemeId = _SMThemeRangeId;
      }
    })
  }
  
  async createObj(){
    try{
      let id = await TR.createObj();
      let themeRange = new ThemeRange();
      themeRange._SMThemeRangeId = id;
      return themeRange;
    }catch (e){
      console.error(e);
    }
  }

  async createObjClone(theme){
    try{
      let id = await TR.createObjClone(theme._SMThemeId);
      let themeRange = new ThemeRange();
      themeRange._SMThemeRangeId = id;
      return themeRange;
    }catch (e){
      console.error(e);
    }
  }
  
  async dispose() {
    try {
      return await TR.dispose(this._SMThemeRangeId)
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
      await TR.setRangeExpression(this._SMThemeRangeId, value)
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
      return await TR.getRangeExpression(this._SMThemeRangeId)
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
      return await TR.addToHead(this._SMThemeRangeId, item._SMThemeRangeItemId)
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
      return await TR.addToTail(this._SMThemeRangeId, item._SMThemeRangeItemId)
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
      return await TR.getCount(this._SMThemeRangeId)
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
      let id = await TR.getItem(this._SMThemeRangeId, value)
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
      return await TR.toString(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数和颜色渐变模式生成默认的分段专题图
   * @param datasetVector Object
   * @param expression String
   * @param rangeMode Number
   * @param rangeParameter Number
   * @param colorGradientType(option)
   * @returns {Promise.<ThemeUnique>}
   */
  async makeDefault() {
    try {
      let id
      if (arguments[4] && typeof arguments[4] === 'number') {
        id = await TR.makeDefaultWithColorGradient(arguments[0]._SMDatasetVectorId, arguments[1], arguments[2], arguments[3], arguments[4])
      } else {
        id = await TR.makeDefault(arguments[0]._SMDatasetVectorId, arguments[1], arguments[2], arguments[3])
      }
      let themeRange = new ThemeRange()
      themeRange._SMThemeRangeId = id
      return themeRange
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置范围分段专题图的舍入精度
   * @param value
   * @returns {Promise.<void>}
   */
  async setPrecision(value) {
    try {
      await TR.setPrecision(this._SMThemeRangeId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 对分段专题图中分段的风格进行反序显示
   * @returns {Promise.<void>}
   */
  async reverseStyle() {
    try {
      await TR.reverseStyle(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置是否固定偏移量
   * @param value
   * @returns {Promise.<void>}
   */
  async setOffsetFixed(value) {
    try {
      await TR.setOffsetFixed(this._SMThemeRangeId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置X偏移量
   * @param value
   * @returns {Promise.<void>}
   */
  async setOffsetX(value) {
    try {
      await TR.setOffsetX(this._SMThemeRangeId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回X偏移量
   * @returns {Promise.<void>}
   */
  async getOffsetX() {
    try {
      await TR.getOffsetX(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置Y偏移量
   * @param value
   * @returns {Promise.<void>}
   */
  async setOffsetY(value) {
    try {
      await TR.setOffsetY(this._SMThemeRangeId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回Y偏移量
   * @returns {Promise.<void>}
   */
  async getOffsetY() {
    try {
      await TR.getOffsetY(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 根据给定的拆分分段值将一个指定序号的分段专题图子项拆分成两个具有各自风格和名称的分段专题图子项
   * @param index
   * @param splitValue
   * @param style1
   * @param caption1
   * @param style2
   * @param caption2
   * @returns {Promise.<Promise|Array|*>}
   */
  async split(index, splitValue, style1, caption1, style2, caption2) {
    try {
      return await TR.split(this._SMThemeRangeId, index, splitValue, style1._SMGeoStyleId, caption1, style2._SMGeoStyleId, caption2)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 合并一个从指定序号起始的给定个数的分段专题图子项，并赋给合并后分段专题图子项显示风格和名称
   * @param index
   * @param count
   * @param style
   * @param caption
   * @returns {Promise.<Promise.<Promise|Array|*>|Array|*>}
   */
  async merge(index, count, style, caption) {
    try {
      return await TR.split(this._SMThemeRangeId, index, count, style._SMGeoStyleId, caption)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回是否固定偏移量
   * @returns {Promise}
   */
  async isOffsetFixed() {
    try {
      return await TR.isOffsetFixed(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取自定义段长
   * @returns {Promise}
   */
  async getCustomInterval() {
    try {
      return await TR.getCustomInterval(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取范围分段专题图的舍入精度
   * @returns {Promise}
   */
  async getPrecision() {
    try {
      return await TR.getPrecision(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回当前的分段模式
   * @returns {Promise}
   */
  async getRangeMode() {
    try {
      return await TR.getRangeMode(this._SMThemeRangeId)
    } catch (e) {
      console.error(e)
    }
  }
}
