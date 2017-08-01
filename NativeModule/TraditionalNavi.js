/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules,DeviceEventEmitter,NativeEventEmitter,Platform} from 'react-native';
let TN = NativeModules.JSNavigation;
import GeoLine from './GeoLine';

const nativeEvt = new NativeEventEmitter(TN);
/**
 * @class TraditionalNavi
 * @description 导航类，导航类提供路径分析和引导功能。(该类对象只能通过mapControl类下方法获取)
 */
export default class TraditionalNavi {
    /**
     * 链接导航路网数据
     * @memberOf TraditionalNavi
     * @param dataPath - 数据存储路径
     * @returns {Promise.<Promise.boolean>}
     */
    async connectNaviData(dataPath){
        try{
            var {success} = await TN.connectNaviData(this._SMTraditionalNaviId,dataPath);
            return success;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 执行路径分析。
     * 路径分析模式的值为[0，1，2，3]，其分别表示推荐模式、时间最快模式、距离最短模式、和最少收费模式。
     * @memberOf TraditionalNavi
     * @param mode - 路径分析模式。
     * @returns {Promise.<number>} 路径分析成功返回1，路径分析失败返回0，起点周围无道路返回-1，终点周围无道路返回-2。
     */
    async routeAnalyst(mode){
        try{
            var {result} = await TN.routeAnalyst(this._SMTraditionalNaviId,mode);
            return result;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 设置路径规划的起点。
     * @memberOf TraditionalNavi
     * @param x - 起点经度坐标（度）。
     * @param y - 起点纬度坐标(度)。
     * @param map - 导航所属地图对象
     * @returns {Promise.<void>}
     */
    async setStartPoint(x,y,map){
        try{
            await TN.setStartPoint(this._SMTraditionalNaviId,x,y,map._SMMapId);
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 设置路径规划的终点。
     * @memberOf TraditionalNavi
     * @param x - 终点经度坐标（度）。
     * @param y - 终点纬度坐标(度)。
     * @param map - 导航所属地图对象
     * @returns {Promise.<void>}
     */
    async setDestinationPoint(x,y,map){
        try{
            await TN.setDestinationPoint(this._SMTraditionalNaviId,x,y,map._SMMapId);
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 开始导航。
     * 引导状态的值为[0，1，2]，其分别表示执行真实导航、执行模拟导航、执行定位点巡航。
     * @memberOf TraditionalNavi
     * @param status  - 引导状态。
     * @returns {Promise.<void>}
     */
    async startGuide(status){
        try{
            var {guiding} = await TN.startGuide(this._SMTraditionalNaviId,status);
            return guiding;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 添加途经点
     * @memberOf TraditionalNavi
     * @param {number} x - 途经点x坐标
     * @param {number} y - 途经点y坐标
     * @returns {Promise.<Promise.boolean>}
     */
    async addWayPoint(x,y){
        try{
            var {added} = await TN.addWayPoint(this._SMTraditionalNaviId,x,y);
            return added;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 停止引导。
     * @memberOf TraditionalNavi
     * @returns {Promise.<Promise.boolean>}
     */
    async stopGuide(){
        try{
            var {stopped} = await TN.stopGuide(this._SMTraditionalNaviId);
            return stopped;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 设置导航指引信息控制,用于控制导航中是否播报引导信息
     * @memberOf TraditionalNavi
     * @param {boolean} speech
     * @returns {Promise.<Promise.speak>}
     */
    async setSpeechParam(speech){
        try{
            var {speak} = await TN.setSpeechParam(this._SMTraditionalNaviId,speech);
            return speak;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 设置GPS数据
     * @memberOf TraditionalNavi
     * @param {object} gpsData - gps数据
     * @returns {Promise.<void>}
     */
    async setGPSData(gpsData){
        try{
            await TN.setGPSData(this._SMTraditionalNaviId,gpsData);
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 导航中，将小车位置作为地图中心。 当允许导航中平移地图时，移动地图后，可以通过该接口使小车一直在地图中心显示。
     * @memberOf TraditionalNavi
     * @returns {Promise.<void>}
     */
    async locateMap(){
        try{
            await TN.locateMap(this._SMTraditionalNaviId);
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 当前是否在引导过程中。
     * @memberOf TraditionalNavi
     * @returns {Promise.<boolean>}
     */
    async isGuiding(){
        try{
            var {guiding} = await TN.isGuiding(this._SMTraditionalNaviId);
            return guiding;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 获取导航剩余时间
     * @memberOf TraditionalNavi
     * @param speed - 当前行驶速度
     * @returns {Promise.<number>}
     */
    async getTimeToDestination(speed){
        try{
            var {time} = await TN.getTimeToDestination(this._SMTraditionalNaviId,speed);
            return time;
        }catch (e){
            console.log(e);
        }
    }


    /**
     * 获得路径分析线路。
     * @memberOf TraditionalNavi
     * @returns {Promise.<object>}
     */
    async getRoute(){
        try{
            var {geoLineId} = await TN.getRoute(this._SMTraditionalNaviId);
            var geoLine = new GeoLine();
            geoLine._SMGeoLineId = geoLineId;

            return geoLine;
        }catch (e){
            console.log(e);
        }
    }

    /**
     * 引导过程中是否允许平移地图。
     * @memberOf TraditionalNavi
     * @param bPan - 一个布尔值，用来指示在导航过程中是否允许平移地图，true,表示允许，false,表示不允许。
     * @returns {Promise.<void>}
     */
    async enablePanOnGuide(bPan){
     try{
            await TN.enablePanOnGuide(this._SMTraditionalNaviId,bPan);
        }catch (e){
            console.log(e);
        }
     }

     /**
     * 清除路径分析的结果
     * @memberOf TraditionalNavi
     * @returns {Promise.<void>}
     */
    async cleanPath(){
        try{
            await TN.cleanPath(this._SMTraditionalNaviId);
        }catch (e){
            console.log(e);
        }
     }

    /**
     * 获取导航路径的详情
     * @returns {Promise.<Promise.array>} - 返回一个导航路径上所有路径的NaviStep对象数组，每个pathInfo对象的结构为{point:{x:--,y:--},length:--,name:--,time:--,turnType:--}
     */
    async getNaviPath() {
        try {
            var {naviPath} = await TN.getNaviPath(this._SMTraditionalNaviId);
            return naviPath;
        } catch (e) {
            console.log(e);
        }
    }

    /*
     * 设置导航信息变化监听器。
     * @param callback - 导航信息变化监听器回调函数。
     * 用法：await industryNavi.setDistanceChangeListener(
     *      {
     *          startNavi:(e) => {console.log("start")},
     *          naviInfoUpdate:(e) => {console.log(e.curRoadName + e.direction ....)},
     *          arrivedDestination:(e) => {console.log("updated")},
     *          stopNavi:(e) => {console.log("stop")},
     *          adjustFailure:(e) => {console.log("failure")},
     *          playNaviMessage:(e) => {console.log(e.message)},
     *
     *      }
     * );
     * 其中naviInfoUpdate回调中的参数是一个NaviInfo对象,其结构为：
     *      {
     *           curRoadName：--，
     *           direction：--，
     *           iconType：--，
     *           nextRoadName：--，
     *           routeRemainDis：--，
     *           routeRemainTime：--，
     *           segRemainDis：--
     *      }
     * @returns {Promise}
     */
    async addNaviInfoListener(events){
        try{
            var success = await TN.addNaviInfoListener(this._SMTraditionalNaviId);
            if(success){
                //差异化
                if(Platform.OS === 'ios'){
                    typeof events.startNavi !== 'function'  ||
                    nativeEvt.addListener("com.supermap.RN.JSNavigation2.start_navi",function (e) {
                                                   events.startNavi(e);
                                                   });
                    
                    typeof events.naviInfoUpdate !== 'function'  ||
                    nativeEvt.addListener("com.supermap.RN.JSNavigation2.navi_info_update",function (e) {
                                                   events.naviInfoUpdate(e);
                                                   });
                    
                    typeof events.arrivedDestination !== 'function'  ||
                    nativeEvt.addListener("com.supermap.RN.JSNavigation2.arrived_destination",function (e) {
                                                   events.arrivedDestination(e);
                                                   });
                    
                    typeof events.stopNavi !== 'function'  ||
                    nativeEvt.addListener("com.supermap.RN.JSNavigation2.stop_navi",function (e) {
                                                   events.stopNavi(e);
                                                   });
                }else{
                    
                    typeof events.startNavi !== 'function'  ||
                    DeviceEventEmitter.addListener("com.supermap.RN.JSNavigation2.start_navi",function (e) {
                                                   events.startNavi(e);
                                                   });
                    
                    typeof events.naviInfoUpdate !== 'function'  ||
                    DeviceEventEmitter.addListener("com.supermap.RN.JSNavigation2.navi_info_update",function (e) {
                                                   events.naviInfoUpdate(e);
                                                   });
                    
                    typeof events.arrivedDestination !== 'function'  ||
                    DeviceEventEmitter.addListener("com.supermap.RN.JSNavigation2.arrived_destination",function (e) {
                                                   events.arrivedDestination(e);
                                                   });
                    
                    typeof events.stopNavi !== 'function'  ||
                    DeviceEventEmitter.addListener("com.supermap.RN.JSNavigation2.stop_navi",function (e) {
                                                   events.stopNavi(e);
                                                   });
                    
                    typeof events.adjustFailure !== 'function'  ||
                    DeviceEventEmitter.addListener("com.supermap.RN.JSNavigation2.adjust_failure",function (e) {
                                                   events.adjustFailure(e);
                                                   });
                    
                    typeof events.playNaviMessage !== 'function'  ||
                    DeviceEventEmitter.addListener("com.supermap.RN.JSNavigation2.play_navi_massage",function (e) {
                                                   events.playNaviMessage(e);
                                                   });
                }
            }
            return success;
        }catch(e){
            console.error(e);
        }
    }

}
