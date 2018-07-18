/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let LAP = NativeModules.JSLocationAnalystParameter;

import SupplyCenters from './SupplyCenters'

export default class LocationAnalystParameter {
  
  async createObj() {
    try {
      let locationAnalystParameterId = await await LAP.createObj();
      let transportationAnalyst = new LocationAnalystParameter();
      transportationAnalyst._SMLocationAnalystParameterId = locationAnalystParameterId;
      return transportationAnalyst;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回期望用于最终设施选址的资源供给中心数量
   * @returns {Promise.<*>}
   */
  async getExpectedSupplyCenterCount() {
    try {
      let count = await LAP.getExpectedSupplyCenterCount(this._SMLocationAnalystParameterId);
      return count
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回结点需求量字段
   * @returns {Promise}
   */
  async getNodeDemandField() {
    try {
      let nodeDemandField = await LAP.getNodeDemandField(this._SMLocationAnalystParameterId);
      return nodeDemandField
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回障碍结点的坐标列表
   * @returns {Promise.<SupplyCenters>}
   */
  async getSupplyCenters() {
    try {
      let supplyCentersId = await LAP.getSupplyCenters(this._SMLocationAnalystParameterId);
      let supplyCenters = new SupplyCenters()
      supplyCenters._SMSupplyCentersId = supplyCentersId
      return supplyCenters
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回转向权值字段，该字段是交通网络分析环境设置中指定的转向权值字段集合中的一员
   * @returns {Promise.<SupplyCenters>}
   */
  async getTurnWeightField() {
    try {
      let value = await LAP.getTurnWeightField(this._SMLocationAnalystParameterId);
      return value
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回权值字段信息的名称，即交通网络分析环境设置中指定的权值字段信息集合对象（WeightFieldInfos 类对象）中的某一个权值字段信息对象（WeightFieldInfo 类对象）的 setName() 方法值
   * @returns {Promise.<SupplyCenters>}
   */
  async getWeightName() {
    try {
      let value = await LAP.getWeightName(this._SMLocationAnalystParameterId);
      return value
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回是否从资源供给中心开始分配资源
   * @returns {Promise.<SupplyCenters>}
   */
  async isFromCenter() {
    try {
      let value = await LAP.isFromCenter(this._SMLocationAnalystParameterId);
      return value
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置期望用于最终设施选址的资源供给中心数量
   * @param value
   * @returns {Promise.<void>}
   */
  async setExpectedSupplyCenterCount(value) {
    try {
      await LAP.setExpectedSupplyCenterCount(this._SMLocationAnalystParameterId, value);
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置是否从资源供给中心开始分配资源
   * @param value
   * @returns {Promise.<void>}
   */
  async setFromCenter(value) {
    try {
      await LAP.setFromCenter(this._SMLocationAnalystParameterId, value);
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置结点需求量字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setNodeDemandField(value) {
    try {
      await LAP.setNodeDemandField(this._SMLocationAnalystParameterId, value);
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置资源供给中心集合
   * @param supplyCenters
   * @returns {Promise.<void>}
   */
  async setSupplyCenters(supplyCenters) {
    try {
      await LAP.setSupplyCenters(this._SMLocationAnalystParameterId, supplyCenters._SMSupplyCentersId);
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置转向权值字段，该字段是交通网络分析环境设置中指定的转向权值字段集合中的一员
   * @param value
   * @returns {Promise.<void>}
   */
  async setTurnWeightField(value) {
    try {
      await LAP.setTurnWeightField(this._SMLocationAnalystParameterId, value);
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置权值字段信息的名称，即交通网络分析环境设置中指定的权值字段信息集合对象（WeightFieldInfos 类对象）中的某一个权值字段信息对象（WeightFieldInfo 类对象）的 setName() 方法值
   * @param value
   * @returns {Promise.<void>}
   */
  async setWeightName(value) {
    try {
      await LAP.setWeightName(this._SMLocationAnalystParameterId, value);
    } catch (e) {
      console.error(e)
    }
  }
  
}
