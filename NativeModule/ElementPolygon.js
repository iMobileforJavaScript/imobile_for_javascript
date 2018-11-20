/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let EPL = NativeModules.JSElementPolygon;
import CollectorElement from './CollectorElement';

/**
 * 线类型采集对象类
 */
export default class ElementPolygon extends CollectorElement {
  constructor() {
    super();
    Object.defineProperty(this, "_ElementPolygonId", {
      get: function () {
        return this._SMCollectorElementId
      },
      set: function (_ElementPolygonId) {
        this._SMCollectorElementId = _ElementPolygonId;
      }
    })
  }
  
  /**
   * ElementPolygon 对象构造方法
   * @returns {Promise.<ElementPolygon>}
   */
  async createObj() {
    try {
      let id = await EPL.createObj();
      let geoLine = new ElementPolygon();
      geoLine._ElementPolygonId = id;
      return geoLine;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 通过 Geomotry 构造面类型的采集对象
   * @param geometry
   * @returns {Promise.<ElementPolygon>}
   */
  async fromGeometry(geometry) {
    try {
      return await EPL.fromGeometry(this._ElementPolygonId, geometry._SMGeometryId);
    } catch (e) {
      console.error(e);
    }
  }
  
}
