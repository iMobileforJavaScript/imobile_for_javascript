/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let EL = NativeModules.JSElementLine;
import CollectorElement from './CollectorElement';

/**
 * 线类型采集对象类
 */
export default class ElementLine extends CollectorElement {
  constructor() {
    super();
    Object.defineProperty(this, "_ElementLineId", {
      get: function () {
        return this._SMCollectorElementId
      },
      set: function (_ElementLineId) {
        this._SMCollectorElementId = _ElementLineId;
      }
    })
  }
  
  /**
   * ElementLine 对象构造方法
   * @returns {Promise.<ElementLine>}
   */
  async createObj() {
    try {
      let id = await EL.createObj();
      let geoLine = new ElementLine();
      geoLine._ElementLineId = id;
      return geoLine;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 通过 Geomotry 构造线类型的采集对象
   * @param geometry
   * @returns {Promise.<ElementLine>}
   */
  async fromGeometry(geometry) {
    try {
      return await EL.fromGeometry(this._ElementLineId, geometry._SMGeometryId);
    } catch (e) {
      console.error(e);
    }
  }
  
}
