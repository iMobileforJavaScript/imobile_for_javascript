/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let SC = NativeModules.JSSupplyCenter;

export default class SupplyCenter {
  
  async createObj() {
    try {
      let supplyCenterId = await SC.createObj();
      let supplyCenter = new SupplyCenter();
      supplyCenter._SMSupplyCenterId = supplyCenterId;
      return supplyCenter;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回资源供给中心点的 ID
   * @returns {Promise.<Promise|number>}
   */
  async getID() {
    try {
      return await SC.getID(this._SMSupplyCenterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回资源供给中心的最大耗费（阻值）
   * @returns {Promise.<Promise|number>}
   */
  async getMaxWeight() {
    try {
      return await SC.getMaxWeight(this._SMSupplyCenterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回资源供给中心的资源量
   * @returns {Promise.<Promise|number>}
   */
  async getResourceValue() {
    try {
      return await SC.getResourceValue(this._SMSupplyCenterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回网络分析中资源供给中心点的类型
   * @returns {Promise.<Promise|number>}
   */
  async getType() {
    try {
      return await SC.getType(this._SMSupplyCenterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置资源供给中心点的 ID
   * @param id
   * @returns {Promise}
   */
  async setID(id) {
    try {
      return await SC.setID(this._SMSupplyCenterId, id);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置资源供给中心的最大耗费（阻值）
   * @param value
   * @returns {Promise}
   */
  async setMaxWeight(value) {
    try {
      return await SC.setMaxWeight(this._SMSupplyCenterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置资源供给中心的资源量
   * @param value
   * @returns {Promise}
   */
  async setResourceValue(value) {
    try {
      return await SC.setResourceValue(this._SMSupplyCenterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置网络分析中资源供给中心点的类型
   * @param value
   * @returns {Promise}
   */
  async setType(value) {
    try {
      return await SC.setType(this._SMSupplyCenterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
}
