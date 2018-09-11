/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import { NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform } from 'react-native';
let M = NativeModules.JSMap;
import Layer from './Layer.js';
import Layers from './Layers.js';
import Point2D from './Point2D.js';
import Point from './Point.js';
import TrackingLayer from './TrackingLayer.js';
import PrjCoordSys from './PrjCoordSys.js';

const nativeEvt = new NativeEventEmitter(M);

/**
 * @class Map
 * @description 地图类，负责地图显示环境的管理。
 */
export default class Map {
  
  /**
   * 设置当前地图所关联的工作空间。地图是对其所关联的工作空间中的数据的显示。
   * @memberOf Map
   * @param {object} workspace
   * @returns {Promise.<void>}
   */
  async setWorkspace(workspace) {
    try {
      await M.setWorkspace(this._SMMapId, workspace._SMWorkspaceId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 重新绘制当前地图。
   * @memberOf Map
   * @returns {Promise.<void>}
   */
  async refresh() {
    try {
      await M.refresh(this._SMMapId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回此图层集合中指定索引或名称的图层对象。
   * @memberOf Map
   * @param {number | string} layerIndex|layerName - 指定索引或名称
   * @returns {Promise.<Layer>}
   */
  async getLayer(layerIndex) {
    try {
      var layer = new Layer();
      if (typeof layerIndex === "string") {
        var { layerId } = await M.getLayerByName(this._SMMapId, layerIndex);
      } else {
        var { layerId } = await M.getLayer(this._SMMapId, layerIndex);
      }
      layer._SMLayerId = layerId;
      return layer;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取根据类型分组的图层
   * @returns {Promise}
   */
  async getLayersWithType() {
    try {
      let layers = await M.getLayersWithType(this._SMMapId);
      
      return layers
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据类型查找图层, type = -1 时，返回全部类型
   * @returns {Promise}
   */
  async getLayersByType(type = -1) {
    try {
      let layers = await M.getLayersByType(this._SMMapId, type);
      for (let i = 0; i < layers.length; i++) {
        let layer = new Layer()
        layer._SMLayerId = layers[i].id
        layers[i].layer = layer
      }
      return layers
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 用于把一个数据集添加到此地图作为一个普通图层显示，即创建一个普通图层。(@deprecated)
   * @memberOf Map
   * @param {object} dataset
   * @param {boolean} addToHead
   * @returns {Promise.<void>}
   */
  async addDataset(dataset, addToHead) {
    console.warn("Map.js:addDataset() function has been deprecated. If you want to add Layer , please call the addLayer() function");
    try {
      await M.addDataset(this._SMMapId, dataset._SMDatasetId, addToHead);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回当前地图所包含的图层集合对象。
   * @memberOf Map
   * @deprecated
   * @returns {Promise.<Layers>}
   */
  async getLayers() {
    console.warn("Map.js:getLayers() function has been deprecated. If you want to get Layer , please call the getLayer() function");
    try {
      var { layersId } = await M.getLayers(this._SMMapId);
      var layers = new Layers();
      layers._SMLayersId = layersId;
      return layers;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回此图层集合中图层对象的总数。
   * @memberOf Map
   * @returns {Promise.<Promise.count>}
   */
  async getLayersCount() {
    try {
      var { count } = await M.getLayersCount(this._SMMapId);
      return count;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 打开指定名称的地图。
   * @memberOf Map
   * @param {string} mapName - 地图名称
   * @returns {Promise.<void>}
   */
  async open(mapName) {
    try {
      await M.open(this._SMMapId, mapName);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 关闭当前地图。
   * @memberOf Map
   * @returns {Promise.<void>}
   */
  async close() {
    try {
      await M.close(this._SMMapId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将地图中指定点的像素坐标转换为地图坐标。
   * @memberOf Map
   * @param {object} point
   * @returns {Promise.<Point2D>}
   */
  async pixelToMap(point) {
    try {
      var { point2DId, x, y } = await M.pixelToMap(this._SMMapId, point._SMPointId);
      var point2D = new Point2D();
      point2D._SMPoint2DId = point2DId;
      point2D.x = x;
      point2D.y = y;
      return point2D;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将地图中指定点的地图坐标转换为像素坐标。
   * @memberOf Map
   * @param {object} point2D
   * @returns {Promise.<Point>}
   */
  async mapToPixel(point2D) {
    try {
      var { pointId, x, y } = await M.mapToPixel(this._SMMapId, point2D._SMPoint2DId);
      var point = new Point();
      point._SMPointId = pointId;
      point.x = x;
      point.y = y;
      return point;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取当前地图的显示范围的中心点。
   * @memberOf Map
   * @param {object} point2D
   * @returns {Promise.<void>}
   */
  async getCenter() {
    try {
      var { point2DId, x, y } = await M.getCenter(this._SMMapId);
      var point2D = new Point2D();
      point2D._SMPoint2DId = point2DId;
      point2D.x = x;
      point2D.y = y;
      return point2D;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置当前地图的显示范围的中心点。
   * @memberOf Map
   * @param {object} point2D
   * @returns {Promise.<void>}
   */
  async setCenter(point2D) {
    try {
      await M.setCenter(this._SMMapId, point2D._SMPoint2DId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回当前地图的跟踪图层。
   * @memberOf Map
   * @returns {Promise.<TrackingLayer>}
   */
  async getTrackingLayer() {
    try {
      var { trackingLayerId } = await M.getTrackingLayer(this._SMMapId);
      var trackingLayer = new TrackingLayer();
      trackingLayer._SMTrackingLayerId = trackingLayerId;
      return trackingLayer;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将当前地图保存／另存为指定名称的地图
   * @memberOf Map
   * @param {string} mapName 地图名称（可选参数）
   * @returns {Promise.<Promise.saved>}
   */
  async save(mapName) {
    try {
      if (mapName) {
        var { saved } = await M.saveAs(this._SMMapId, mapName);
      } else {
        var { saved } = await M.save(this._SMMapId);
      }
      return saved;
    } catch (e) {
      console.error(e);
      return false
    }
  }
  
  /**
   * 返回当前地图的空间范围。
   * @memberOf Map
   * @returns {Promise.<Promise.bound>} - 返回Bounds的JSON对象：如{top:0,bottom:0,left:0,right:0,height:0,width:0,center:{x,y}}
   */
  async getBounds() {
    try {
      var { bound } = await M.getBounds(this._SMMapId);
      return bound;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回当前地图的可见范围，也称显示范围。
   * @memberOf Map
   * @returns {Promise.<Promise.bound>} - 返回Bounds的JSON对象：如{top:0,bottom:0,left:0,right:0,height:0,width:0,center:{x,y}}
   */
  async getViewBounds() {
    try {
      var { bound } = await M.getViewBounds(this._SMMapId);
      return bound;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置当前地图的可见范围，也称显示范围。
   * @memberOf Map
   * @param {object} bounds - Bounds的JSON对象：如{top:0,bottom:0,left:0,right:0,height:0,width:0,center:{x,y}}
   * @returns {Promise.<void>}
   */
  async setViewBounds(bounds) {
    try {
      await M.setViewBounds(this._SMMapId, bounds);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回是否允许地图动态投影显示(该接口为安卓端专有接口，iOS无此接口)。
   * @memberOf Map
   * @param {object} bounds
   * @returns {Promise.<Promise.is>}
   */
  async isDynamicProjection() {
    try {
      var { is } = await M.isDynamicProjection(this._SMMapId);
      return is;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置地图是否动态投影显示，以及地图的投影坐标系
   * @memberOf Map
   * @param {boolean} value - 地图是否动态投影
   * @returns {Promise.<void>}
   */
  async setDynamicProjection(value) {
    try {
      await M.setDynamicProjection(this._SMMapId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取用于接收地图加载完成的监听器。
   * @memberOf Map
   * @param {function} onMapLoaded - 地图打开并显示完成后触发该方法。
   * @returns {Promise.<void>}
   */
  async setMapLoadedListener(onMapLoaded) {
    try {
      var success = await M.setMapLoadedListener(this._SMMapId);
      
      if (!success) return;
      //差异化处理
      if (Platform.OS === 'ios') {
        
        nativeEvt.addListener("com.supermap.RN.JSMap.map_loaded", function (e) {
          if (typeof onMapLoaded === 'function') {
            onMapLoaded();
          } else {
            console.error("Please set a callback function to the first argument.");
          }
        });
        return
      }
      
      DeviceEventEmitter.addListener("com.supermap.RN.JSMap.map_loaded", function (e) {
        if (typeof onMapLoaded === 'function') {
          onMapLoaded();
        } else {
          console.error("Please set a callback function to the first argument.");
        }
      });
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加一个用于接收地图打开、关闭事件的监听器。
   * @memberOf Map
   * @param {object} events - 传入一个对象作为参数，该对象可以包含两个属性：mapOpened和mapClosed。两个属性的值均为function类型，分部作为打开地图和关闭地图监听事件的处理函数。例：{"mapOpened":()=>return console.log('map opened'),"mapClosed":()=> console.log('map closed')}
   * @returns {Promise.<void>}
   */
  async setMapOperateListener(events) {
    try {
      var success = await M.setMapOperateListener(this._SMMapId);
      
      if (!success) return;
      //差异化处理
      if (Platform.OS === 'ios') {
        
        nativeEvt.addListener("com.supermap.RN.JSMap.map_opened", function (e) {
          if (typeof events.mapOpened === 'function') {
            events.mapOpened();
          } else {
            console.error("Please set a callback to the property 'mapOpened' in the first argument.");
          }
        });
        
        nativeEvt.addListener("com.supermap.RN.JSMap.map_closed", function (e) {
          if (typeof events.mapClosed === 'function') {
            events.mapClosed();
          } else {
            console.error("Please set a callback to the property 'mapClosed' in the first argument.");
          }
        });
        return
      }
      
      DeviceEventEmitter.addListener("com.supermap.RN.JSMap.map_opened", function (e) {
        if (typeof events.mapOpened === 'function') {
          events.mapOpened();
        } else {
          console.error("Please set a callback to the property 'mapOpened' in the first argument.");
        }
      });
      
      DeviceEventEmitter.addListener("com.supermap.RN.JSMap.map_closed", function (e) {
        if (typeof events.mapClosed === 'function') {
          events.mapClosed();
        } else {
          console.error("Please set a callback to the property 'mapClosed' in the first argument.");
        }
      });
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将地图平移指定的距离。
   * @memberOf Map
   * @param {double} offsetX - X 方向上的移动距离，单位为坐标单位。
   * @param {double} offsetY - Y 方向上的移动距离，单位为坐标单位。
   * @returns {Promise.<void>}
   */
  async pan(offsetX, offsetY) {
    try {
      await M.pan(this._SMMapId, offsetX, offsetY);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 全幅显示此地图。
   * @memberOf Map
   * @returns {Promise.<void>}
   */
  async viewEntire() {
    try {
      await M.viewEntire(this._SMMapId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将地图放大或缩小指定的比例。
   * @memberOf Map
   * @param {double} ratio - 缩放地图比例，此值不可以为负。
   * @returns {Promise.<void>}
   */
  async zoom(ratio) {
    try {
      if (ratio < 0) throw new Error("Ratio can`t be nagative.");
      await M.zoom(this._SMMapId, ratio);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取地图比例尺。
   * @memberOf Map
   * @returns {Promise.<number>}
   */
  async getScale() {
    try {
      let { scale } = await M.getScale(this._SMMapId);
      return scale;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置地图比例尺。
   * @memberOf Map
   * @param {double} scale - 缩放地图比例，此值不可以为负。
   * @returns {Promise.<void>}
   */
  async setScale(scale) {
    try {
      if (scale < 0) throw new Error("Scale can`t be nagative.");
      await M.setScale(this._SMMapId, scale);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 用于把一个数据集添加到此图层集合作为一个普通图层显示，即创建一个普通图层。其风格由系统默认设置。
   * @memberOf Map
   * @param dataset - 要添加到图层的数据集。
   * @param addToHead - 指定新创建图层是否放在图层集合的最上面一层。当设置为 false 时，则将此新创建图层放在最底层。
   * @returns {Promise.<layer>}
   */
  async addLayer(dataset, addToHead) {
    try {
      var { layerId } = await M.addLayer(this._SMMapId, dataset._SMDatasetId, addToHead);
      var layer = new Layer();
      layer._SMLayerId = layerId;
      return layer;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 新建一个图层组，并将数据集集合添加到图层组中
   * @param datasets
   * @param groupName
   * @returns {Promise.<Layer>}
   */
  async addLayerGroup(datasets, groupName) {
    try {
      let datasetsIds = []
      for (let i = 0; i < datasets.length; i++) {
        datasetsIds.push(datasets._SMDatasetId)
      }
      var { layerId } = await M.addLayerGroup(this._SMMapId, datasetsIds);
      var layer = new Layer();
      layer._SMLayerId = layerId;
      return layer;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 用于将一个数据集添加到此图层集合作为一个专题图层显示，即创建一个专题图层，并指定专题图层的专题图对象。
   * @memberOf Map
   * @param dataset - 要添加到图层的数据集。
   * @param theme - 指定此专题图层的专题图对象。
   * @param addToHead - 指定新创建图层是否放在图层集合的最上面一层。当设置为 false 时，则将此新创建图层放在最底层。
   * @returns {Promise.<Layer>}
   */
  async addThemeLayer(dataset, theme, addToHead) {
    try {
      var { layerId } = await M.addThemeLayer(this._SMMapId, dataset._SMDatasetId, theme._SMThemeId, addToHead);
      var layer = new Layer();
      layer._SMLayerId = layerId;
      return layer;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 用于把一个图层移除。
   * @memberOf Map
   * @param index<string/number> - 要移除图层的名字或序号。
   * @returns {Promise.<void>}
   */
  async removeLayer(index) {
    try {
      let result
      if (typeof index === 'string') {
        result = await M.removeLayerByName(this._SMMapId, index);
      } else if (typeof index === 'number') {
        result = await M.removeLayerByIndex(this._SMMapId, index);
      } else {
        throw new Error('index must be number or string!');
      }
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 判断地图是否包含某个名字的图层。
   * @memberOf Map
   * @param name - 图层的名字。
   * @returns {Promise.<number>} 找到指定图层则返回图层索引，否则返回-1
   */
  async contains(name) {
    try {
      var { isContain } = await M.contains(this._SMMapId, name);
      return isContain;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 判断地图是否包含某个名字的数据集。(比较Caption)
   * @param name  -  数据集名称
   * @param datasourceName  - 数据源名称
   * @returns {Promise.<Promise.isContain>}
   */
  async containsCaption(name, datasourceName) {
    try {
      var { isContain } = await M.containsCaption(this._SMMapId, name, datasourceName);
      return isContain;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将指定位置的图层移动到另一个指定位置
   * @param from
   * @param to
   * @returns {Promise.<bool.moved>}
   */
  async moveTo(from, to) {
    try {
      return await M.moveTo(this._SMMapId, from, to);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 图层下移一层（图层的索引从 0 开始，从顶层开始依次编号）。
   * @memberOf Map
   * @param name - 图层的名字。
   * @returns {Promise.<bool>}
   */
  async moveDown(name) {
    try {
      var { moved } = await M.moveDown(this._SMMapId, name);
      return moved;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 图层上移一层（图层的索引从 0 开始，从顶层开始依次编号）。
   * @memberOf Map
   * @param name - 图层的名字。
   * @returns {Promise.<bool>}
   */
  async moveUp(name) {
    try {
      var { moved } = await M.moveUp(this._SMMapId, name);
      return moved;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 插入一个图层
   * @param index
   * @param layer
   * @returns {Promise.<Promise|Promise.<*>|List<T>|void|List.<T|U>>}
   */
  async insert(index, layer) {
    try {
      return await M.insert(this._SMMapId, index, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 判断当前地图是否被更改
   * @returns {Promise.<Promise.isModified>}
   */
  async isModified() {
    try {
      var { isModified } = await M.isModified(this._SMMapId);
      return isModified;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回地图的投影坐标系统
   * @returns {Promise.<PrjCoordSys>}
   */
  async getPrjCoordSys() {
    try {
      let prjCoordSysId = await M.getPrjCoordSys(this._SMMapId);
      let prjCoordSys = new PrjCoordSys()
      prjCoordSys._SMPrjCoordSysId = prjCoordSysId
      return prjCoordSys;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回地图的名称
   * @returns {Promise.<PrjCoordSys>}
   */
  async getName() {
    try {
      return await M.getName(this._SMMapId);
    } catch (e) {
      console.error(e);
    }
  }

  /**
   * 释放地图
   * @returns {Promise.<PrjCoordSys>}
   */
  async dispose() {
    try {
      return await M.dispose(this._SMMapId);
    } catch (e) {
      console.error(e);
    }
  }


}
