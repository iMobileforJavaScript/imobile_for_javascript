/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 ref:Geometry,BufferAnalystParameter,PrjCoordSys,GeoRegion
 description:此方法ios／android 应该存在差异，待排查
 **********************************************************************************/
import {NativeModules} from 'react-native';
let BAG = NativeModules.JSBufferAnalystGeometry;
import GeoRegion from './GeoRegion.js';

/**
 * @class BufferAnalyst
 * @description 几何对象缓冲区分析类。
 **/
export default class BufferAnalystGeometry {
    
    /**
     * (静态方法)根据给定的几何对象及缓冲区分析参数对象创建缓冲区。
     * @memberOf BufferAnalystGeometry
     * @param {Geometry} geometry - 几何对象
     * @param {BufferAnalystParameter} bufferAnalystParameter - 缓冲区分析参数对象
     * @param {PrjCoordSys } prjCoordSys - 地图的投影坐标系
     * @returns {Promise.<GeoRegion>}
     */
    static async createBuffer(geometry,bufferAnalystParameter,prjCoordSys){
        try{
            var {geoRegionId} = await BAG.createBuffer(this._SMBufferAnalystGeometryId,
                geometry._SMGeometryId,bufferAnalystParameter._SMBufferAnalystParameterId,prjCoordSys._SMPrjCoordSysId);
            var geoRegion = new GeoRegion();
            geoRegion._SMGeoRegionId = geoRegionId;
//            console.log("geoRegion.geometryId:"+geoRegion.geometryId);
//            console.log("geoRegion.geoRegionId:" + geoRegion.geoRegionId);
            return geoRegion;
        }catch (e){
            console.error(e);
        }
    }
}
