/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
const LONGPRESS_EVENT = "com.supermap.RN.JSMapcontrol.long_press_event";

import { NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform, Dimensions } from 'react-native';
let MC = NativeModules.JSMapControl;
import Map from './Map.js';
import Navigation2 from './IndustryNavi.js';
import TraditionalNavi from './TraditionalNavi';
import GeoPoint from './GeoPoint.js';
import GeoRegion from './GeoRegion.js';
import GeoLine from './GeoLine.js';
import Geometry from './Geometry.js';
import Layer from './Layer.js';
import Collector from './Collector';

const nativeEvt = new NativeEventEmitter(MC);

/**
 * @class MapControl
 * @property {object} ACTION - PAN:地图漫游。
 VERTEXADD:在可编辑图层中为对象添加节点。
 VERTEXDELETE:在可编辑图层中为对象删除节点。
 SELECT:在对象上点击，选择对象。
 VERTEXEDIT:在可编辑图层中编辑对象的节点。
 CREATEPOINT:在可编辑图层上点击式绘点。
 CREATEPOLYLINE:在可编辑图层中点击式绘直线。
 CREATEPOLYGON:在可编辑图层中点击式绘多边形。
 ERASE_REGION                 // 擦除面对象
 SPLIT_BY_LINE                // 使用线切分
 UNION_REGION                 // 面与面合并
 COMPOSE_REGION               // 面与面组合
 PATCH_HOLLOW_REGION          // 切割岛洞多边形
 INTERSECT_REGION             // 填充导洞对象
 FILL_HOLLOW_REGION           // 求交面对象
 PATCH_POSOTIONAL_REGION      // 多对象补洞
 MOVE_COMMON_NODE             // 公共点编辑(协调编辑)
 CREATE_POSITIONAL_REGION     // 公共边构面
 SPLIT_BY_DRAWLINE            // 面被线分割（手绘式）
 DRAWREGION_HOLLOW_REGION     // 手绘岛洞面（手绘式）
 DRAWREGION_ERASE_REGION      // 面被面擦除(手绘式)
 SPLIT_BY_DRAWREGION          // 面被面分割(手绘式)
 MOVE_GEOMETRY                // 平移对象
 MULTI_SELECT                 // 多选对象
 SWIPE                        // 卷帘模式
 */
export default class MapControl {
  
