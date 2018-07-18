/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 Description: iOS中该类只是一个概念虚类，实际功能由mapControl完成。
 **********************************************************************************/
import { NativeModules,Platform } from 'react-native';
let MV = NativeModules.JSMapView;
import MapControl from './MapControl.js';
import Point2D from './Point2D.js';

/**
 * @class MapView
 * @description 地图显示控件容器类。
 */
export default class JSMapView{
    static NAVIGATION_STARTPOINT = "startpoint";
    static NAVIGATION_DESTPOINT = "destpoint";

    /**
     * 获取地图控件。
     * @memberOf MapView
     * @returns {Promise.<MapControl>}
     */
    async getMapControl(){
        try{
            var {mapControlId} =await MV.getMapControl(this._SMMapViewId);
            var mapControl = new MapControl();
            mapControl._SMMapControlId = mapControlId;
            return mapControl;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 在地图上添加一个点标记
     * @memberOf MapView
     * @param {object} point2D - 点标记
     * @param {string} pointName - 点标记名称
     * @returns {Promise.<Point2D>}
     */
    async addPoint(point2D,pointName){
        try{
            var {eth_point2DId} = await MV.addPoint(this._SMMapViewId,point2D._SMPoint2DId,pointName);
            var point2D = new Point2D();
            point2D._SMPoint2DId = eth_point2DId;
            return point2D;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 刷新地图
     * @memberOf MapView
     * @returns {Promise.<void>}
     */
    async refresh(){
        try{
            await MV.refresh(this._SMMapViewId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 添加callout层
     * @memberOf MapView
     * @param {object} callOut - callOut对象
     * @param {string} pointName - 点名称
     * @returns {Promise.<void>}
     */
    async addCallOut(callOut,pointName){
        try{
            await MV.addCallOut(this._SMMapViewId,callOut._SMCallOutId,pointName);
        }catch(e){
            debugger
            console.error(e);
        }
    }

    /**
     * 显示callout
     * @memberOf MapView
     * @returns {Promise.<void>}
     */
    async showCallOut(){
        try{
            await MV.showCallOut(this._SMMapViewId);
        }catch(e){
            console.error(e);
        }
    }
}
