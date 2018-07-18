/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let FA = NativeModules.JSFacilityAnalyst;

import FacilityAnalystSetting from './FacilityAnalystSetting'
/**
 * 设施网络分析类。它是网络分析功能类之一，主要用于进行各类连通性分析和追踪分析。
 */
export default class FacilityAnalyst {
  async createObj() {
    try {
      let facilityAnalystId = await FA.createObj();
      let facilityAnalyst = new FacilityAnalyst();
      facilityAnalyst._SMFacilityAnalystId = facilityAnalystId;
      return facilityAnalyst;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 检查网络环路，返回构成环路的弧段 ID 数组
   * @returns {Promise.<Promise|*|{type}>}
   */
  async checkLoops () {
    try {
      let ids = await FA.checkLoops(this._SMFacilityAnalystId);
      
      return ids;
    } catch (e) {
      console.error(e);
    }
  }
  
  async dispose () {
    try {
      await FA.dispose(this._SMFacilityAnalystId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据设施网络分析环境设置加载设施网络模型
   * @returns {Promise.<*>}
   */
  async load () {
    try {
      let result = await FA.load(this._SMFacilityAnalystId);
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回设施网络分析的环境
   * @returns {Promise.<FacilityAnalystSetting>}
   */
  async getAnalystSetting () {
    try {
      let settingId = await FA.getAnalystSetting(this._SMFacilityAnalystId);
      let setting = new FacilityAnalystSetting();
      setting._SMFacilityAnalystSettingId = settingId
      return setting;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置设施网络分析的环境
   * @param setting
   * @returns {Promise.<void>}
   */
  async setAnalystSetting (setting) {
    try {
      console.log(this._SMFacilityAnalystId)
      await FA.setAnalystSetting(this._SMFacilityAnalystId, setting._SMFacilityAnalystSettingId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 数组，查找这些弧段的共同上游弧段，返回弧段 ID 数组
   * @param edgeIDs
   * @param isUncertainDirectionValid
   * @returns {Promise}
   */
  async findCommonAncestorsFromEdges (edgeIDs, isUncertainDirectionValid) {
    try {
      let ids = await FA.findCommonAncestorsFromEdges(this._SMFacilityAnalystId, edgeIDs, isUncertainDirectionValid);
      return ids;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 数组，查找这些结点的共同上游弧段，返回弧段 ID 数组
   * @param nodeIDs
   * @param isUncertainDirectionValid
   * @returns {Promise}
   */
  async findCommonAncestorsFromNodes (nodeIDs, isUncertainDirectionValid) {
    try {
      let ids = await FA.findCommonAncestorsFromNodes(this._SMFacilityAnalystId, nodeIDs, isUncertainDirectionValid);
      return ids
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 数组，查找这些弧段的共同下游弧段，返回弧段 ID 数组
   * @param edgeIDs
   * @param isUncertainDirectionValid
   * @returns {Promise.<void>}
   */
  async findCommonCatchmentsFromEdges (edgeIDs, isUncertainDirectionValid) {
    try {
      let ids = await FA.findCommonCatchmentsFromEdges(this._SMFacilityAnalystId, edgeIDs, isUncertainDirectionValid);
      return ids
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据指定的结点 ID 数组，查找这些结点的共同下游弧段，返回弧段 ID 数组
   * @param nodeIDs
   * @param isUncertainDirectionValid
   * @returns {Promise}
   */
  async findCommonCatchmentsFromNodes (nodeIDs, isUncertainDirectionValid) {
    try {
      let ids = await FA.findCommonCatchmentsFromNodes(this._SMFacilityAnalystId, nodeIDs, isUncertainDirectionValid);
      return ids
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 数组，查找与这些弧段相连通的弧段，返回弧段 ID 数组
   * @param edgeIDs
   * @param isUncertainDirectionValid
   * @returns {Promise}
   */
  async findConnectedEdgesFromEdges (edgeIDs, isUncertainDirectionValid) {
    try {
      let ids = await FA.findConnectedEdgesFromEdges(this._SMFacilityAnalystId, edgeIDs, isUncertainDirectionValid);
      return ids
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 数组，查找与这些结点相连通弧段，返回弧段 ID 数组
   * @param nodeIDs
   * @param isUncertainDirectionValid
   * @returns {Promise}
   */
  async findConnectedEdgesFromNodes (nodeIDs, isUncertainDirectionValid) {
    try {
      let ids = await FA.findConnectedEdgesFromNodes(this._SMFacilityAnalystId, nodeIDs, isUncertainDirectionValid);
      return ids
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 数组查找与这些弧段相连接的环路，返回构成环路的弧段 ID 数组
   * @param edgeIDs
   * @returns {Promise}
   */
  async findLoopsFromEdges (edgeIDs) {
    try {
      let ids = await FA.findLoopsFromEdges(this._SMFacilityAnalystId, edgeIDs);
      return ids
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 数组查找与这些结点相连接的环路，返回构成环路的弧段 ID 数组
   * @param nodeIDs
   * @returns {Promise}
   */
  async findLoopsFromNodes (nodeIDs) {
    try {
      let ids = await FA.findLoopsFromNodes(this._SMFacilityAnalystId, nodeIDs);
      return ids
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设施网络下游路径分析，根据给定的参与分析的弧段 ID，查询该弧段下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findPathDownFromEdge (edgeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findPathDownFromEdge(this._SMFacilityAnalystId, edgeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设施网络下游路径分析，根据给定的参与分析的弧段 ID，查询该弧段下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findPathDownFromNode (nodeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findPathDownFromNode(this._SMFacilityAnalystId, nodeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设施网络路径分析，即根据给定的起始和终止弧段 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findPathFromEdges (edgeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findPathFromEdges(this._SMFacilityAnalystId, edgeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设施网络路径分析，即根据给定的起始和终止结点 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费。
   * @param startNodeId
   * @param endNodeId
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findPathFromNodes (startNodeId, endNodeId, weightName, isUncertainDirectionValid) {
    try {
      console.log(startNodeId, endNodeId)
      let { coast, edges, nodes, message } = await FA.findPathFromNodes(this._SMFacilityAnalystId, startNodeId, endNodeId, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes, message }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设施网络上游路径分析，根据给定的弧段 ID，查询该弧段上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findPathUpFromEdge (edgeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findPathUpFromEdge(this._SMFacilityAnalystId, edgeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设施网络上游路径分析，根据给定的结点 ID，查询该结点上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
   * @param nodeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findPathUpFromNode (nodeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findPathUpFromNode(this._SMFacilityAnalystId, nodeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 查找汇，即从给定弧段出发，根据流向查找流出该弧段的下游汇点，并返回给定弧段到达该汇的最小耗费路径所包含的弧段、结点及耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findSinkFromEdge (edgeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findSinkFromEdge(this._SMFacilityAnalystId, edgeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 查找汇，即从给定结点出发，根据流向查找流出该结点的下游汇点，并返回给定结点到达该汇的最小耗费路径所包含的弧段、结点及耗费
   * @param nodeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findSinkFromNode (nodeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findSinkFromNode(this._SMFacilityAnalystId, nodeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 查找源，即从给定弧段出发，根据流向查找流向该弧段的网络源头，并返回该源到达给定弧段的最小耗费路径所包含的弧段、结点及耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findSourceFromEdge (edgeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findSourceFromEdge(this._SMFacilityAnalystId, edgeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 查找源，即从给定结点出发，根据流向查找流向该结点的网络源头，并返回该源到达给定结点的最小耗费路径所包含的弧段、结点及耗费
   * @param nodeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async findSourceFromNode (nodeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.findSourceFromNode(this._SMFacilityAnalystId, nodeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 数组，查找与这些弧段不相连通的弧段，返回弧段 ID 数组
   * @param edgeIDs
   * @returns {Promise}
   */
  async findUnconnectedEdgesFromEdges (edgeIDs) {
    try {
      let unconnectedEdges = await FA.findUnconnectedEdgesFromEdges(this._SMFacilityAnalystId, edgeIDs);
      return unconnectedEdges
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 数组，查找与这些结点不相连通的弧段，返回弧段 ID 数组
   * @param nodeIDs
   * @returns {Promise}
   */
  async findUnconnectedEdgesFromNodes (nodeIDs) {
    try {
      let unconnectedEdges = await FA.findUnconnectedEdgesFromNodes(this._SMFacilityAnalystId, nodeIDs);
      return unconnectedEdges
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 进行下游追踪，即查找给定弧段的下游，返回下游包含的弧段、结点及总耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async traceDownFromEdge (edgeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.traceDownFromEdge(this._SMFacilityAnalystId, edgeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 进行下游追踪，即查找给定结点的下游，返回下游包含的弧段、结点及总耗费
   * @param nodeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async traceDownFromNode (nodeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.traceDownFromNode(this._SMFacilityAnalystId, nodeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的弧段 ID 进行上游追踪，即查找给定弧段的上游，返回上游包含的弧段、结点及总耗费
   * @param edgeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async traceUpFromEdge (edgeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.traceUpFromEdge(this._SMFacilityAnalystId, edgeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据给定的结点 ID 进行上游追踪，即查找给定结点的上游，返回上游包含的弧段、结点及总耗费
   * @param nodeID
   * @param weightName
   * @param isUncertainDirectionValid
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async traceUpFromNode (nodeID, weightName, isUncertainDirectionValid) {
    try {
      let { coast, edges, nodes } = await FA.traceUpFromNode(this._SMFacilityAnalystId, nodeID, weightName, isUncertainDirectionValid);
      return { coast, edges, nodes }
    } catch (e) {
      console.error(e);
    }
  }
  
}
