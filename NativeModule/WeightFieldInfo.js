/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let WFI = NativeModules.JSWeightFieldInfo;


/**
 * 权值字段信息类。
 * 存储了网络分析中权值字段的相关信息，包括正向权值字段与反向权值字段。权值字段是表示花费的权重值的字段。
 * 正向权值字段值表示沿弧段的起点到终点所需的耗费。反向权值字段值表示沿弧段的终点到起点所需的耗费。
 */
export default class WeightFieldInfo {
  async createObj() {
    try {
      let weightFieldInfoId = await WFI.createObj();
      let weightFieldInfo = new WeightFieldInfo();
      weightFieldInfo._SMWeightFieldInfoId = weightFieldInfoId;
      return weightFieldInfo;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回正向权值字段
   * @returns {Promise.<FacilityAnalyst>}
   */
  async getFTWeightField () {
    try {
      let ftWeightField = await WFI.getFTWeightField(this._SMWeightFieldInfoId);
      
      return ftWeightField;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回权值字段信息的名称
   * @returns {Promise.<Promise|string|Boolean|Promise.<void>>}
   */
  async getName () {
    try {
      let name = await WFI.getName(this._SMWeightFieldInfoId);
      
      return name;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回反向权值字段
   * @returns {Promise}
   */
  async getTFWeightField () {
    try {
      let tfWeightField = await WFI.getTFWeightField(this._SMWeightFieldInfoId);
      
      return tfWeightField;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置正向权值字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setFTWeightField (value) {
    try {
      await WFI.setFTWeightField(this._SMWeightFieldInfoId, value);
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
      await WFI.setName(this._SMWeightFieldInfoId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置反向权值字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setTFWeightField (value) {
    try {
      await WFI.setTFWeightField(this._SMWeightFieldInfoId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置反向权值字段
   * @returns {Promise.<Promise.<FacilityAnalyst>|Promise>}
   */
  async getFTWeightField () {
    try {
      let ftWeightField = await WFI.getFTWeightField(this._SMWeightFieldInfoId);
      
      return ftWeightField;
    } catch (e) {
      console.error(e);
    }
  }
}
