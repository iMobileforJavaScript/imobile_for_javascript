/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import { NativeModules } from 'react-native';
let S = NativeModules.JSSelection;
import Recordset from './Recordset.js';

/**
 * @class Selection
 * @description 选择集类。该类用于处理地图上被选中的对象。
 */
export default class Selection {
  /**
   * 将记录集转换成Selection
   * @deprecated
   * @memberOf Selection
   * @param {object} recordset - 记录集
   * @returns {Promise.<Promise.fromRecordset>}
   */
  async fromRecordset(recordset) {
    try {
      let { fromRecordset } = await S.fromRecordset(this._SMSelectionId, recordset._SMRecordsetId);
      return fromRecordset;
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 设置样式风格
   * @memberOf Selection
   * @param {object} geoStyle - 样式风格
   * @returns {Promise.<void>}
   */
  async setStyle(geoStyle) {
    try {
      await S.setStyle(this._SMSelectionId, geoStyle._SMGeoStyleId);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 清空选择对象
   * @memberOf Selection
   * @returns {Promise.<void>}
   */
  async clear() {
    try {
      await S.clear(this._SMSelectionId);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 转成recordset数据集
   * @deprecated
   * @memberOf Selection
   * @returns {Promise.<Recordset>}
   */
  async toRecordset() {
    try {
      var { recordsetId } = await S.toRecordset(this._SMSelectionId);
      var recordset = new Recordset();
      recordset._SMRecordsetId = recordsetId;
      return recordset;
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 从查询结果获取地图被选要素
   * @deprecated
   * @memberOf Selection
   * @param {object} result - 经DataVector的query方法查询出的结果
   * @returns {Promise.<Promise.fromRecordset>}
   */
  async fromQueryResult(result) {
    try {
      let { fromRecordset } = await S.fromRecordset(this._SMSelectionId, result._SMRecordsetId);
      return fromRecordset;
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 获取选中集合数量
   * @returns {Promise.<void>}
   */
  async getCount() {
    try {
      let { count } = await S.getCount(this._SMSelectionId)
      return count
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 用于向选择集中加入几何对象
   * @param id
   * @returns {Promise.<void>}
   */
  async add(id) {
    try {
      let index = await S.add(this._SMSelectionId, id)
      return index
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 用于从选择集中删除一个几何对象，该几何对象由原来的呈选中状态变为非选中状态
   * @param id  要删除几何对象的 ID 号（即其属性数据中 SmID 字段的值）
   * @returns {Promise.<void>}
   */
  async remove(id) {
    try {
      let result = await S.remove(this._SMSelectionId, id)
      return result
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 用于从选择集中删除指定的若干几何对象，这些几何对象由原来的选中状态变为非选中状态
   * @param index  要删除的第一个几何对象的序列号
   * @param count  要删除的几何对象的个数
   * @returns {Promise.<Promise.<void>|Promise|Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>|Promise.<Promise.count>|Boolean|Promise.<number>>}
   */
  async removeRange(index, count) {
    try {
      let count = await S.removeRange(this._SMSelectionId, index, count)
      return count
    } catch (e) {
      console.log(e);
    }
  }
}
