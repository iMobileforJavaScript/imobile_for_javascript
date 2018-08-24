/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: yangshanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/

import { NativeModules } from 'react-native'
let TU = NativeModules.JSThemeUnique

import Theme from './Theme'
import ThemeUniqueItem from './ThemeUniqueItem'
import GeoStyle from './GeoStyle'

/**
 * 单值专题图子项类
 */
export default class ThemeUnique extends Theme {

  constructor() {
    super()
    Object.defineProperty(this, "_SMThemeUniqueId", {
      get: function () {
        return this._SMThemeId
      },
      set: function (_SMThemeUniqueId) {
        this._SMThemeId = _SMThemeUniqueId;
      }
    })
  }

  async createObj() {
    try {
      let id = await TU.createObj();
      let themeUnique = new ThemeUnique();
      themeUnique._SMThemeUniqueId = id;
      return themeUnique;
    } catch (e) {
      console.error(e);
    }
  }

  async createObjClone(theme) {
    try {
      let id = await TU.createObjClone(theme._SMThemeId);
      let themeUnique = new ThemeUnique();
      themeUnique._SMThemeUniqueId = id;
      return themeUnique;
    } catch (e) {
      debugger
      console.error(e);
    }
  }

  async dispose() {
    try {
      if (!this._SMThemeUniqueId) return
      return await TU.dispose(this._SMThemeUniqueId)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 根据给定的矢量数据集、单值专题图字段表达式和颜色渐变模式生成默认的单值专题图
   * @param datasetVector
   * @param expression
   * @param colorGradientType / colors (option)
   * @returns {Promise.<ThemeUnique>}
   */
  async makeDefault() {
    try {
      let id
      if (arguments[2] && typeof arguments[2] === 'number') {
        id = await TU.makeDefaultWithColorGradient(arguments[0]._SMDatasetVectorId, arguments[1], arguments[2])
      } else if (arguments[2] && arguments[2] instanceof Array) {
        id = await TU.makeDefaultWithColors(arguments[0]._SMDatasetVectorId, arguments[1], arguments[2])
      } else {
        id = await TU.makeDefault(arguments[0]._SMDatasetVectorId, arguments[1])
      }
      let themeUnique = new ThemeUnique()
      themeUnique._SMThemeUniqueId = id
      return themeUnique
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 删除单值专题图的子项
   * @returns {Promise.<void>}
   */
  async clear() {
    try {
      await TU.clear(this._SMThemeUniqueId)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 返回单值专题图中分段的个数
   * @returns {Promise.<*>}
   */
  async getCount() {
    try {
      return await TU.getCount(this._SMThemeUniqueId)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 把一个单值专题图子项添加到单值列表的开头
   * @param item
   * @returns {Promise}
   */
  async getItem(value) {
    try {
      let id = await TU.getItem(this._SMThemeUniqueId, value)
      let item = new ThemeUniqueItem()
      item._SMThemeUniqueItemId = id
      return item
    } catch (e) {
      console.error(e)
      return false
    }
  }

  /**
   * 添加单值专题图子项
   * @param item
   * @returns {Promise.<*>}
   */
  async add(item) {
    try {
      return await TU.add(this._SMThemeUniqueId, item._SMThemeUniqueItemId)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 删除一个指定序号的单值专题图子项
   * @param index
   * @returns {Promise.<*>}
   */
  async remove(index) {
    try {
      return await TU.remove(this._SMThemeUniqueId, index)
    } catch (e) {
      console.error(e)
      return false
    }
  }

  /**
   * 将给定的单值专题图子项插入到指定序号的位置
   * @param index
   * @param item
   * @returns {Promise.<*>}
   */
  async insert(index, item) {
    try {
      return await TU.insert(this._SMThemeUniqueId, index, item._SMThemeUniqueItemId)
    } catch (e) {
      console.error(e)
      return false
    }
  }

  /**
   * 返回单值专题图中指定分段字段值在当前分段序列中的序号
   * @param value
   * @returns {Promise.<*>}
   */
  async indexOf(value) {
    try {
      return await TU.indexOf(this._SMThemeUniqueId, value)
    } catch (e) {
      console.error(e)
      return false
    }
  }

  /**
   * 返回单值专题图中指定分段字段值在当前分段序列中的序号
   * @returns {Promise.<*>}
   */
  async getDefaultStyle() {
    try {
      let styleId = await TU.getDefaultStyle(this._SMThemeUniqueId)
      let style = new GeoStyle()
      style._SMGeoStyleId = styleId
      return style
    } catch (e) {
      console.error(e)
      return false
    }
  }

  /**
   * 返回单值专题图字段表达式
   * @returns {Promise.<*>}
   */
  async getUniqueExpression() {
    try {
      return await TU.getUniqueExpression(this._SMThemeUniqueId)
    } catch (e) {
      console.error(e)
      return false
    }
  }

  /**
   * 设置单值专题图字段表达式
   * @param expression
   * @returns {Promise.<*>}
   */
  async setUniqueExpression(expression) {
    try {
      await TU.setUniqueExpression(this._SMThemeUniqueId, expression)
    } catch (e) {
      console.error(e)
      return false
    }
  }
}
