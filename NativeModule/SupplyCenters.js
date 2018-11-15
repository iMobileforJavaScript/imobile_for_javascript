/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let SCs = NativeModules.JSSupplyCenters;

import SupplyCenter from './SupplyCenter'

export default class SupplyCenters {
  
  async createObj() {
    try {
      let supplyCentersId = await SCs.createObj();
      let supplyCenters = new SupplyCenters();
      supplyCenters._SMSupplyCentersId = supplyCentersId;
      return supplyCenters;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加资源供给中心对象到此集合中，添加成功返回被添加对象的序号
   * @param supplyCenter
   * @returns {Promise.<*>}
   */
  async add(supplyCenter) {
    try {
      let index = await SCs.add(this._SMSupplyCentersId, supplyCenter._SMSupplyCenterId);
      return index
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 以数组形式向集合中添加资源供给中心对象，添加成功，返回添加的资源供给中心对象的个数
   * @param supplyCenterIds
   * @returns {Promise.<*>}
   */
  async addRange(supplyCenterIds = []) {
    try {
      let ids = []
      supplyCenterIds.forEach(obj => {
        ids.push(obj._SMSupplyCenterId)
      })
      let count = await SCs.addRange(this._SMSupplyCentersId, ids);
      return count
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 清空集合中的资源供给中心对象
   * @returns {Promise.<void>}
   */
  async clear() {
    try {
      await SCs.clear(this._SMSupplyCentersId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回此资源供给中心集合对象中指定序号的资源供给中心对象
   * @param index
   * @returns {Promise.<SupplyCenter>}
   */
  async get(index) {
    try {
      let supplyCenterId = await SCs.get(this._SMSupplyCentersId, index);
      let supplyCenter = new SupplyCenter()
      supplyCenter._SMSupplyCenterId = supplyCenterId
      return supplyCenter
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在资源供给中心集合中删除指定序号的资源供给中心对象
   * @param index
   * @returns {Promise.<SupplyCenter>}
   */
  async remove(index) {
    try {
      return await SCs.remove(this._SMSupplyCentersId, index);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在资源供给中心集合中从指定序号开始，删除指定个数的资源供给中心对
   * @param index
   * @param count
   * @returns {Promise.<Promise|void|Promise.<Promise.<void>|Promise|Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>|Promise.<Promise.count>|Boolean|Promise.<number>>|*|{range, text}>}
   */
  async removeRange(index = 0, count = 0) {
    try {
      let count = await SCs.removeRange(this._SMSupplyCentersId, index, count);
      return count
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回资源供给中心点的个数
   * @returns {Promise.<Promise|Boolean|Promise.<void>|Promise.<Promise.count>|Promise.<number>|Promise.<Promise|Boolean|Promise.<Promise.count>|Promise.<void>|Promise.<number>>>}
   */
  async getCount() {
    try {
      let count = await SCs.getCount(this._SMSupplyCentersId);
      return count
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置此资源供给中心集合对象中指定序号的资源供给中心对象
   * @param index
   * @param supplyCenter
   * @returns {Promise.<void>}
   */
  async set(index, supplyCenter) {
    try {
      await SCs.set(this._SMSupplyCentersId, index, supplyCenter._SMSupplyCenterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置此资源供给中心集合对象中指定序号的资源供给中心对象
   * @param index
   * @param supplyCenter
   * @returns {Promise.<void>}
   */
  async toArray(index, supplyCenter) {
    try {
      let arr = await SCs.toArray(this._SMSupplyCentersId);
      return arr
    } catch (e) {
      console.error(e);
    }
  }
  
}
