/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let FAS = NativeModules.JSFacilityAnalystSetting;

import DatasetVector from './DatasetVector'
import WeightFieldInfos from './WeightFieldInfos'
/**
 * 设施网络分析环境设置类。
 * 该类用于提供设施网络分析时所需要的所有参数信息。
 * 设施网络分析环境设置类的各个参数的设置直接影响分析的结果。
 */
export default class FacilityAnalystSetting {
  async createObj() {
    try {
      let facilityAnalystSettingId = await FAS.createObj();
      let facilityAnalystSetting = new FacilityAnalystSetting();
      facilityAnalystSetting._SMFacilityAnalystSettingId = facilityAnalystSettingId;
      return facilityAnalystSetting;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回障碍弧段的 ID 列表
   * @returns {Promise.<Promise|Promise.<void>>}
   */
  async getBarrierEdges () {
    try {
      let wArr = await FAS.getBarrierEdges(this._SMFacilityAnalystSettingId);
      return wArr;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回障碍结点的 ID 列表
   * @returns {Promise}
   */
  async getBarrierNodes () {
    try {
      let wArr = await FAS.getBarrierNodes(this._SMFacilityAnalystSettingId);
      return wArr;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回流向字段
   * @returns {Promise}
   */
  async getDirectionField () {
    try {
      let directionField = await FAS.getDirectionField(this._SMFacilityAnalystSettingId);
      return directionField;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回网络数据集中标识弧段 ID 的字段
   * @returns {Promise}
   */
  async getEdgeIDField () {
    try {
      let edgeIDField = await FAS.getEdgeIDField(this._SMFacilityAnalystSettingId);
      return edgeIDField
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回网络数据集中标识弧段起始结点 ID 的字段
   * @returns {Promise}
   */
  async getFNodeIDField () {
    try {
      let fNodeIDField = await FAS.getFNodeIDField(this._SMFacilityAnalystSettingId);
      return fNodeIDField
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回网络数据集
   * @returns {Promise.<DatasetVector>}
   */
  async getNetworkDataset () {
    try {
      let datasetVectorId = await FAS.getNetworkDataset(this._SMFacilityAnalystSettingId);
      let datasetVector = new DatasetVector()
      datasetVector._SMDatasetVectorId = datasetVectorId
      
      return datasetVector
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回网络数据集中标识网络结点 ID 的字段
   * @returns {Promise}
   */
  async getNodeIDField () {
    try {
      let nodeIDField = await FAS.getNodeIDField(this._SMFacilityAnalystSettingId);
      
      return nodeIDField;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回网络数据集中标识弧段终止结点 ID 的字段
   * @returns {Promise}
   */
  async getTNodeIDField () {
    try {
      let tNodeIDField = await FAS.getTNodeIDField(this._SMFacilityAnalystSettingId);
      
      return tNodeIDField;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回点到弧段的距离容限
   * @returns {Promise.<Promise|Promise.<void>>}
   */
  async getTolerance () {
    try {
      let tolerance = await FAS.getTolerance(this._SMFacilityAnalystSettingId);
      
      return tolerance;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回权值字段信息集合对象
   * @returns {Promise.<JSWeightFieldInfos>}
   */
  async getWeightFieldInfos () {
    try {
      let weightFieldInfosId = await FAS.getWeightFieldInfos(this._SMFacilityAnalystSettingId);
      let weightFieldInfos = new WeightFieldInfos()
  
      weightFieldInfos._SMWeightFieldInfosId = weightFieldInfosId
      
      return weightFieldInfos;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置障碍弧段的 ID 列表
   * @param arr
   * @returns {Promise.<void>}
   */
  async setBarrierEdges (arr) {
    try {
      await FAS.setBarrierEdges(this._SMFacilityAnalystSettingId, arr);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置障碍结点的 ID 列表
   * @param arr
   * @returns {Promise.<void>}
   */
  async setBarrierNodes (arr) {
    try {
      await FAS.setBarrierNodes(this._SMFacilityAnalystSettingId, arr);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置流向字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setDirectionField (value) {
    try {
      await FAS.setDirectionField(this._SMFacilityAnalystSettingId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置网络数据集中标识弧段 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setEdgeIDField (value) {
    try {
      await FAS.setEdgeIDField(this._SMFacilityAnalystSettingId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置网络数据集中标识弧段起始结点 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setFNodeIDField (value) {
    try {
      await FAS.setFNodeIDField(this._SMFacilityAnalystSettingId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置网络数据集
   * @param datasetVector
   * @returns {Promise.<void>}
   */
  async setNetworkDataset (datasetVector) {
    try {
      await FAS.setNetworkDataset(this._SMFacilityAnalystSettingId, datasetVector._SMDatasetVectorId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置网络数据集中标识网络结点 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setNodeIDField (value) {
    try {
      await FAS.setNodeIDField(this._SMFacilityAnalystSettingId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置网络数据集中标识弧段终止结点 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setTNodeIDField (value) {
    try {
      await FAS.setTNodeIDField(this._SMFacilityAnalystSettingId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置点到弧段的距离容限
   * @param value  number
   * @returns {Promise.<void>}
   */
  async setTolerance (value) {
    try {
      await FAS.setTolerance(this._SMFacilityAnalystSettingId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置权值字段信息集合对象。
   * @param value
   * @returns {Promise.<void>}
   */
  async setWeightFieldInfos (weightInfos) {
    try {
      await FAS.setWeightFieldInfos(this._SMFacilityAnalystSettingId, weightInfos._SMWeightFieldInfosId);
    } catch (e) {
      console.error(e);
    }
  }
}
