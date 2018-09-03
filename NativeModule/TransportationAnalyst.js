/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let TA = NativeModules.JSTransportationAnalyst;

import TransportationAnalystSetting from './TransportationAnalystSetting'
import GeoLineM from './GeoLineM'

export default class TransportationAnalyst {

  async createObj() {
    try {
      let transportationAnalystId = await TA.createObj();
      let transportationAnalyst = new TransportationAnalyst();
      transportationAnalyst._SMTransportationAnalystId = transportationAnalystId;
      return transportationAnalyst;
    } catch (e) {
      console.error(e);
    }
  }
  
  async dispose() {
    try {
      await TA.dispose(this._SMTransportationAnalystId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 创建内存文件
   * @param path
   * @returns {Promise}
   */
  async createModel(path) {
    try {
      return await TA.createModel(this._SMTransportationAnalystId, path);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据指定的参数进行最近设施查找分析，事件点为结点 ID
   * @param transportationAnalystParameter
   * @param eventID
   * @param facilityCount
   * @param isFromEvent
   * @param maxWeight
   * @returns {Promise}
   */
  async findClosestFacilityByNode(transportationAnalystParameter, eventID,
                                  facilityCount, isFromEvent, maxWeight) {
    try {
      return await TA.findClosestFacilityByNode(this._SMTransportationAnalystId,
        transportationAnalystParameter._SMTransportationAnalystParameterId, eventID,
        facilityCount, isFromEvent, maxWeight);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据指定的参数进行最近设施查找分析，事件点为结点 ID
   * @param transportationAnalystParameter
   * @param eventID
   * @param facilityCount
   * @param isFromEvent
   * @param maxWeight
   * @returns {Promise}
   */
  async findClosestFacilityByPoint2D(transportationAnalystParameter, point2D,
                                  facilityCount, isFromEvent, maxWeight) {
    try {
      return await TA.findClosestFacilityByPoint2D(this._SMTransportationAnalystId,
        transportationAnalystParameter._SMTransportationAnalystParameterId, point2D._SMPoint2DId,
        facilityCount, isFromEvent, maxWeight);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的参数进行选址分区分析
   * @param locationAnalystParameter
   * @returns {Promise}
   */
  async findLocation(locationAnalystParameter) {
    try {
      return await TA.findLocation(this._SMTransportationAnalystId, locationAnalystParameter._SMLocationAnalystParameterId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 多旅行商（物流配送）分析，配送中心为结点 ID 数组
   * @param transportationAnalystParameter
   * @param centerNodes
   * @param hasLeastTotalCost
   * @returns {Promise}
   */
  async findMTSPPathByNodes(transportationAnalystParameter, centerNodes = [], hasLeastTotalCost = true) {
    try {
      return await TA.findMTSPPathByNodes(this._SMTransportationAnalystId,
        transportationAnalystParameter._SMTransportationAnalystParameterId, centerNodes, hasLeastTotalCost);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 多旅行商（物流配送）分析，配送中心为点坐标串
   * @param transportationAnalystParameter
   * @param centerPoints    [{x, y}, {x, y}]
   * @param hasLeastTotalCost
   * @returns {Promise}
   */
  async findMTSPPathByPoint2Ds(transportationAnalystParameter, centerPoints = [], hasLeastTotalCost = false) {
    try {
      let {
        pathGuideIds, routeIds, edges,
        nodesArr, stopIndexesArr,
        stopWeightsArr, weightsArr
      } = await TA.findMTSPPathByPoint2Ds(this._SMTransportationAnalystId,
        transportationAnalystParameter._SMTransportationAnalystParameterId, centerPoints, hasLeastTotalCost);

      let routes = []
      if (routeIds) {
        for (let i = 0; i < routeIds.length; i++) {
          let route = new GeoLineM()
          route._SMGeoLineId = routeIds[i]
          routes.push(route)
        }
      }

      return { pathGuideIds, routes, edges, nodesArr, stopIndexesArr, stopWeightsArr, weightsArr }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 最佳路径分析
   * @param transportationAnalystParameter
   * @param hasLeastTotalCost
   * @returns {Promise}
   */
  async findPath(transportationAnalystParameter, hasLeastTotalCost = false) {
    try {
      let {
        pathGuideIds, routeIds, edges,
        nodesArr, stopIndexesArr,
        stopWeightsArr, weightsArr
      } = await TA.findPath(this._SMTransportationAnalystId,
        transportationAnalystParameter._SMTransportationAnalystParameterId, hasLeastTotalCost);

      let routes = []
      if (routeIds) {
        for (let i = 0; i < routeIds.length; i++) {
          let route = new GeoLineM()
          route._SMGeoLineId = routeIds[i]
          routes.push(route)
        }
      }
      
      return { pathGuideIds, routes, edges, nodesArr, stopIndexesArr, stopWeightsArr, weightsArr }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 服务区分析
   * @param transportationAnalystParameter
   * @param weights
   * @param isFromCenter
   * @param isCenterMutuallyExclusive
   * @returns {Promise}
   */
  async findServiceArea(transportationAnalystParameter, weights = [], isFromCenter = true, isCenterMutuallyExclusive = true) {
    try {
      return await TA.findServiceArea(this._SMTransportationAnalystId,
        transportationAnalystParameter._SMTransportationAnalystParameterId, weights, isFromCenter, hasLeastTotalCost);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回交通网络分析环境设置对象
   * @returns {Promise.<Promise|Promise.<FacilityAnalystSetting>>}
   */
  async getAnalystSetting() {
    try {
      let settingId = await TA.getAnalystSetting(this._SMTransportationAnalystId)
      let setting = await new TransportationAnalystSetting().createObj()
      setting._SMTransportationAnalystSettingId = settingId
      return setting
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 加载网络模型
   * @returns {Promise.<*>}
   */
  async load() {
    try {
      return await TA.load(this._SMTransportationAnalystId)
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 加载内存文件
   * @param filePath
   * @param networkDataset
   * @returns {Promise.<Promise|Promise.<void>>}
   */
  async loadModel(filePath, networkDataset) {
    try {
      return await TA.loadModel(this._SMTransportationAnalystId, filePath, networkDataset._SMDatasetVectorId)
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置交通网络分析环境设置对象
   * @param transportationAnalystSetting
   * @returns {Promise.<void>}
   */
  async setAnalystSetting(transportationAnalystSetting) {
    try {
      await TA.setAnalystSetting(this._SMTransportationAnalystId, transportationAnalystSetting._SMTransportationAnalystSettingId)
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 该方法用来更新弧段的权值
   * @param edgeID
   * @param fromNodeID
   * @param toNodeID
   * @param weightName
   * @param weight
   * @returns {Promise.<void>}
   */
  async updateEdgeWeight(edgeID, fromNodeID, toNodeID, weightName, weight) {
    try {
      await TA.updateEdgeWeight(this._SMTransportationAnalystId, edgeID, fromNodeID, toNodeID, weightName, weight)
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 该方法用来更新转向结点的权值
   * @param nodeID
   * @param fromEdgeID
   * @param toEdgeID
   * @param weightName
   * @param weight
   * @returns {Promise.<void>}
   */
  async updateTurnNodeWeight(nodeID, fromEdgeID, toEdgeID, weightName, weight) {
    try {
      await TA.updateTurnNodeWeight(this._SMTransportationAnalystId, nodeID, fromEdgeID, toEdgeID, weightName, weight)
    } catch (e) {
      console.error(e)
    }
  }
}
