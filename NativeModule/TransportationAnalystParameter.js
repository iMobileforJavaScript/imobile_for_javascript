/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let TAP = NativeModules.JSTransportationAnalystParameter;

export default class TransportationAnalystParameter {
  
  async createObj() {
    try {
      let transportationAnalystParameterId = await TAP.createObj();
      let transportationAnalystParameter = new TransportationAnalystParameter();
      transportationAnalystParameter._SMTransportationAnalystParameterId = transportationAnalystParameterId;
      return transportationAnalystParameter;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回障碍弧段 ID 列表
   * @returns {Promise.<Promise|Promise.<Promise|Promise.<void>>|Promise.<void>>}
   */
  async getBarrierEdges() {
    try {
      return await TAP.getBarrierEdges(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回障碍结点 ID 列表
   * @returns {Promise}
   */
  async getBarrierNodes() {
    try {
      return await TAP.getBarrierNodes(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回障碍结点的坐标列表
   * @returns {Promise.<Promise|Promise.<array>>}
   */
  async getBarrierPoints() {
    try {
      return await TAP.getBarrierPoints(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回分析时途经结点 ID 的集合
   * @returns {Promise.<Promise|*>}
   */
  async getNodes() {
    try {
      return await TAP.getNodes(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回分析时途经点的集合
   * @returns {Promise}
   */
  async getPoints() {
    try {
      return await TAP.getPoints(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回转向权值字段
   * @returns {Promise.<Promise|Promise.<SupplyCenters>>}
   */
  async getTurnWeightField() {
    try {
      return await TAP.getTurnWeightField(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回权值字段信息的名称
   * @returns {Promise.<Promise|Promise.<SupplyCenters>>}
   */
  async getWeightName() {
    try {
      return await TAP.getWeightName(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回分析结果中是否包含途经弧段集合
   * @returns {Promise}
   */
  async isEdgesReturn() {
    try {
      return await TAP.isEdgesReturn(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回分析结果中是否包含途经结点的集合
   * @returns {Promise}
   */
  async isNodesReturn() {
    try {
      return await TAP.isNodesReturn(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回分析结果中是否包含行驶导引集合
   * @returns {Promise}
   */
  async isPathGuidesReturn() {
    try {
      return await TAP.isPathGuidesReturn(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回分析结果中是否包含路由（GeoLineM）对象的集合
   * @returns {Promise}
   */
  async isRoutesReturn() {
    try {
      return await TAP.isRoutesReturn(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回分析结果中是否要包含站点索引的集合
   * @returns {Promise}
   */
  async isStopIndexesReturn() {
    try {
      return await TAP.isStopIndexesReturn(this._SMTransportationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置障碍弧段 ID 列表
   * @param arr
   * @returns {Promise.<void>}
   */
  async setBarrierEdges(arr = []) {
    try {
      await TAP.setBarrierEdges(this._SMTransportationAnalystParameterId, arr);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置障碍结点 ID 列表
   * @param arr
   * @returns {Promise.<void>}
   */
  async setBarrierNodes(arr = []) {
    try {
      await TAP.setBarrierNodes(this._SMTransportationAnalystParameterId, arr);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置障碍结点的坐标列表
   * @param points2DsArr
   * @returns {Promise.<void>}
   */
  async setBarrierPoints(points2DsArr = []) {
    try {
      await TAP.setBarrierPoints(this._SMTransportationAnalystParameterId, points2DsArr);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置分析结果中是否包含途经弧段的集合
   * @param value
   * @returns {Promise.<void>}
   */
  async setEdgesReturn(value = true) {
    try {
      await TAP.setEdgesReturn(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置分析时途经结点 ID 的集合
   * @param value
   * @returns {Promise.<void>}
   */
  async setNodes(value = []) {
    try {
      await TAP.setNodes(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置分析结果中是否包含结点的集合
   * @param value
   * @returns {Promise.<void>}
   */
  async setNodesReturn(value = true) {
    try {
      await TAP.setNodesReturn(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置分析结果中是否包含行驶导引集合
   * @param value
   * @returns {Promise.<void>}
   */
  async setPathGuidesReturn(value = true) {
    try {
      await TAP.setPathGuidesReturn(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置分析结果中是否包含路由（GeoLineM）对象的集合
   * @param value
   * @returns {Promise.<void>}
   */
  async setRoutesReturn(value = true) {
    try {
      await TAP.setRoutesReturn(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置分析结果中是否要包含站点索引的集合
   * @param value
   * @returns {Promise.<void>}
   */
  async setStopIndexesReturn(value = true) {
    try {
      await TAP.setStopIndexesReturn(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置分析时途经点的集合
   * @param points2DsArr    [{x, y}, {x, y}]
   * @returns {Promise.<void>}
   */
  async setPoints(points2DsArr = []) {
    try {
      await TAP.setPoints(this._SMTransportationAnalystParameterId, points2DsArr);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置转向权值字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setTurnWeightField(value) {
    try {
      await TAP.setTurnWeightField(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置权值字段信息的名称，即交通网络分析环境设置（TransportationAnalystSetting）中的权值字段信息集合（WeightFieldInfos）
   * 中的某一个权值字段信息对象（WeightFieldInfo）的 getName() 方法的返回值
   * @param value
   * @returns {Promise.<void>}
   */
  async setWeightName(value) {
    try {
      await TAP.setWeightName(this._SMTransportationAnalystParameterId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
}
