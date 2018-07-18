/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let WFIs = NativeModules.JSWeightFieldInfos;

import WeightFieldInfo from './WeightFieldInfo'
/**
 * 权值字段信息集合类。该类是权值字段信息对象（WeightFieldInfo）的集合，用于对权值字段信息对象进行管理，如添加、删除、获取指定名称或索引的权值字段信息对象等
 */
export default class JSWeightFieldInfos {
  async createObj() {
    try {
      let weightFieldInfosId = await WFIs.createObj();
      let weightFieldInfos = new JSWeightFieldInfos();
      weightFieldInfos._SMWeightFieldInfosId = weightFieldInfosId;
      return weightFieldInfos;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 用于在权值字段信息集合中加入一个元素
   * @param weightFieldInfo
   * @returns {Promise.<void>}
   */
  async add(weightFieldInfo) {
    try {
      await WFIs.add(this._SMWeightFieldInfosId, weightFieldInfo._SMWeightFieldInfoId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 用于从权值字段信息集合移除全部权值字段信息对象
   * @returns {Promise.<*>}
   */
  async clear () {
    try {
      await WFIs.clear(this._SMWeightFieldInfosId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据名称/序号返回权值字段信息集合对象中的权值字段信息对象
   * @param key
   * @returns {Promise.<WeightFieldInfo>}
   */
  async get (key) {
    try {
      let weightFieldInfoId
      if (key instanceof Number) {
        weightFieldInfoId = await WFIs.getByIndex(this._SMWeightFieldInfosId, key);
      } else {
        weightFieldInfoId = await WFIs.getByName(this._SMWeightFieldInfosId, key);
      }
      let weightFieldInfo = new WeightFieldInfo();
      weightFieldInfo._SMWeightFieldInfoId = weightFieldInfoId;
      
      return weightFieldInfo;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回给定的权值字段信息集合中元素的总数
   * @returns {Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>}
   */
  async getCount () {
    try {
      let count = await WFIs.getCount(this._SMWeightFieldInfosId);
      return count
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置权值字段信息的名称
   * @param value
   * @returns {Promise.<void>}
   */
  async setName (value) {
    try {
      await WFIs.setName(this._SMWeightFieldInfosId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据指定的名称，返回权值字段信息对象的序号
   * @param index
   * @returns {Promise.<Promise|*|number|Number>}
   */
  async indexOf (index) {
    try {
      let index = await WFIs.indexOf(this._SMWeightFieldInfosId, index);
      return index
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 从权值字段信息集合中移除指定名称/序号的项
   * @param index
   * @returns {Promise}
   */
  async remove (key) {
    try {
      let result
      if (key instanceof Number) {
        result = await WFIs.removeByIndex(this._SMWeightFieldInfosId, key);
      } else {
        result = await WFIs.removeByName(this._SMWeightFieldInfosId, key);
      }
      
      return result;
    } catch (e) {
      console.error(e);
    }
  }
}
