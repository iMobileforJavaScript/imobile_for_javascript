/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let GLM = NativeModules.JSGeoLineM;
import Geometry from './Geometry.js';

/**
 * @class GeoLine
 * @description 线几何对象类。
 */
export default class GeoLineM extends Geometry {
  constructor() {
    super();
    Object.defineProperty(this, "_SMGeoLineId", {
      get: function () {
        return this._SMGeometryId
      },
      set: function (_SMGeoLineId) {
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
  async createObj(points) {
    try {
      let geoLineMId
      if (!!points && typeof points == "array") {
        geoLineMId = await GLM.createObjByPts();
      } else {
        geoLineMId = await GLM.createObj();
      }
      let geoLine = new GeoLineM();
      geoLine._SMGeoLineId = geoLineMId;
      return geoLine;
    } catch (e) {
      console.error(e);
    }
  }
  
}
