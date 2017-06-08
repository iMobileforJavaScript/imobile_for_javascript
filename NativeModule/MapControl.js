/**
 * Created by will on 2016/6/17.
 */
const LONGPRESS_EVENT = "com.supermap.RN.JSMapcontrol.long_press_event";

import { NativeModules,DeviceEventEmitter,NativeEventEmitter,Platform } from 'react-native';
let MC = NativeModules.JSMapControl;
import Map from './Map.js';
import Navigation2 from './IndustryNavi.js';
import TraditionalNavi from './TraditionalNavi';
import GeoPoint from './GeoPoint.js';
import GeoRegion from './GeoRegion.js';
import GeoLine from './GeoLine.js';
import Geometry from './Geometry.js';
import Layer from './Layer.js';

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
 */
export default class MapControl{

    /**
     * 返回在地图控件中显示的地图对象。
     * @memberOf MapControl
     * @returns {Promise.<Map>}
     */
    async getMap(){
        try{
            var {mapId} =await MC.getMap(this.mapControlId);
            var map = new Map();
            map.mapId = mapId;
            return map;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置地图控件中地图的当前操作状态。
     * @memberOf MapControl
     * @param {number} actionType
     * @returns {Promise.<void>}
     */
    async setAction(actionType){
        try{
            await MC.setAction(this.mapControlId,actionType);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 提交操作，对于采集而言，该接口将把采集的新几何对象写入到数据集，对于编辑，则是更新数据集中的正在编辑的对象。
     * @memberOf MapControl
     * @returns {Promise.<Promise|*|{phasedRegistrationNames}>}
     */
    async submit(){
        try{
            var submited = await MC.submit(this.mapControlId);
            return submited;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 监听编辑行为的变更事件
     * @memberOf MapControl
     * @param {function} actionChange 编辑行为变更函数，回调事件参数：e:newAction,e:oldAction
     */
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

    /**
     * 移除动作变更监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeActionChangedListener(actionChange){
        try{
            await MC.removeActionChangedListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 监听导航事件
     * @memberOf MapControl
     * @param {object} events - 传入一个对象作为参数，该对象可以包含两个属性：longPressHandler和scrollHandler。两个属性的值均为function类型，分部作为长按与滚动监听事件的处理函数。
     * @returns {Promise.<void>}
     */
    async setGestureDetector(handlers){
        try{
            if(handlers){
                await MC.setGestureDetector(this.mapControlId);
            }else{
                throw new Error("setGestureDetector need callback functions as first two argument!");
            }
            //差异化
            if(Platform.OS === 'ios'){
                if(typeof handlers.longPressHandler === "function"){
                    nativeEvt.addListener("com.supermap.RN.JSMapcontrol.long_press_event",function (e) {
                                                   // longPressHandler && longPressHandler(e);
                                                   handlers.longPressHandler(e);
                                                   });
                }
                
                if(typeof handlers.scrollHandler === "function"){
                    nativeEvt.addListener('com.supermap.RN.JSMapcontrol.scroll_event',function (e) {
                                                   scrollHandler && scrollHandler(e);
                                                   });
                }
            }else{
                if(typeof handlers.longPressHandler === "function"){
                    DeviceEventEmitter.addListener("com.supermap.RN.JSMapcontrol.long_press_event",function (e) {
                                                   // longPressHandler && longPressHandler(e);
                                                   handlers.longPressHandler(e);
                                                   });
                }
                
                if(typeof handlers.scrollHandler === "function"){
                    DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.scroll_event',function (e) {
                                                   scrollHandler && scrollHandler(e);
                                                   });
                }
            }

        }catch (e){
            console.error(e);
        }
    }

    async deleteGestureDetector(){
        try{
            await MC.deleteGestureDetector(this.mapControlId)
        }catch (e){
            console.error(e);
        }
    }

    /**
     *  监听地图参数变化，分别由边界变化sizeChanged,比例尺变化scaleChanged,角度变化angleChanged,中心点变化boundsChanged(iOS目前只支持比例尺变化监听与中心点变化监听)。
     * @memberOf MapControl
     * @param events 该对象有下面四个函数类型的属性分别处理四种监听事件
     * {boundsChanged,scaleChanged,angleChanged,sizeChanged}
     */
    async setMapParamChangedListener(events){
        try{
            boundsChanged = events.boundsChanged;
            scaleChanged = events.scaleChanged;
            angleChanged = events.angleChanged;
            sizeChanged = events.sizeChanged;

            var success = await MC.setMapParamChangedListener(this.mapControlId);
            console.debug("Listening map parameters changed.");

            if(!success) return;
            //差异化处理
            if(Platform.OS === 'ios'){
                nativeEvt.addListener('Supermap.MapControl.MapParamChanged.BoundsChanged',function (e) {
                   if(typeof boundsChanged == 'function'){
                       events.boundsChanged(e);
                   }else{
                       console.error("Please set a callback to the property 'boundsChanged' in the first argument.");
                   }
                });
                nativeEvt.addListener('Supermap.MapControl.MapParamChanged.ScaleChanged',function (e) {
                  if(typeof events.scaleChanged == 'function'){
                      events.scaleChanged(e);
                  }else{
                      console.error("Please set a callback to the property 'scaleChanged' in the first argument.");
                  }
                });

                return
            }

            DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.BoundsChanged',function (e) {
                if(typeof boundsChanged == 'function'){
                    events.boundsChanged(e);
                }else{
                    console.error("Please set a callback to the property 'boundsChanged' in the first argument.");
                }
            });
            DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.ScaleChanged',function (e) {
                if(typeof events.scaleChanged == 'function'){
                    events.scaleChanged(e);
                }else{
                    console.error("Please set a callback to the property 'scaleChanged' in the first argument.");
                }
            });
            DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.AngleChanged',function (e) {
                if(typeof events.angleChanged == 'function' ){
                    events.angleChanged(e);
                }else {
                    console.error("Please set a callback to the property 'angleChanged' in the first argument.");
                }
            });
            DeviceEventEmitter.addListener('Supermap.MapControl.MapParamChanged.SizeChanged',function (e) {
                if(typeof events.sizeChanged == 'function' ){
                    events.sizeChanged(e);
                }else {
                    console.error("Please set a callback to the property 'sizeChanged' in the first argument.");
                }
            });
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 地图刷新监听器
     * @memberOf MapControl
     * @param {function} callback - 刷新处理回调函数
     * @returns {Promise.<void>}
     */
    async setRefreshListener(callback){
        try{
            var success = await MC.setRefreshListener(this.mapControlId);
            console.log("MapControl:test result:",success);
            if(success){
                DeviceEventEmitter.addListener("com.supermap.RN.JSMapcontrol.refresh_event",function (e) {
                    // console.log("MapControl:监听到地图刷新");
                    if(typeof callback == 'function'){
                        callback(e);
                    }else{
                        console.error("Please set a callback function as the first argument.");
                    }
                });
            }
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获得当前Geometry几何对象
     * @memberOf MapControl
     * @returns {Promise.<GeoPoint|GeoLine|GeoRegion|Geometry>}
     */
    async getCurrentGeometry(){
        try{
            var {geometryId,geoType} = await MC.getCurrentGeometry(this.mapControlId);

            if(geoType == "GeoPoint"){
                var geoPoint = new GeoPoint();
                geoPoint.geoPointId = geometryId;
            }else if(geoType == "GeoRegion"){
                var geoRegion = new GeoRegion();
                geoRegion.geoRegionId = geometryId;
            }else if(geoType == "GeoLine"){
                var geoLine = new GeoLine();
                geoLine.geoLineId = geometryId;
            }else{
                var geometry = new Geometry();
                geometry.geometryId = geometryId;
            }
            return geoPoint || geoLine || geoRegion || geometry;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取导航控件
     * @memberOf MapControl
     * @returns {Promise.<Navigation2>}
     */
    async getIndustryNavi(){
        try{
            var {navigation2Id} = await MC.getNavigation2(this.mapControlId);
            var navigation2 = new Navigation2();
            navigation2.navigation2Id = navigation2Id;
            return navigation2;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置横竖屏切换监听器。
     * @memberOf MapControl
     * @param {object} events - 传入一个对象作为参数，该对象可以包含两个属性：toHorizontalScreen和toVerticalScreen。两个属性的值均为function类型，分部作为横屏与竖屏监听事件的处理函数。
     * @returns {Promise.<void>}
     */
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

    /**
     * 获得传统导航控件
     * @memberOf MapControl
     * @returns {Promise.<TraditionalNavi>}
     */
    async getTraditionalNavi(){
        try{
            var {traditionalNaviId} = await MC.getTraditionalNavi(this.mapControlId);
            var traditionalNavi= new TraditionalNavi();
            traditionalNavi.traditionalNaviId = traditionalNaviId;
            return traditionalNavi;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 返回地图控件中地图的当前操作状态。
     * @memberOf MapControl
     * @returns {Promise.<string>}
     */
    async getAction(){
        try{
            var {actionType} = await MC.getAction(this.mapControlId);
            for( p in this.ACTION){
                if(this.ACTION[p] === actionType){
                    console.log("MapControl.js:"+p);
                    return p;
                }else{
                    throw new Error("Unknown Type");
                }
            }
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 地图窗口上恢复上一步的操作。
     * @memberOf MapControl
     * @returns {Promise.<boolean>}
     */
    async redo(){
        try{
            var {redone} = await MC.redo(this.mapControlId);
            return redone;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 地图控件上撤消上一次的操作。
     * @memberOf MapControl
     * @returns {Promise.<boolean>}
     */
    async undo(){
        try{
            var {undone} = await MC.undo(this.mapControlId);
            return undone;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 取消操作，对于采集而言，新建的未提交的数据将被清除，对于编辑，将回到上一次提交保存的状态。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async cancel(){
        try{
            var {canceled} = await MC.cancel(this.mapControlId);
            return canceled;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 删除当前绘制出来的几何对象。
     * @memberOf MapControl
     * @returns {Promise.<Promise.deleted>}
     */
    async deleteCurrentGeometry(){
        try{
            var {deleted} = await MC.deleteCurrentGeometry(this.mapControlId);
            return deleted;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取当前编辑图层
     * @memberOf MapControl
     * @returns {Promise.<object>}
     */
    async getEditLayer(){
        try{
            var {layerId} = await MC.getEditLayer(this.mapControlId);
            var layer = new Layer();
            layer.layerId = layerId;
            return layer;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加对象删除完成监听器。
     * @memberOf MapControl
     * @param {object} event - event:{geometryDeleted: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，被删除对象id，删除结果canceled,ture为删除成功，否则为false.
     * @returns {Promise.<boolean>}
     */
    async addGeometryDeletedListener(event){
        try{
            var success = await MC.addGeometryDeletedListener(this.mapControlId);
            if(!success) return ;

            DeviceEventEmitter.addListener('com.supermap.RN.JSMapControl.geometry_deleted',function (e) {
                if(typeof event.geometryDeleted === 'function'){
                    var layer = new Layer();
                    layer.layerId = e.layerId;
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

    /**
     * 移除对象删除完成监听器
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeGeometryDeletedListener(){
        try{
            await MC. removeGeometryDeletedListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加对象添加监听器
     * @memberOf MapControl
     * @param {object} event - event:{geometryAdded: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
     * @returns {Promise.<*>}
     */
    async addGeometryAddedListener(event){
        try{
            var success = await MC.addGeometryAddedListener(this.mapControlId);
            if(!success) return ;

            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.grometry_added',function (e) {
                if(typeof event.geometryAdded === 'function'){
                    var layer = new Layer();
                    layer.layerId = e.layerId;
                    e.layer = layer;
                    event.geometryAdded(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            return success;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 移除对象添加监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeGeometryAddedListener(){
        try{
            await MC. removeGeometryAddedListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加对象删除完成前监听器。
     * @memberOf MapControl
     * @param {object} event - event:{geometryDeleting: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
     * @returns {Promise.<*>}
     */
    async addGeometryDeletingListener(event){
        try{
            var success = await MC.addGeometryDeletingListener(this.mapControlId);
            if(!success) return ;

            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_deleting',function (e) {
                if(typeof event.geometryDeleting === 'function'){
                    var layer = new Layer();
                    layer.layerId = e.layerId;
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

    /**
     * 移除对象删除完成前监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeGeometryDeletingListener(){
        try{
            await MC. removeGeometryDeletingListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加对象修改完成监听器
     * @memberOf MapControl
     * @param {object} event - event:{geometryModified: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
     * @returns {Promise.<*>}
     */
    async addGeometryModifiedListener(event){
        try{
            var success = await MC.addGeometryModifiedListener(this.mapControlId);
            if(!success) return ;

            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_modified',function (e) {
                if(typeof event.geometryModified === 'function'){
                    var layer = new Layer();
                    layer.layerId = e.layerId;
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

    /**
     * 移除对象删除完成前监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeGeometryModifiedListener(){
        try{
            await MC. removeGeometryModifiedListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加对象修改前监听器
     * @memberOf MapControl
     * @param event - event:{geometryModifying: e => {...}} e:{layer:--, id:--,canceled:--} layer:操作的图层，操作对象id，操作结果canceled,ture为操作成功，否则为false.
     * @returns {Promise.<*>}
     */
    async addGeometryModifyingListener(event){
        try{
            var success = await MC.addGeometryModifyingListener(this.mapControlId);
            if(!success) return ;

            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_modifying',function (e) {
                if(typeof event.geometryModifying === 'function'){
                    var layer = new Layer();
                    layer.layerId = e.layerId;
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

    /**
     * 移除对象修改完成监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeGeometryModifyingListener(){
        try{
            await MC. removeGeometryModifyingListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加对象修改前监听器
     * @memberOf MapControl
     * @param events - events:{geometrySelected: e => {...},geometryMultiSelected e => {...}}
     * geometrySelected 单个集合对象被选中事件的回调函数，参数e为获取结果 e:{layer:--, id:--} layer:操作的图层，操作对象id.
     * geometryMultiSelected 多个集合对象被选中事件的回调函数，参数e为获取结果数组：e:{geometries:[layer:--,id:--]}
     * @returns {Promise.<*>}
     */
    async addGeometrySelectedListener(events){
        try{
            var success = await MC.addGeometrySelectedListener(this.mapControlId);
            if(!success) return ;
            //差异化
            if(Platform.OS === 'ios'){
                nativeEvt.addListener('com.supermap.RN.JSMapcontrol.geometry_selected',function (e) {
                        if(typeof events.geometrySelected === 'function'){
                            var layer = new Layer();
                            layer.layerId = e.layerId;
                            e.layer = layer;
                            events.geometrySelected(e);
                        }else{
                            console.error("Please set a callback to the first argument.");
                        }
                });
                nativeEvt.addListener('com.supermap.RN.JSMapcontrol.geometry_multi_selected',function (e) {
                        if(typeof events.geometryMultiSelected === 'function'){
                            e.geometries.map(function (geometry) {
                                var layer = new Layer();
                                layer.layerId = geometry.layerId;
                                geometry.layer = layer;
                            })
                            events.geometryMultiSelected(e);
                         }else{
                            console.error("Please set a callback to the first argument.");
                         }
                        });
            }else{
            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_selected',function (e) {
                if(typeof events.geometrySelected === 'function'){
                    var layer = new Layer();
                    layer.layerId = e.layerId;
                    e.layer = layer;
                    events.geometrySelected(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.geometry_multi_selected',function (e) {
                if(typeof events.geometryMultiSelected === 'function'){
                    e.geometries.map(function (geometry) {
                        var layer = new Layer();
                        layer.layerId = geometry.layerId;
                        geometry.layer = layer;
                    })
                    events.geometryMultiSelected(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            }
            return success;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 移除对象选中监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeGeometrySelectedListener(){
        try{
            await MC. removeGeometrySelectedListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加对象修改前监听器
     * @memberOf MapControl
     * @param events - events:{lengthMeasured: e => {...},areaMeasured: e => {...},e => {...},angleMeasured: e => {...}}
     * lengthMeasured 长度量算结果。 e:{curResult:--, curPoint:{x:--,y--}
     * areaMeasured 面积量算结果。 e:{curResult:--, curPoint:{x:--,y--}
     * angleMeasured 测量角度结果 通过设置Action.MEASUREANGLE实现测量角度。  e:{curAngle:--, curPoint:{x:--,y--}
     * @returns {Promise.<*>}
     */
    async addMeasureListener(events){
        try{
            var success = await MC.addGeometryModifyingListener(this.mapControlId);
            if(!success) return ;

            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.length_measured',function (e) {
                if(typeof events.lengthMeasured === 'function'){
                    events.lengthMeasured(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.area_measured',function (e) {
                if(typeof events.areaMeasured === 'function'){
                    events.areaMeasured(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.angle_measured',function (e) {
                if(typeof events.angleMeasured === 'function'){
                    events.angleMeasured(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            return success;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 移除量算监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeMeasureListener(){
        try{
            await MC. removeMeasureListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置Undo监听器。
     * @memberOf MapControl
     * @param event - event:{undoStateChange: e => {...}}  e:{canUndo:--,canRedo:--} 返回参数canUndo表示是否可取消，canRedo表示是否可重复
     * @returns {Promise.<*>}
     */
    async addUndoStateChangeListener(event){
        try{
            var success = await MC.addUndoStateChangeListener(this.mapControlId);
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

    /**
     * 移除Undo监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeUndoStateChangeListener(){
        try{
            await MC.removeUndoStateChangeListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置编辑状态监听器。
     * @memberOf MapControl
     * @param events - events:{addNodeEnable: e => {...},deleteNodeEnable: e => {...}}
     * addNodeEnable: 添加节点有效。e:{isEnable:--}
     * deleteNodeEnable: 删除节点有效。 e:{isEnable:--}
     * @returns {Promise.<*>}
     */
    async setEditStatusListener(events){
        try{
            var success = await MC.setEditStatusListener(this.mapControlId);
            if(!success) return ;

            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.add_node_enable',function (e) {
                if(typeof events.addNodeEnable === 'function'){
                    events.addNodeEnable(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.delete_node_enable',function (e) {
                if(typeof events.deleteNodeEnable === 'function'){
                    events.deleteNodeEnable(e);
                }else{
                    console.error("Please set a callback to the first argument.");
                }
            });
            return success;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 添加、删除节点事件的监听器。
     * @memberOf MapControl
     * @returns {Promise.<void>}
     */
    async removeEditStatusListener(){
        try{
            await MC.removeEditStatusListener(this.mapControlId);
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 添加标绘库。
     * @memberOf MapControl
     * @returns {Promise.<int>}
     */
    async addPlotLibrary(url){
        try{
            var libId = await MC.addPlotLibrary(this.mapControlId,url);
            return libId;
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 设置标绘图案。
     * @memberOf MapControl
     * @returns {Promise.<int>}
     */
    async setPlotSymbol(libId,symbolCode){
        try{
            await MC.setPlotSymbol(this.mapControlId,libId,symbolCode);
        }catch (e){
            console.error(e);
        }
    }
}

MapControl.ACTION = {
    PAN:1,
    VERTEXADD:55,
    VERTEXDELETE:56,
    SELECT:8,
    VERTEXEDIT:54,
    CREATEPOINT:16,
    CREATEPOLYLINE:17,
    CREATEPOLYGON:27,
}