  /**
   * 返回在地图控件中显示的地图对象。
   * @memberOf MapControl
   * @returns {Promise.<Map>}
   */
  async getMap() {
    try {
      var { mapId } = await MC.getMap(this._SMMapControlId);
      var map = new Map();
      map._SMMapId = mapId;
      return map;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置地图控件中地图的当前操作状态。
   * @memberOf MapControl
   * @param {number} actionType
   * @returns {Promise.<void>}
   */
  async setAction(actionType) {
    try {
      console.log(actionType)
      await MC.setAction(this._SMMapControlId, actionType);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 提交操作，对于采集而言，该接口将把采集的新几何对象写入到数据集，对于编辑，则是更新数据集中的正在编辑的对象。
   * @memberOf MapControl
   * @returns {Promise.<Promise|*|{phasedRegistrationNames}>}
   */
  async submit() {
    try {
      var submited = await MC.submit(this._SMMapControlId);
      return submited;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 监听编辑行为的变更事件(deprecated)
   * @memberOf MapControl
   * @param {function} actionChange 编辑行为变更函数，回调事件参数：e:newAction,e:oldAction
   */
  /*
   async addActionChangedListener(actionChange){
   try{
   DeviceEventEmitter.addListener('ActionChange', function(e) {
   actionChange && actionChange(e);
   });
   if(typeof actionChange == "function"){
   await MC.addActionChangedListener(this.mapControlId);
   }else{
   throw new Error("addActionChangedListener need a callback function as first argument!");
   }
   }catch (e){
   console.error(e);
   }
   }
   */
  
  
  /**
   * 移除动作变更监听器。(deprecated)
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  /*
   async removeActionChangedListener(actionChange){
   try{
   await MC.removeActionChangedListener(this._SMMapControlId);
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 手势监听
   * @memberOf MapControl
   * @param {object} events - 传入一个对象作为参数，该对象可以包含两个属性：longPressHandler和scrollHandler。两个属性的值均为function类型，分部作为长按与滚动监听事件的处理函数。
   * @returns {Promise.<void>}
   */
  async setGestureDetector(handlers) {
    try {
      if (handlers) {
        await MC.setGestureDetector(this._SMMapControlId);
      } else {
        throw new Error("setGestureDetector need callback functions as first two argument!");
      }
      //差异化
      if (Platform.OS === 'ios') {
        if (typeof handlers.longPressHandler === "function") {
          nativeEvt.addListener("com.supermap.RN.JSMapcontrol.long_press_event", function (e) {
            // longPressHandler && longPressHandler(e);
            handlers.longPressHandler(e);
          });
        }
        
        if (typeof handlers.singleTapHandler === "function") {
          nativeEvt.addListener("com.supermap.RN.JSMapcontrol.single_tap_event", function (e) {
            handlers.singleTapHandler(e);
          });
        }
        
        if (typeof handlers.doubleTapHandler === "function") {
          nativeEvt.addListener("com.supermap.RN.JSMapcontrol.double_tap_event", function (e) {
            handlers.doubleTapHandler(e);
          });
        }
        
        if (typeof handlers.touchBeganHandler === "function") {
          nativeEvt.addListener('com.supermap.RN.JSMapcontrol.touch_began_event', function (e) {
            handlers.touchBeganHandler(e);
          });
        }
        
        if (typeof handlers.touchEndHandler === "function") {
          nativeEvt.addListener('com.supermap.RN.JSMapcontrol.touch_end_event', function (e) {
            handlers.touchEndHandler(e);
          });
        }
        
        if (typeof handlers.scrollHandler === "function") {
          nativeEvt.addListener('com.supermap.RN.JSMapcontrol.scroll_event', function (e) {
            handlers.scrollHandler(e);
          });
        }
      } else {
        if (typeof handlers.longPressHandler === "function") {
          DeviceEventEmitter.addListener("com.supermap.RN.JSMapcontrol.long_press_event", function (e) {
            // longPressHandler && longPressHandler(e);
            handlers.longPressHandler(e);
          });
        }
        
        if (typeof handlers.singleTapHandler === "function") {
          DeviceEventEmitter.addListener("com.supermap.RN.JSMapcontrol.single_tap_event", function (e) {
            handlers.singleTapHandler(e);
          });
        }
        
        if (typeof handlers.doubleTapHandler === "function") {
          DeviceEventEmitter.addListener("com.supermap.RN.JSMapcontrol.double_tap_event", function (e) {
            handlers.doubleTapHandler(e);
          });
        }
        
        if (typeof handlers.touchBeganHandler === "function") {
          DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.touch_began_event', function (e) {
            handlers.touchBeganHandler(e);
          });
        }
        
        if (typeof handlers.touchEndHandler === "function") {
          DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.touch_end_event', function (e) {
            handlers.touchEndHandler(e);
          });
        }
        
        if (typeof handlers.scrollHandler === "function") {
          DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.scroll_event', function (e) {
            handlers.scrollHandler(e);
          });
        }
      }
      
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 移除手势监听
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  async deleteGestureDetector() {
    try {
      await MC.deleteGestureDetector(this._SMMapControlId)
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   *  监听地图参数变化，分别由边界变化sizeChanged,比例尺变化scaleChanged,角度变化angleChanged,中心点变化boundsChanged(iOS目前只支持比例尺变化监听与中心点变化监听)。
   * @memberOf MapControl
   * @param events 该对象有下面四个函数类型的属性分别处理四种监听事件
   * {boundsChanged,scaleChanged,angleChanged,sizeChanged}
   */
  async setMapParamChangedListener(events) {
    try {
      boundsChanged = events.boundsChanged;
      scaleChanged = events.scaleChanged;
      angleChanged = events.angleChanged;
      sizeChanged = events.sizeChanged;
      
      var success = await MC.setMapParamChangedListener(this._SMMapControlId);
      console.debug("Listening map parameters changed.");
      
      if (!success) return;
      //差异化处理
      if (Platform.OS === 'ios') {
        nativeEvt.addListener('Supermap.MapControl.MapParamChanged.BoundsChanged', function (e) {
          if (typeof boundsChanged == 'function') {
            events.boundsChanged(e);
          } else {
            console.error("Please set a callback to the property 'boundsChanged' in the first argument.");
          }
        });
        nativeEvt.addListener('Supermap.MapControl.MapParamChanged.ScaleChanged', function (e) {
          if (typeof events.scaleChanged == 'function') {
            events.scaleChanged(e);
          } else {
            console.error("Please set a callback to the property 'scaleChanged' in the first argument.");
          }
        });
        
        return
      }
      
      DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.BoundsChanged', function (e) {
        if (typeof boundsChanged == 'function') {
          events.boundsChanged(e);
        } else {
          console.error("Please set a callback to the property 'boundsChanged' in the first argument.");
        }
      });
      DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.ScaleChanged', function (e) {
        if (typeof events.scaleChanged == 'function') {
          events.scaleChanged(e);
        } else {
          console.error("Please set a callback to the property 'scaleChanged' in the first argument.");
        }
      });
      DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.AngleChanged', function (e) {
        if (typeof events.angleChanged == 'function') {
          events.angleChanged(e);
        } else {
          console.error("Please set a callback to the property 'angleChanged' in the first argument.");
        }
      });
      DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.SizeChanged', function (e) {
        if (typeof events.sizeChanged == 'function') {
          events.sizeChanged(e);
        } else {
          console.error("Please set a callback to the property 'sizeChanged' in the first argument.");
        }
      });
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 地图刷新监听器(deprecated)
   * @memberOf MapControl
   * @param {function} callback - 刷新处理回调函数
   * @returns {Promise.<void>}
   */
  
  async setRefreshListener(callback) {
    try {
      var success = await MC.setRefreshListener(this._SMMapControlId);
      console.log("MapControl:test result:", success);
      if (success) {
        DeviceEventEmitter.addListener("com.supermap.RN.JSMapcontrol.refresh_event", function (e) {
          // console.log("MapControl:监听到地图刷新");
          if (typeof callback === 'function') {
            callback(e);
          } else {
            console.error("Please set a callback function as the first argument.");
          }
        });
      }
    } catch (e) {
      console.error(e);
    }
  }
  
  
  /**
   * 获得当前Geometry几何对象
   * @memberOf MapControl
   * @returns {Promise.<GeoPoint|GeoLine|GeoRegion|Geometry>}
   */
  async getCurrentGeometry() {
    try {
      var { geometryId, geoType } = await MC.getCurrentGeometry(this._SMMapControlId);
      
      if (geoType == "GeoPoint") {
        var geoPoint = new GeoPoint();
        geoPoint._SMGeoPointId = geometryId;
      } else if (geoType == "GeoRegion") {
        var geoRegion = new GeoRegion();
        geoRegion._SMGeoRegionId = geometryId;
      } else if (geoType == "GeoLine") {
        var geoLine = new GeoLine();
        geoLine._SMGeoLineId = geometryId;
      } else {
        var geometry = new Geometry();
        geometry._SMGeometryId = geometryId;
      }
      return geoPoint || geoLine || geoRegion || geometry;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取导航控件
   * @memberOf MapControl
   * @returns {Promise.<Navigation2>}
   */
  async getIndustryNavi() {
    try {
      var { navigation2Id } = await MC.getNavigation2(this._SMMapControlId);
      var navigation2 = new Navigation2();
      navigation2._SMNavigation2Id = navigation2Id;
      return navigation2;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置横竖屏切换监听器。（deprecated）
   * @memberOf MapControl
   * @param {object} events - 传入一个对象作为参数，该对象可以包含两个属性：toHorizontalScreen和toVerticalScreen。两个属性的值均为function类型，分部作为横屏与竖屏监听事件的处理函数。
   * @returns {Promise.<void>}
   */
  /*
   async  setConfigurationChangedListener(events){
   try{
   var success = await MC. setConfigurationChangedListener();
   if(!success) return ;
   
   DeviceEventEmitter.addListener('com.supermap.RN.JSMapControl.to_horizontal_screen',function (e) {
   if(typeof events.toHorizontal_screen == 'function'){
   events.toHorizontalScreen();
   }else{
   console.error("Please set a callback to the property 'toHorizontalScreen' in the first argument.");
   }
   });
   DeviceEventEmitter.addListener('com.supermap.RN.JSMapControl.to_verticalscreen',function (e) {
   if(typeof events.toVerticalScreen == 'function'){
   events.toVerticalScreen();
   }else{
   console.error("Please set a callback to the property 'toVerticalScreen' in the first argument.");
   }
   });
   
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 获得传统导航控件
   * @memberOf MapControl
   * @returns {Promise.<TraditionalNavi>}
   */
  async getTraditionalNavi() {
    try {
      var { traditionalNaviId } = await MC.getTraditionalNavi(this._SMMapControlId);
      var traditionalNavi = new TraditionalNavi();
      traditionalNavi._SMTraditionalNaviId = traditionalNaviId;
      return traditionalNavi;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回地图控件中地图的当前操作状态。
   * @memberOf MapControl
   * @returns {Promise.<string>}
   */
  async getAction() {
    try {
      var { actionType } = await MC.getAction(this._SMMapControlId);
      var actionStr = 'type';
      switch (actionType) {
        case 0 :
          actionStr = 'NONEACTION';
          break;
        case 1 :
          actionStr = 'PAN';
          break;
        case 8 :
          actionStr = 'SELECT';
          break;
        case 54 :
          actionStr = 'VERTEXEDIT';
          break;
        case 55 :
          actionStr = 'VERTEXADD';
          break;
        case 56 :
          actionStr = 'DELETENODE';
          break;
        case 16 :
          actionStr = 'CREATEPOINT';
          break;
        case 17 :
          actionStr = 'CREATEPOLYLINE';
          break;
        case 27 :
          actionStr = 'CREATEPOLYGON';
          break;
        case 1001 :
          actionStr = 'MEASURELENGTH';
          break;
        case 1002 :
          actionStr = 'MEASUREAREA';
          break;
        case 1003 :
          actionStr = 'MEASUREANGLE';
          break;
        case 199 :
          actionStr = 'FREEDRAW';
          break;
        case 3000 :
          actionStr = 'CREATEPLOT';
          break;
        case 201 :
          actionStr = 'ERASE_REGION';
          break;
        case 202 :
          actionStr = 'SPLIT_BY_LINE';
          break;
        case 203 :
          actionStr = 'UNION_REGION';
          break;
        case 204 :
          actionStr = 'COMPOSE_REGION';
          break;
        case 205 :
          actionStr = 'PATCH_HOLLOW_REGION';
          break;
        case 207 :
          actionStr = 'INTERSECT_REGION';
          break;
        case 206 :
          actionStr = 'FILL_HOLLOW_REGION';
          break;
        case 208 :
          actionStr = 'PATCH_POSOTIONAL_REGION';
          break;
        case 209 :
          actionStr = 'MOVE_COMMON_NODE';
          break;
        case 210 :
          actionStr = 'CREATE_POSITIONAL_REGION';
          break;
        case 215 :
          actionStr = 'SPLIT_BY_DRAWLINE';
          break;
        case 216 :
          actionStr = 'DRAWREGION_HOLLOW_REGION';
          break;
        case 217 :
          actionStr = 'DRAWREGION_ERASE_REGION';
          break;
        case 218 :
          actionStr = 'SPLIT_BY_DRAWREGION';
          break;
        case 301 :
          actionStr = 'MOVE_GEOMETRY';
          break;
        case 305 :
          actionStr = 'MULTI_SELECT';
          break;
        case 501 :
          actionStr = 'SWIPE';
          break;
        default :
          throw new Error("Unknown Action Type");
      }
      return actionStr;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 地图窗口上恢复上一步的操作。
   * @memberOf MapControl
   * @returns {Promise.<boolean>}
   */
  async redo() {
    try {
      var { redone } = await MC.redo(this._SMMapControlId);
      return redone;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 地图控件上撤消上一次的操作。
   * @memberOf MapControl
   * @returns {Promise.<boolean>}
   */
  async undo() {
    try {
      var { undone } = await MC.undo(this._SMMapControlId);
      return undone;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 取消操作，对于采集而言，新建的未提交的数据将被清除，对于编辑，将回到上一次提交保存的状态。
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  async cancel() {
    try {
      var { canceled } = await MC.cancel(this._SMMapControlId);
      return canceled;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 删除当前绘制出来的几何对象。
   * @memberOf MapControl
   * @returns {Promise.<Promise.deleted>}
   */
  async deleteCurrentGeometry() {
    try {
      var { deleted } = await MC.deleteCurrentGeometry(this._SMMapControlId);
      return deleted;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取当前编辑图层
   * @memberOf MapControl
   * @returns {Promise.<object>}
   */
  async getEditLayer() {
    try {
      var { layerId } = await MC.getEditLayer(this._SMMapControlId);
      var layer = new Layer();
      layer._SMLayerId = layerId;
      return layer;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加对象删除完成监听器。(deprecated)
   * @memberOf MapControl
   * @param {object} event - event:{geometryDeleted: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，被删除对象id，删除结果canceled,ture为删除成功，否则为false.
   * @returns {Promise.<boolean>}
   */
  /*
   async addGeometryDeletedListener(event){
   try{
   var success = await MC.addGeometryDeletedListener(this._SMMapControlId);
   if(!success) return ;
   
   DeviceEventEmitter.addListener('com.supermap.RN.JSMapControl.geometry_deleted',function (e) {
   if(typeof event.geometryDeleted === 'function'){
   var layer = new Layer();
   layer._SMLayerId = e.layerId;
   e.layer = layer;
   event.geometryDeleted(e);
   }else{
   console.error("Please set a callback to the first argument.");
   }
   });
   return success;
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 移除对象删除完成监听器(deprecated)
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  /*
   async removeGeometryDeletedListener(){
   try{
   await MC. removeGeometryDeletedListener(this._SMMapControlId);
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 添加对象添加监听器
   * @memberOf MapControl
   * @param {object} event - event:{geometryAdded: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
   * @returns {Promise.<*>}
   */
  async addGeometryAddedListener(event) {
    try {
      var success = await MC.addGeometryAddedListener(this._SMMapControlId);
      if (!success) return;
      
      DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.grometry_added', function (e) {
        if (typeof event.geometryAdded === 'function') {
          var layer = new Layer();
          layer._SMLayerId = e.layerId;
          e.layer = layer;
          event.geometryAdded(e);
        } else {
          console.error("Please set a callback to the first argument.");
        }
      });
      return success;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 移除对象添加监听器。
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  async removeGeometryAddedListener() {
    try {
      await MC.removeGeometryAddedListener(this._SMMapControlId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加对象删除完成前监听器。(deprecated)
   * @memberOf MapControl
   * @param {object} event - event:{geometryDeleting: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
   * @returns {Promise.<*>}
   */
  /*
   async addGeometryDeletingListener(event){
   try{
   var success = await MC.addGeometryDeletingListener(this._SMMapControlId);
   if(!success) return ;
   
   DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_deleting',function (e) {
   if(typeof event.geometryDeleting === 'function'){
   var layer = new Layer();
   layer._SMLayerId = e.layerId;
   e.layer = layer;
   event.geometryDeleting(e);
   }else{
   console.error("Please set a callback to the first argument.");
   }
   });
   return success;
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 移除对象删除完成前监听器。(deprecated)
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  /*
   async removeGeometryDeletingListener(){
   try{
   await MC. removeGeometryDeletingListener(this._SMMapControlId);
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 添加对象修改完成监听器(deprecated)
   * @memberOf MapControl
   * @param {object} event - event:{geometryModified: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
   * @returns {Promise.<*>}
   */
  /*
   async addGeometryModifiedListener(event){
   try{
   var success = await MC.addGeometryModifiedListener(this._SMMapControlId);
   if(!success) return ;
   
   DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_modified',function (e) {
   if(typeof event.geometryModified === 'function'){
   var layer = new Layer();
   layer._SMLayerId = e.layerId;
   e.layer = layer;
   event.geometryModified(e);
   }else{
   console.error("Please set a callback to the first argument.");
   }
   });
   return success;
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 移除对象删除完成前监听器。(deprecated)
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  /*
   async removeGeometryModifiedListener(){
   try{
   await MC. removeGeometryModifiedListener(this._SMMapControlId);
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 添加对象修改前监听器(deprecated)
   * @memberOf MapControl
   * @param event - event:{geometryModifying: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
   * @returns {Promise.<*>}
   */
  /*
   async addGeometryModifyingListener(event){
   try{
   var success = await MC.addGeometryModifyingListener(this._SMMapControlId);
   if(!success) return ;
   
   DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_modifying',function (e) {
   if(typeof event.geometryModifying === 'function'){
   var layer = new Layer();
   layer._SMLayerId = e.layerId;
   e.layer = layer;
   event.geometryModifying(e);
   }else{
   console.error("Please set a callback to the first argument.");
   }
   });
   return success;
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 移除对象修改完成监听器。(deprecated)
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  /*
   async removeGeometryModifyingListener(){
   try{
   await MC. removeGeometryModifyingListener(this._SMMapControlId);
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 添加对象修改前监听器
   * @memberOf MapControl
   * @param events - events:{geometrySelected: e => {...},geometryMultiSelected e => {...}}
   * geometrySelected 单个集合对象被选中事件的回调函数，参数e为获取结果 e:{layer:--, id:--} layer:操作的图层，操作对象id.
   * geometryMultiSelected 多个集合对象被选中事件的回调函数，参数e为获取结果数组：e:{geometries:[layer:--,id:--]}
   * @returns {Promise.<*>}
   */
  async addGeometrySelectedListener(events) {
    try {
      var success = await MC.addGeometrySelectedListener(this._SMMapControlId);
      if (!success) return;
      //差异化
      if (Platform.OS === 'ios') {
        nativeEvt.addListener('com.supermap.RN.JSMapcontrol.geometry_selected', function (e) {
          if (typeof events.geometrySelected === 'function') {
            var layer = new Layer();
            layer._SMLayerId = e.layerId;
            e.layer = layer;
            events.geometrySelected(e);
          } else {
            console.error("Please set a callback to the first argument.");
          }
        });
        nativeEvt.addListener('com.supermap.RN.JSMapcontrol.geometry_multi_selected', function (e) {
          if (typeof events.geometryMultiSelected === 'function') {
            e.geometries.map(function (geometry) {
              var layer = new Layer();
              layer._SMLayerId = geometry.layerId;
              geometry.layer = layer;
            })
            events.geometryMultiSelected(e);
          } else {
            console.error("Please set a callback to the first argument.");
          }
        });
      } else {
        DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_selected', function (e) {
          if (typeof events.geometrySelected === 'function') {
            var layer = new Layer();
            layer._SMLayerId = e.layerId;
            e.layer = layer;
            events.geometrySelected(e);
          } else {
            console.error("Please set a callback to the first argument.");
          }
        });
        DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_multi_selected', function (e) {
          if (typeof events.geometryMultiSelected === 'function') {
            e.geometries.map(function (geometry) {
              var layer = new Layer();
              layer._SMLayerId = geometry.layerId;
              geometry.layer = layer;
            })
            events.geometryMultiSelected(e);
          } else {
            console.error("Please set a callback to the first argument.");
          }
        });
      }
      return success;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 移除对象选中监听器。
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  async removeGeometrySelectedListener() {
    try {
      await MC.removeGeometrySelectedListener(this._SMMapControlId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加量算回调监听器
   * @memberOf MapControl
   * @param events - events:{lengthMeasured: e => {...},areaMeasured: e => {...},e => {...},angleMeasured: e => {...}}
   * lengthMeasured 长度量算结果。 e:{curResult:--, curPoint:{x:--,y--}
     * areaMeasured 面积量算结果。 e:{curResult:--, curPoint:{x:--,y--}
     * angleMeasured 测量角度结果 通过设置Action.MEASUREANGLE实现测量角度。  e:{curAngle:--, curPoint:{x:--,y--}
   * @returns {Promise.<*>}
   */
  async addMeasureListener(events) {
    try {
      var success = await MC.addMeasureListener(this._SMMapControlId);
      if (!success) return;
      if (Platform.OS === 'ios') {
        if (typeof events.lengthMeasured === 'function') {
          nativeEvt.addListener('com.supermap.RN.JSMapcontrol.length_measured', function (e) {
            events.lengthMeasured(e);
          });
        }
        if (typeof events.areaMeasured === 'function') {
          nativeEvt.addListener('com.supermap.RN.JSMapcontrol.area_measured', function (e) {
            events.areaMeasured(e);
          });
        }
        if (typeof events.angleMeasured === 'function') {
          nativeEvt.addListener('com.supermap.RN.JSMapcontrol.angle_measured', function (e) {
            events.angleMeasured(e);
          });
        }
      } else {
        if (typeof events.lengthMeasured === 'function') {
          DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.length_measured', function (e) {
            events.lengthMeasured(e);
          });
        }
        if (typeof events.areaMeasured === 'function') {
          DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.area_measured', function (e) {
            events.areaMeasured(e);
          });
        }
        if (typeof events.angleMeasured === 'function') {
          DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.angle_measured', function (e) {
            events.angleMeasured(e);
          });
        }
      }
      
      return success;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 移除量算监听器。
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  async removeMeasureListener() {
    try {
      return await MC.removeMeasureListener(this._SMMapControlId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置Undo监听器。(deprecated)
   * @memberOf MapControl
   * @param event - event:{undoStateChange: e => {...}}  e:{canUndo:--,canRedo:--} 返回参数canUndo表示是否可取消，canRedo表示是否可重复
   * @returns {Promise.<*>}
   */
  /*
   async addUndoStateChangeListener(event){
   try{
   var success = await MC.addUndoStateChangeListener(this._SMMapControlId);
   if(!success) return ;
   
   DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.undo_state_change',function (e) {
   if(typeof event.undoStateChange === 'function'){
   event.undo_state_change(e);
   }else{
   console.error("Please set a callback to the first argument.");
   }
   });
   return success;
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 移除Undo监听器。(deprecated)
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  /*
   async removeUndoStateChangeListener(){
   try{
   await MC.removeUndoStateChangeListener(this._SMMapControlId);
   }catch (e){
   console.error(e);
   }
   }
   */
  
  /**
   * 设置编辑状态监听器。
   * @memberOf MapControl
   * @param events - events:{addNodeEnable: e => {...},deleteNodeEnable: e => {...}}
   * addNodeEnable: 添加节点有效。e:{isEnable:--}
   * deleteNodeEnable: 删除节点有效。 e:{isEnable:--}
   * @returns {Promise.<*>}
   */
  async setEditStatusListener(events) {
    try {
      var success = await MC.setEditStatusListener(this._SMMapControlId);
      if (!success) return;
      
      DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.add_node_enable', function (e) {
        if (typeof events.addNodeEnable === 'function') {
          events.addNodeEnable(e);
        } else {
          console.error("Please set a callback to the first argument.");
        }
      });
      DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.delete_node_enable', function (e) {
        if (typeof events.deleteNodeEnable === 'function') {
          events.deleteNodeEnable(e);
        } else {
          console.error("Please set a callback to the first argument.");
        }
      });
      return success;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加、删除节点事件的监听器。
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  async removeEditStatusListener() {
    try {
      await MC.removeEditStatusListener(this._SMMapControlId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加标绘库。
   * @memberOf MapControl
   * @returns {Promise.<int>}
   */
  async addPlotLibrary(url) {
    try {
      var libId = await MC.addPlotLibrary(this._SMMapControlId, url);
      return libId;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 添加标绘库。
   * @memberOf MapControl
   * @returns {Promise.<void>}
   */
  async removePlotLibrary(libId) {
    try {
      var isRemove = await MC.removePlotLibrary(this._SMMapControlId, libId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置标绘图案。
   * @memberOf MapControl
   * @returns {Promise.<int>}
   */
  async setPlotSymbol(libId, symbolCode) {
    try {
      var isSet = await MC.setPlotSymbol(this._SMMapControlId, libId, symbolCode);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回采集类
   * @returns {Promise.<Collector>}
   */
  async getCollector() {
    try {
      let id = await MC.getCollector(this._SMMapControlId);
      let collector = new Collector()
      collector._SMCollectorId = id
      return collector
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将当前显示内容绘制到指定位图上, 并获取路径
   * @params params      Object
   * mapView    Object
   * width      int
   * height     int
   * quality    int      0 - 100
   * type       string   png, jpg/jpeg, webp
   * @returns {Promise.<{result: Promise.result, uri: Promise.uri}>}
   */
  async outputMap(params = {}) {
    try {
      let paramss = {width: 2000, height: 2000, quality: 60, type: 'png', mapViewId: ''}
      Object.assign(paramss, params, {mapViewId: params.mapView._SMMapViewId})
      let { result, uri } = await MC.outputMap(this._SMMapControlId, paramss.mapViewId, paramss.width, paramss.height, paramss.quality, paramss.type);
      return { result, uri }
    } catch (e) {
      console.error(e);
    }
  }

  /**
   * 指定编辑几何对象
   * @param geoID
   * @param layer
   * @returns {Promise}
   */
  async appointEditGeometry(geoID, layer) {
    try {
      return await MC.appointEditGeometry(this._SMMapControlId, geoID, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  /**
   * 释放对象
   * @returns {Promise.<void>}
   */
  async dispose() {
    try {
      await MC.dispose(this._SMMapControlId);
    } catch (e) {
      console.error(e);
    }
  }
  
  // /**
  //  * 设置touch监听
  //  * @returns {Promise.<Collector>}
  //  */
  // async setOnTouchListener(events) {
  //   try {
  //     let success = await MC.setOnTouchListener(this._SMMapControlId);
  //     if (!success) return;
  //     nativeEvt.addListener('com.supermap.RN.JSMapcontrol.touch_up', function (e) {
  //       if (typeof events.onTouchUp === 'function') {
  //         events.onTouchUp(e);
  //       } else {
  //         console.error("Please set a callback to the first argument.");
  //       }
  //     });
  //   } catch (e) {
  //     console.error(e);
  //   }
  // }
}
