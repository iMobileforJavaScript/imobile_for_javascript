/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let CST = NativeModules.JSCoordSysTranslator;

/**
 * 投影转换类。
 * 主要用于投影坐标之间及投影坐标系之间的转换。
 */
export default class CoordSysTranslator {
  /**
   * 根据源投影坐标系与目标投影坐标系对几何对象进行投影转换，结果将直接改变源几何对象
   * @param geometry
   * @param sourcePrjCoordSys
   * @param targetPrjCoordSys
   * @param coordSysTransParameter
   * @param coordSysTransMethod
   * @returns {Promise.<Promise|Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>>}
   */
  static async convertByGeometry (geometry, sourcePrjCoordSys, targetPrjCoordSys, coordSysTransParameter, coordSysTransMethod) {
    try {
      return await CST.convertByGeometry(geometry._SMGeometryId, sourcePrjCoordSys._SMPrjCoordSysId,
        targetPrjCoordSys._SMPrjCoordSysId, coordSysTransParameter._SMCoordSysTransParameterId,
        coordSysTransMethod);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
   * @param point2DIds
   * @param sourcePrjCoordSys
   * @param targetPrjCoordSys
   * @param coordSysTransParameter
   * @param coordSysTransMethod
   * @returns {Promise}
   */
  static async convertByPoint2Ds(point2DIds = [], sourcePrjCoordSys, targetPrjCoordSys, coordSysTransParameter, coordSysTransMethod) {
    try {
      let arr = []
      point2DIds.forEach(obj => {
        arr.push(obj._SMPoint2DId)
      })
      return await CST.convertByPoint2Ds(arr, sourcePrjCoordSys._SMPrjCoordSysId,
        targetPrjCoordSys._SMPrjCoordSysId, coordSysTransParameter._SMCoordSysTransParameterId,
        coordSysTransMethod);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据源投影坐标系与目标投影坐标系对三维点集合对象进行投影转换，结果将直接改变源坐标点串
   * @param point3DIds
   * @param sourcePrjCoordSys
   * @param targetPrjCoordSys
   * @param coordSysTransParameter
   * @param coordSysTransMethod
   * @returns {Promise}
   */
  static async convertByPoint3Ds(point3DIds = [], sourcePrjCoordSys, targetPrjCoordSys, coordSysTransParameter, coordSysTransMethod) {
    try {
      let arr = []
      point3DIds.forEach(obj => {
        arr.push(obj._SMPoint3DId)
      })
      return await CST.convertByPoint3Ds(arr, sourcePrjCoordSys._SMPrjCoordSysId,
        targetPrjCoordSys._SMPrjCoordSysId, coordSysTransParameter._SMCoordSysTransParameterId,
        coordSysTransMethod);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在同一地理坐标系下，该方法用于将指定的Point2Ds 类的点对象的地理坐标转换到投影坐标
   * @param point2DIds
   * @param sourcePrjCoordSys
   * @returns {Promise.<Promise|*|void>}
   */
  static async forward(point2DIds = [], sourcePrjCoordSys) {
    try {
      let arr = []
      point2DIds.forEach(obj => {
        arr.push(obj._SMPoint2DId)
      })
      return await CST.forward(arr, sourcePrjCoordSys._SMPrjCoordSysId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在同一投影坐标系下，该方法用于将指定的Point2Ds 类的点对象的投影坐标转换到地理坐标
   * @param point2DIds
   * @param sourcePrjCoordSys
   * @returns {Promise.<Promise|*|Array.<number>>}
   */
  static async inverse(point2DIds = [], sourcePrjCoordSys) {
    try {
      let arr = []
      point2DIds.forEach(obj => {
        arr.push(obj._SMPoint2DId)
      })
      return await CST.inverse(arr, sourcePrjCoordSys._SMPrjCoordSysId);
    } catch (e) {
      console.error(e);
    }
  }
  
}
