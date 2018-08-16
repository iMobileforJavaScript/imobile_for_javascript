import { NativeModules } from 'react-native';
let G = NativeModules.JSGeometry;
import Point2D from './Point2D.js';

/**
 * @class Geometry
 * @description 所有具体几何类型（GeoPoint, GeoLine, GeoRegion 等）的基类，提供了基本的几何类型的方法。
 该类用于表示地理实体的空间特征，并提供相关的处理方法。根据地理实体的空间特征不同，分别用点（GeoPoint），线(GeoLine)，面(GeoRegion)等加以描述。当该类的子类的对象实例被 dispose 后，再调用该类的方法会抛出 ObjectDisposedException。
 用户自己创建的 Geometry 对象，例如 GeoPoint、GeoLine、GeoRegion 等对象，在执行完系列操作后，需要对其进行释放。
 */
export default class Geometry {
  /**
   * 返回几何对象的内点。
   * @memberOf Geometry
   * @returns {Promise.<Point2D>}
   */
  async getInnerPoint() {
    try {
      let { point2DId } = await G.getInnerPoint(this._SMGeometryId);
      let point2D = new Point2D();
      point2D._SMPoint2DId = point2DId;
      return point2D;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置几何对象的风格。几何风格是用于定义几何对象在显示时的符号、线型、填充模式等信息。
   * @memberOf Geometry
   * @param {object} geoStyle - 用来设置几何对象风格的 GeoStyle 对象。
   * @returns {Promise.<void>}
   */
  async setStyle(geoStyle) {
    try {
      let id = this._SMGeometryId || this._SMGeoPointId;
      await G.setStyle(id, geoStyle._SMGeoStyleId);
    } catch (e) {
      console.error(e);
    }
  }
  
  async getID() {
    try {
      let id = this._SMGeometryId || this._SMGeoPointId;
      return await G.getID(id);
    } catch (e) {
      console.error(e);
    }
  }
  
  async getType() {
    try {
      let id = this._SMGeometryId || this._SMGeoPointId;
      await G.getType(id);
    } catch (e) {
      console.error(e);
    }
  }
}
