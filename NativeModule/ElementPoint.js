/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let EP = NativeModules.JSElementPoint;
import CollectorElement from './CollectorElement';

/**
 * 线类型采集对象类
 */
export default class ElementPoint extends CollectorElement {
  constructor() {
    super();
    Object.defineProperty(this, "_ElementPointId", {
      get: function () {
        return this._SMCollectorElementId
      },
      set: function (_ElementPointId) {
        this._SMCollectorElementId = _ElementPointId;
      }
    })
  }
  
  /**
   * ElementPoint 对象构造方法
   * @returns {Promise.<ElementPoint>}
   */
  async createObj() {
    try {
      let id = await EP.createObj();
      let geoLine = new ElementPoint();
      geoLine._ElementPointId = id;
      return geoLine;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 通过 Geomotry 构造点类型的采集对象
   * @param geometry
   * @returns {Promise.<ElementPoint>}
   */
  async fromGeometry(geometry) {
    try {
      return await EP.fromGeometry(this._ElementPointId, geometry._SMGeometryId);
    } catch (e) {
      console.error(e);
    }
  }
  
}
