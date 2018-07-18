/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let X = NativeModules.JSPointM;

/**
 * 精度为 double 的路由点类。
 * 路由点是指具有线性度量值的点。M 代表路由点的度量值（Measure value）。
 */
export default class PointM {
  /**
   * 构造一个新的 PointM 对象。
   * @memberOf PointM
   * @returns {Promise.<PointM>}
   */
  async createObj() {
    try {
      let pointMId, pointM
      if (typeof arguments[0] === 'number' && typeof arguments[1] === 'number' && typeof arguments[2] === 'number') {
        pointMId = await X.createObjByXYM(arguments[0], arguments[1], arguments[2]);
        pointM = new PointM();
        pointM.SMPointMId = pointMId;
        return pointM;
      } else {
        pointMId = await X.createObj();
        pointM = new PointM();
        pointM.SMPointMId = pointMId;
        return pointM;
      }
    } catch (e) {
      console.error(e);
    }
  }
  
  
  async getX() {
    try {
      return await X.getX(this.SMPointMId);
    } catch (e) {
      console.error(e);
    }
  }
  
  async getY() {
    try {
      return await X.getY(this.SMPointMId);
    } catch (e) {
      console.error(e);
    }
  }
  
  async getM() {
    try {
      return await X.getM(this.SMPointMId);
    } catch (e) {
      console.error(e);
    }
  }
}
