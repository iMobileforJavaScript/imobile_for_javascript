import {NativeModules} from 'react-native';
let T = NativeModules.JSTrack;
import Dataset from './Dataset.js';
import Datasets from './Datasets.js';

/**
 * @class Track
 */
export default class Track {

    /**
     * 创建一个Track对象
     * @memberOf Track
     * @returns {Promise.<Track>}
     */
    async createObj(){
        try{
            var {_trackId_} = await T.createObj();
            var track = new Track();
            track._trackId_ = _trackId_;
            return track;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 创建轨迹数据集，创建出来的数据集为点数据集。
     * @memberOf Track0
     * @param {object} datasource - 轨迹数据集所属的数据源。
     * @param {string} name - 数据集的名称。
     * @returns {Promise.<Dataset>}
     */
    async createDataset(datasource,name){
        try{
            var {datasetId} = await T.createDataset(this._trackId_,datasourceId,name);
            var dataset = new Dataset();
            dataset.datasetId = datasetId;
            return dataset;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取是否用户自定义定位点。(该方法只支持android设备)
     * @memberOf Track
     * @returns {Promise.<Promise.customLocation>}
     */
    async getCustomLocation(){
        try{
            var {customLocation} = await T.getCustomLocation(track._trackId_);
            return customLocation;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取轨迹数据集。
     * @memberOf Track
     * @returns {Promise.<Dataset>}
     */
    async getDataset(){
        try{
            var {datasetId} = await T.getDataset(this._trackId_);
            var dataset = new Dataset();
            dataset.datasetId = datasetId;
            return dataset;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取距离间隔，单位为米，默认的距离间隔是5米。
     * @memberOf Track
     * @returns {Promise.<Promise.distanceInterval>}
     */
    async getDistanceInterval(){
        try{
            var {distanceInterval} = await T.getDistanceInterval(track._trackId_);
            return distanceInterval;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取匹配线数据集集合。
     * @memberOf Track
     * @returns {Promise.<Datasets>}
     */
    async getMatchDatasets(){
        try{
            var {idArr} = await T.getMatchDatasets(this._trackId_);
            if(idArr === false){
                return false;
            }
            
            var objArr = [];
            for(var i=0; i<idArr.length; i++) {
                var dataset = new Dataset();
                dataset.datasetId = idArr[i];
                objArr.push(dataset);
            }
            return objArr;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取时间间隔。
     * @memberOf Track
     * @returns {Promise.<Promise.timeInterval>}
     */
    async getTimeInterval(){
        try{
            var {timeInterval} = await T.getTimeInterval(track._trackId_);
            return timeInterval;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取当前是否使用速度和方位角模式。(该方法只支持android设备)
     * @memberOf Track
     * @returns {Promise.<Promise.isSpeedDirectionEnable>}
     */
    async isSpeedDirectionEnable(){
        try{
            var {isSpeedDirectionEnable} = await T.isSpeedDirectionEnable(track._trackId_);
            return isSpeedDirectionEnable;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置是否用户自定义定位点，默认为true。(该方法只支持android设备)
     * @memberOf Track
     * @param {boolean} bCustomLocation - 是否用户自定义定位点。
     * @returns {Promise.<void>}
     */
    async setCustomLocation(bCustomLocation){
        try{
            await T.setCustomLocation(track._trackId_,bCustomLocation);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置轨迹数据集，用户使用轨迹功能时，要先使用创建轨迹数据集的方法创建数据集，然后调用该方法设置轨迹数据集。
     * @memberOf Track
     * @param {object} datasetVector - 轨迹数据集。
     * @returns {Promise.<void>}
     */
    async setDataset(dataset){
        try{
            await T.setDataset(track._trackId_,dataset.datasetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置距离间隔，单位为米，距离间隔值必须大于或等于3米，否则会自动处理为3米。
     * @memberOf Track
     * @param {number} interval - 距离间隔。
     * @returns {Promise.<void>}
     */
    async setDistanceInterval(interval){
        try{
            await T.setDistanceInterval(track._trackId_,interval);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置GPSData数据，只有将setCustomLocation(boolean bCustomLocation)参数设置为true时，该接口才起作用。
     *(该方法只支持android设备)
     * @memberOf Track
     * @param {object} jsonGpsData - 用户设置的gpsdata。
     * @returns {Promise.<void>}
     */
    async setGPSData(jsonGpsData){
        try{
            await T.setGPSData(track._trackId_,jsonGpsData);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置匹配线数据集集合，为轨迹抓路功能使用，该数据集集合应为线数据集集合。
     * @memberOf Track
     * @param {Array} datsets - 设置匹配线数据集集合。
     * @returns {Promise.<void>}
     */
    async setMatchDatasets(datsets){
        try{
            //to do
            await T.setMatchDatasets(track._trackId_,datsets.datasetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置速度和方位角模式，支持转弯、高速、低速场景下记录轨迹点的稀疏和加密
     *(该方法只支持android设备)
     * @memberOf Track
     * @param {number} speedDirectionEnable - 距离间隔。
     * @returns {Promise.<void>}
     */
    async setSpeedDirectionEnable(speedDirectionEnable){
        try{
            await T.setSpeedDirectionEnable(track._trackId_,speedDirectionEnable);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置时间间隔，单位为秒，时间间隔值必须大于20秒，否则设置时间间隔失败。
     * @memberOf Track
     * @param {number} timeInterval - 时间间隔。
     * @returns {Promise.<void>}
     */
    async setTimeInterval(timeInterval){
        try{
            await T.setTimeInterval(track._trackId_,timeInterval);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 开启轨迹功能。
     * @memberOf Track
     * @returns {Promise.<void>}
     */
    async startTrack(){
        try{
            await T.startTrack(track._trackId_);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 关闭轨迹功能。
     * @memberOf Track
     * @returns {Promise.<void>}
     */
    async stopTrack(){
        try{
            await T.stopTrack(track._trackId_);
        }catch (e){
            console.error(e);
        }
    }
}
