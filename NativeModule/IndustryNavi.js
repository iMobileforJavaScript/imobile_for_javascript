/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules,DeviceEventEmitter} from 'react-native';
let N = NativeModules.JSNavigation2;
import Dataset from './Dataset.js';
import GeoLine from './GeoLine';

/**
 * @class Navigation2 
 * @description 行业导航类，提供基于拓扑路网的路径分析与导引。
 */
export default class Navigation2{
    /**
     * 设置路径可见
     * @memberOf Navigation2
     * @param {boolean} visible - 设置分析路径是否可见。
     * @returns {Promise.<void>}
     */
    async setPathVisible(visible){
        try{
            await N.setPathVisible(this._SMNavigation2Id,visible);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置用于分析的网络数据集。必选。
     * @memberOf Navigation2
     * @param {object} datasetVector - 网络数据集。
     * @returns {Promise.<void>}
     */
    async setNetworkDataset(datasetVector){
            try{
                await N.setNetworkDataset(this._SMNavigation2Id,datasetVector._SMDatasetVectorId);
            }catch (e){
                console.error(e);
            }
    }

    /**
     * 加载内存文件。
     * @memberOf Navigation2
     * @param {string} path - 内存文件路径。
     * @returns {Promise.<void>}
     */
    async loadModel(path){
        try{
            await N.loadModel(this._SMNavigation2Id,path);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置导航起点
     * @memberOf Navigation2
     * @param x - 起点横坐标
     * @param y - 起点纵坐标
     * @param map - 导航所属地图对象
     * @returns {Promise.<void>}
     */
    async setStartPoint(x,y,map){
        try{
            await N.setStartPoint(this._SMNavigation2Id,x,y,map._SMMapId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置导航终点
     * @memberOf Navigation2
     * @param x - 终点横坐标
     * @param y - 终点纵坐标
     * @param map - 导航所属地图对象
     * @returns {Promise.<void>}
     */
    async setDestinationPoint(x,y,map){
        try{
            await N.setDestinationPoint(this._SMNavigation2Id,x,y,map._SMMapId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 路径分析
     * @memberOf Navigation2
     * @returns {Promise.<Promise.boolean>}
     */
    async routeAnalyst(){
        try{
            var {finished} = await N.routeAnalyst(this._SMNavigation2Id);
            return finished;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 开始导航
     * @memberOf Navigation2
     * @param guideMode - 导航模式：1：真实导航；2：模拟导航
     * @returns {Promise.<Promise.boolean>}
     */
    async startGuide(guideMode){
        try{
            var {isGuiding} = await N.startGuide(this._SMNavigation2Id,guideMode);
            return isGuiding;
        }catch(e){
            console.error(e);
        }
    }


    /**
     * 设置转向表数据集。可选。
     * @memberOf Navigation2
     * @param {DatasetVector} value - 转向表数据集。
     * @returns {Promise.<void>}
     */
    async setTurnDataset(value){
        try{
            await N.setTurnDataset(this._SMNavigation2Id,value._SMDatasetVectorId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置高程点数据集。可选。
     * @memberOf Navigation2
     * @param {DatasetVector} value - 转向表数据集。
     * @returns {Promise.<void>}
     */
    async setAltimetricPointDataset(value){
        try{
            await N.setAltimetricPointDataset(this._SMNavigation2Id,value._SMDatasetVectorId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取路径分析线路。
     * @memberOf Navigation2
     * @returns {Promise.<void>}
     */
    async getRoute(){
        try{
            var {geoLineId} = await N.getRoute(this._SMNavigation2Id);
            var geoLine = new GeoLine();
            geoLine._SMGeoLineId = geoLineId;
            return geoLine;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 清除路径分析结果。
     * @memberOf Navigation2
     * @returns {Promise.<GeoLine>}
     */
    async cleanPath(){
        try{
            await N.cleanPath(this._SMNavigation2Id);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 暂停导航
     * @memberOf Navigation2
     * @returns {Promise.<void>}
     */
    async pauseGuide(){
        try{
            await N.pauseGuide(this._SMNavigation2Id);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 继续导航
     * @memberOf Navigation2
     * @returns {Promise.<void>}
     */
    async resumeGuide(){
        try{
            await N.resumeGuide(this._SMNavigation2Id);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 停止引导。
     * @memberOf Navigation2
     * @returns {Promise.<Promise.boolean>}
     */
    async stopGuide(){
        try{
            var {stoped} = await N.stopGuide(this._SMNavigation2Id);
            return stoped
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 判断是否正在进行引导。
     * @memberOf Navigation2
     * @returns {Promise.<Promise.yes>}
     */
    async isGuiding(){
        try{
            var {yes} = await N.isGuiding(this._SMNavigation2Id);
            return yes
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 引导过程中是否允许平移地图。
     * @memberOf Navigation2
     * @param {boolean} pan
     * @returns {Promise.<void>}
     */
    async enablePanOnGuide(pan){
        try{
            await N.enablePanOnGuide(this._SMNavigation2Id,pan);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 导航中，小车在屏幕中居中显示
     * @memberOf Navigation2
     * @returns {Promise.<void>}
     */
    async locateMap(){
        try{
            await N.locateMap(this._SMNavigation2Id);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置是否自动采集GPS，设置为false时，需用户自己调用setGPSData传入GPS数据。
     * @memberOf Navigation2
     * @param {boolean} isAutoNavi - 是否自动采集GPS，默认自动采集。
     * @returns {Promise.<void>}
     */
    async setIsAutoNavi(isAutoNavi){
        try{
            await N.setIsAutoNavi(this._SMNavigation2Id,isAutoNavi);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置GPS数据。
     * @memberOf Navigation2
     * @param {object} newGps - GPS数据。
     * @returns {Promise.<void>}
     */
    async setGPSData(newGps){
        try{
            await N.setGPSData(this._SMNavigation2Id,newGps);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置最高限速字段
     * @memberOf Navigation2
     * @param {string} value - 速度字段名称
     * @returns {Promise.<void>}
     */
    async setSpeedField(value){
        try{
            await N.setSpeedField(this._SMNavigation2Id,value);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取障碍点集合
     * @memberOf Navigation2
     * @returns {Promise.<array>}
     */
    async getBarrierPoints(){
        try{
            var {barrierPoints} = await N.getBarrierPoints(this._SMNavigation2Id);
            return barrierPoints;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置障碍点
     * @memberOf Navigation2
     * @param {array} barrierPoints - 障碍点集合（参数为null时，为清空障碍点）
     * @returns {Promise.<void>}
     */
    async setBarrierPoints(barrierPoints){
        try{
            await N.setBarrierPoints(this._SMNavigation2Id,barrierPoints);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置障碍节点
     * @memberOf Navigation2
     * @param {array[number]} value - 障碍节点集合（参数为null时，为清空障碍节点）；其包含的int值为网络数据集中的节点(Node)数据的SmID值
     * @returns {Promise.<void>}
     */
    async setBarrierNodes(value){
        try{
            await N.setBarrierNodes(this._SMNavigation2Id,value);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置障碍边
     * @memberOf Navigation2
     * @param {array[number]} value - 障碍边集合（参数为null时，为清空障碍边）；其包含的int值为网络数据集中的线数据的SmID值
     * @returns {Promise.<void>}
     */
    async setBarrierEdges(value){
        try{
            await N.setBarrierEdges(this._SMNavigation2Id,value);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取障碍边集合
     * @memberOf Navigation2
     * @returns {Promise.<void>}
     */
    async getBarrierEdges(){
        try{
            var {barrierEdges} = await N.getBarrierEdges(this._SMNavigation2Id);
            return barrierEdges;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置离终点的距离变化监听器。
     * @param events - 离终点的距离变化监听器回调函数对象。
     * @description 用法：await industryNavi.setDistanceChangeListener({distanceChange:(e) => {console.log(e.distance}})
     * @returns {Promise}
     */
    async setDistanceChangeListener(events){
        try{
            var success = await N.setDistanceChangeListener(this._SMNavigation2Id);
            if(success){
                typeof events.distanceChange !== 'function'  ||
                DeviceEventEmitter.addListener("com.supermap.RN.JSNavigation2.distance_change",function (e) {
                    events.distanceChange(e);
                });
            }
            return success;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置导航信息变化监听器
     * @param callback - 导航信息变化监听器回调函数。
     * @description 用法：await industryNavi.setDistanceChangeListener(
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
            var success = await N.addNaviInfoListener(this._SMNavigation2Id);
            if(success){
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
            return success;
        }catch(e){
            console.error(e);
        }
    }
}
