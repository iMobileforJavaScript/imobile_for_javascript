/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 ref:Size2d
 **********************************************************************************/
import { NativeModules } from 'react-native';
let G = NativeModules.JSGeoStyle;

import Size2D from './Size2D'

/**
 * @class GeoStyle
 * @description 几何风格类。用于定义点状符号、线状符号、填充符号及其相关设置。对于文本对象只能设置文本风格，不能设置几何风格。
 */
export default class GeoStyle {
  /**
   * 构造一个新的 GeoStyle 对象。
   * @memberOf GeoStyle
   * @returns {Promise.<GeoStyle>}
   */
  async createObj() {
    var { geoStyleId } = await G.createObj();
    var geoStyle = new GeoStyle();
    geoStyle._SMGeoStyleId = geoStyleId;
    return geoStyle;
  }
  
  catch(e) {
    console.log(e);
  }
  
  /**
   * 设置线状符号型风格或点状符号的颜色。
   * @memberOf GeoStyle
   * @param {number} r - rgb颜色的red值
   * @param {number} g - rgb颜色的green值
   * @param {number} b - rgb颜色的blue值
   * @returns {Promise.<void>}
   */
  async setLineColor(r, g, b) {
    try {
      await G.setLineColor(this._SMGeoStyleId, r, g, b);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回线状符号的编码。此编码用于唯一标识各线状符号。
   线状符号可以用户自定义，也可以使用系统自带的符号库。使用系统自带符号库时，其相应的的编码参见开发指南 SuperMap Objects 资源库一览。
   * @memberOf GeoStyle
   * @param {number} symbolId  - 一个用来设置线型符号的编码的整数值。
   * @returns {Promise.<void>}
   */
  async setLineSymbolID(symbolId) {
    try {
      await G.setLineSymbolID(this._SMGeoStyleId, symbolId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置线状符号的宽度。单位为毫米，精度到0.1。
   * @memberOf GeoStyle
   * @param {number} lineWidth - 用来设置线状符号的宽度。
   * @returns {Promise.<void>}
   */
  async setLineWidth(lineWidth) {
    try {
      await G.setLineWidth(this._SMGeoStyleId, lineWidth);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回点状符号的编码。此编码用于唯一标识各点状符号。
   点状符号可以用户自定义，也可以使用系统自带的符号库。使用系统自带符号库时，其相应的的编码参见开发指南 SuperMap Objects 资源库一览。
   * @memberOf GeoStyle
   * @param {number} markerSymbolId - 点状符号的编码。
   * @returns {Promise.<void>}
   */
  async setMarkerSymbolID(markerSymbolId) {
    try {
      await G.setMarkerSymbolID(this._SMGeoStyleId, markerSymbolId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置点状符号的大小，单位为毫米，精确到0.1毫米。其值必须大于等于0。如果为0，则表示不显示，如果是小于0，会抛出异常。
   * @memberOf GeoStyle
   * @param {number} size2D - 用来设置点状符号的大小的值。
   * @returns {Promise.<void>}
   */
  async setMarkerSize(size2D) {
    try {
      await G.setMarkerSize(this._SMGeoStyleId, size2D._SMSize2DId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   *设置填充符号的前景色。
   * @memberOf GeoStyle
   * @param {number} r - rgb颜色的red值
   * @param {number} g - rgb颜色的green值
   * @param {number} b - rgb颜色的blue值
   * @returns {Promise.<void>}
   */
  async setFillForeColor(r, g, b) {
    try {
      await G.setFillForeColor(this._SMGeoStyleId, r, g, b);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置填充不透明度，合法值0-100的数值。
   * @memberOf GeoStyle
   * @param {number} rate - 透明度比例
   * @returns {Promise.<void>}
   */
  async setFillOpaqueRate(rate) {
    try {
      await G.setFillOpaqueRate(this._SMGeoStyleId, rate)
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取线状符号型风格或点状符号的颜色
   * @returns {Promise}
   */
  async getLineColor() {
    try {
      return await G.getLineColor(this._SMGeoStyleId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回线状符号的编码。此编码用于唯一标识各线状符号
   * @returns {Promise.<void>}
   */
  async getLineSymbolID() {
    try {
      return await G.setLineSymbolID(this._SMGeoStyleId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取线状符号的宽度。单位为毫米，精度到0.1
   * @returns {Promise.<void>}
   */
  async getLineWidth() {
    try {
      return await G.getLineWidth(this._SMGeoStyleId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回点状符号的编码。此编码用于唯一标识各点状符号
   * @returns {Promise}
   */
  async getMarkerSymbolID() {
    try {
      return await G.getMarkerSymbolID(this._SMGeoStyleId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回点状符号的大小，单位为毫米，精确到0.1毫米
   * @returns {Promise.<Size2D>}
   */
  async getMarkerSize() {
    try {
      let id = await G.getMarkerSize(this._SMGeoStyleId);
      let size2D = await new Size2D()
      size2D._SMSize2DId = id
      return size2D
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回填充符号的前景色
   * @returns {Promise}
   */
  async getFillForeColor() {
    try {
      return await G.getFillForeColor(this._SMGeoStyleId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回填充不透明度，合法值0-100的数值
   * @returns {Promise.<void>}
   */
  async getFillOpaqueRate() {
    try {
      return await G.getFillOpaqueRate(this._SMGeoStyleId)
    } catch (e) {
      console.error(e);
    }
  }
}
