/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let GL = NativeModules.JSGeoLine;
import Geometry from './Geometry.js';

/**
 * @class GeoLine
 * @description 线几何对象类。
 */
export default class GeoLine extends Geometry{
    constructor(){
        super();
        Object.defineProperty(this,"_SMGeoLineId",{
            get:function () {
                return this._SMGeometryId
            },
            set:function (_SMGeoLineId) {
                this._SMGeometryId = _SMGeoLineId;
            }
        })
    }

    /**
     * GeoLine 对象构造方法
     * @memberOf GeoLine
     * @param {Array} points -点信息数组，eg: [ {x:1.1,y:1.2} , {x:2.3,y:3.4} ]
     * @returns {Promise.<GeoLine>}
     */
    async createObj(points){
        try{
            if(!!points && typeof points == "array"){
                var {geoLineId} = await GL.createObjByPts();
            }else{
                var {geoLineId} = await GL.createObj();
            }
            geoLine = new GeoLine();
            geoLine._SMGeoLineId = geoLineId;
            return geoLine;
        }catch (e){
            console.error(e);
        }
    }

}
