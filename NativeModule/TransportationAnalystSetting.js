/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native'
let TAS = NativeModules.JSTransportationAnalystSetting

import DatasetVector from './DatasetVector'
import WeightFieldInfos from './WeightFieldInfos'

export default class TransportationAnalystSetting {
  
  async createObj() {
    try {
      let transportationAnalystSettingId = await TAS.createObj()
      let transportationAnalystSetting = new TransportationAnalystSetting()
      transportationAnalystSetting._SMTransportationAnalystSettingId = transportationAnalystSettingId
      return transportationAnalystSetting
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回障碍弧段 ID 列表
   * @returns {Promise.<Promise|Promise.<void>|Promise.<Promise|Promise.<void>>|Promise.<Promise|Promise.<Promise|Promise.<void>>|Promise.<void>>>}
   */
  async getBarrierEdges() {
    try {
      return await TAS.getBarrierEdges(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回障碍结点 ID 列表
   * @returns {Promise}
   */
  async getBarrierNodes() {
    try {
      return await TAS.getBarrierNodes(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回交通网络分析中弧段过滤表达式
   * @returns {Promise}
   */
  async getEdgeFilter() {
    try {
      return await TAS.getEdgeFilter(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回网络数据集中标志弧段 ID 的字段
   * @returns {Promise}
   */
  async getEdgeIDField() {
    try {
      return await TAS.getEdgeIDField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回存储弧段名称的字段
   * @returns {Promise}
   */
  async getEdgeNameField() {
    try {
      return await TAS.getEdgeNameField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回网络数据集中标志弧段起始结点 ID 的字段
   * @returns {Promise}
   */
  async getFNodeIDField() {
    try {
      return await TAS.getFNodeIDField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回用于表示正向单行线的字符串的数组
   * @returns {Promise}
   */
  async getFTSingleWayRuleValues() {
    try {
      return await TAS.getFTSingleWayRuleValues(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回用于分析的网络数据集
   * @returns {Promise.<DatasetVector>}
   */
  async getNetworkDataset() {
    try {
      let datasetVectorId = await TAS.getNetworkDataset(this._SMTransportationAnalystSettingId)
      let datasetVector = new DatasetVector()
      datasetVector._SMDatasetVectorId = datasetVectorId
      return datasetVector
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回网络数据集中标识结点 ID 的字段
   * @returns {Promise.<*>}
   */
  async getNodeIDField() {
    try {
      return await TAS.getNodeIDField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回存储结点名称的字段的字段名
   * @returns {Promise}
   */
  async getNodeNameField() {
    try {
      return await TAS.getNodeNameField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回用于表示禁行线的字符串的数组
   * @returns {Promise}
   */
  async getProhibitedWayRuleValues() {
    try {
      return await TAS.getProhibitedWayRuleValues(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回网络数据集中表示网络弧段的交通规则的字段
   * @returns {Promise}
   */
  async getRuleField() {
    try {
      return await TAS.getRuleField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回用于表示逆向单行线的字符串的数组
   * @returns {Promise}
   */
  async getTFSingleWayRuleValues() {
    try {
      return await TAS.getTFSingleWayRuleValues(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置障碍结点 ID 列表
   * @returns {Promise}
   */
  async getTNodeIDField() {
    try {
      return await TAS.getTNodeIDField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回转向表数据集
   * @returns {Promise.<DatasetVector>}
   */
  async getTurnDataset() {
    try {
      let datasetVectorId = await TAS.getTurnDataset(this._SMTransportationAnalystSettingId)
      let datasetVector = new DatasetVector()
      datasetVector._SMDatasetVectorId = datasetVectorId
      return datasetVector
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回转向起始弧段 ID 的字段
   * @returns {Promise}
   */
  async getTurnFEdgeIDField() {
    try {
      return await TAS.getTurnFEdgeIDField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回转向结点 ID 的字段
   * @returns {Promise}
   */
  async getTurnNodeIDField() {
    try {
      return await TAS.getTurnNodeIDField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回转向终止弧段 ID 的字段
   * @returns {Promise}
   */
  async getTurnTEdgeIDField() {
    try {
      return await TAS.getTurnTEdgeIDField(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回转向权值字段集合
   * @returns {Promise}
   */
  async getTurnWeightFields() {
    try {
      let weightFieldInfosId = await TAS.getTurnWeightFields(this._SMTransportationAnalystSettingId)
      let weightFieldInfos = new WeightFieldInfos()
      weightFieldInfos._SMWeightFieldInfosId = weightFieldInfosId
      return weightFieldInfos
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回用于表示双向通行线的字符串的数组
   * @returns {Promise}
   */
  async getTwoWayRuleValues() {
    try {
      return await TAS.getTwoWayRuleValues(this._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置障碍结点 ID 列表
   * @returns {Promise.<JSWeightFieldInfos>}
   */
  async getWeightFieldInfos() {
    try {
      let weightFieldInfosId = await TAS.getWeightFieldInfos(this._SMTransportationAnalystSettingId)
      let weightFieldInfos = new WeightFieldInfos()
      weightFieldInfos._SMWeightFieldInfosId = weightFieldInfosId
      return weightFieldInfos
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置障碍弧段的 ID 列表
   * @param value
   * @returns {Promise.<void>}
   */
  async setBarrierEdges(value = []) {
    try {
      await TAS.setBarrierEdges(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置障碍结点的 ID 列表
   * @param value
   * @returns {Promise.<void>}
   */
  async setBarrierNodes(value = []) {
    try {
      await TAS.setBarrierNodes(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置交通网络分析中弧段过滤表达式
   * @param value
   * @returns {Promise.<void>}
   */
  async setEdgeFilter(value) {
    try {
      await TAS.setEdgeFilter(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置网络数据集中标志弧段 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setEdgeIDField(value) {
    try {
      await TAS.setEdgeIDField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置存储弧段名称的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setEdgeNameField(value) {
    try {
      await TAS.setEdgeNameField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置网络数据集中标志弧段起始结点 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setFNodeIDField(value) {
    try {
      await TAS.setFNodeIDField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置用于表示正向单行线的字符串的数组
   * @param value
   * @returns {Promise.<void>}
   */
  async setFTSingleWayRuleValues(value = []) {
    try {
      await TAS.setFTSingleWayRuleValues(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置用于分析的网络数据集
   * @param datasetVector
   * @returns {Promise.<void>}
   */
  async setNetworkDataset(datasetVector) {
    try {
      await TAS.setNetworkDataset(this._SMTransportationAnalystSettingId, datasetVector._SMDatasetVectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置网络数据集中标识结点 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setNodeIDField(value) {
    try {
      await TAS.setNodeIDField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置存储结点名称的字段的字段名
   * @param value
   * @returns {Promise.<void>}
   */
  async setNodeNameField(value) {
    try {
      await TAS.setNodeNameField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置用于表示禁行线的字符串的数组
   * @param value
   * @returns {Promise.<void>}
   */
  async setProhibitedWayRuleValues(value = []) {
    try {
      await TAS.setProhibitedWayRuleValues(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置网络数据集中表示网络弧段的交通规则的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setRuleField(value) {
    try {
      await TAS.setRuleField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置用于表示逆向单行线的字符串的数组
   * @param value
   * @returns {Promise.<void>}
   */
  async setTFSingleWayRuleValues(value = []) {
    try {
      await TAS.setTFSingleWayRuleValues(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置网络数据集中标志弧段终止结点 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setTNodeIDField(value) {
    try {
      await TAS.setTNodeIDField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置点到弧段的距离容限
   * @param value
   * @returns {Promise.<void>}
   */
  async setTolerance(value) {
    try {
      await TAS.setTolerance(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置点到弧段的距离容限
   * @param value
   * @returns {Promise.<void>}
   */
  async setTurnDataset(datasetVector) {
    try {
      await TAS.setTurnDataset(this._SMTransportationAnalystSettingId, datasetVector._SMDatasetVectorId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置转向起始弧段 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setTurnFEdgeIDField(value) {
    try {
      await TAS.setTurnFEdgeIDField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置转向结点 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setTurnNodeIDField(value) {
    try {
      await TAS.setTurnNodeIDField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置转向终止弧段 ID 的字段
   * @param value
   * @returns {Promise.<void>}
   */
  async setTurnTEdgeIDField(value) {
    try {
      await TAS.setTurnTEdgeIDField(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置转向权值字段集合
   * @param value
   * @returns {Promise.<void>}
   */
  async setTurnWeightFields(value = []) {
    try {
      await TAS.setTurnWeightFields(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置用于表示双向通行线的字符串的数组
   * @param value
   * @returns {Promise.<void>}
   */
  async setTwoWayRuleValues(value = []) {
    try {
      await TAS.setTwoWayRuleValues(this._SMTransportationAnalystSettingId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置权值字段信息集合对象
   * @param weightFieldInfos
   * @returns {Promise.<void>}
   */
  async setWeightFieldInfos(weightFieldInfos) {
    try {
      await TAS.setWeightFieldInfos(this._SMTransportationAnalystSettingId, weightFieldInfos._SMWeightFieldInfosId)
    } catch (e) {
      console.error(e)
    }
  }
  
}
