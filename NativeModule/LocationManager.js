/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules,DeviceEventEmitter} from 'react-native';
let LM = NativeModules.JSLocationManager;

/**
 * @class LocationManager
 * @description 位置管理插件，目前仅支持从GPS设备中获取当前位置。
 */
export default class LocationManager {
    
    /**
     * 创建一个LocationManager实例
     * @memberOf LocationManager
     * @returns {Promise.<LocationManager>}
     */
    async createObj(){
        try{
            var {_locationManagePluginId_} = await LM.createObj();
            var loactionManager = new LocationManager();
            loactionManager._SMLocationManagerId = _locationManagePluginId_;
            return loactionManager;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 开启GPS设备。
     * @memberOf LocationManager
     * @returns {Promise.<void>}
     */
    async openGpsDevice(){
        try{
            await LM.openGpsDevice(this._SMLocationManagerId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 关闭GPS设备。
     * @memberOf LocationManager
     * @returns {Promise.<void>}
     */
    async closeGpsDevice(){
        try{
            await LM.closeGpsDevice(this._SMLocationManagerId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 监听定位信息，获取定位数据
     * @memberOf LocationManager
     * @param {function}_callback - 位置信息变化处理函数，回调参数保存e:{"oldGps":object,"newGps":object,isGPSPointValid:boolean}
     * @description Gps对象数据（oldGps,newGps):{dAltitude:double,dBearing:double,dLatitude:double,dLongitude:double,dSpeed:double,lTime:string,nDay:number,nEasting:number,nFixMode:number,nHour:number,nMinute:number,nNorthing:number,nQualityIndicator:number,nSatellites:number,nSecond:number,nYear:number}
     * @returns {Promise.<void>}
     */
    async getLocationInfo(_callback){
        try{
            DeviceEventEmitter.addListener("com.supermap.RN.JSLocationManager.location_changed_event",function (e) {
                if(typeof _callback == "function"){
                    console.log("locationManager");
                    _callback(e);
                }else{
                    console.error("Please set a callback in the first argument.");
                }
            });
            await LM.getLocationInfo(this._SMLocationManagerId);
        }catch (e){
            console.error(e);
        }
    }
}
