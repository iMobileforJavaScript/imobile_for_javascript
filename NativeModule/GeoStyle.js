/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
import xml2json from './utility/xml2json.min'
// let G = NativeModules.JSGeoStyle;

// import Size2D from './Size2D'

/**
 * @class GeoStyle
 * @description 几何风格类。用于定义点状符号、线状符号、填充符号及其相关设置。对于文本对象只能设置文本风格，不能设置几何风格。
 */
export default class GeoStyle {

  constructor(props) {
    // this.x2j = new xml2json()
  }

  /**
   * 设置线状符号型风格或点状符号的颜色
   * @param r
   * @param g
   * @param b
   * @param a
   */
  setLineColor(r, g, b, a = 1) {
    const rgba = (a << 24 | b << 16 | g << 8 | a * 255) & 0xff
    Object.assign(this.geoStyle, {
      lineColor: rgba,
    })
  }

  /**
   * 返回线状符号的编码。此编码用于唯一标识各线状符号。
   线状符号可以用户自定义，也可以使用系统自带的符号库。使用系统自带符号库时，其相应的的编码参见开发指南 SuperMap Objects 资源库一览。
   * @param symbolId
   */
  setLineSymbolID(symbolId) {
    Object.assign(this.geoStyle, {
      LineSymbolID: symbolId
    })
  }

  /**
   * 设置线状符号的宽度。单位为毫米，精度到0.1。
   * @param lineWidth
   */
  setLineWidth(lineWidth) {
    Object.assign(this.geoStyle, {
      LineWidth: lineWidth,
    })
  }

  /**
   * 返回点状符号的编码。此编码用于唯一标识各点状符号。
   点状符号可以用户自定义，也可以使用系统自带的符号库。使用系统自带符号库时，其相应的的编码参见开发指南 SuperMap Objects 资源库一览。
   * @param markerSymbolId
   */
  setMarkerSymbolID(markerSymbolId) {
    Object.assign(this.geoStyle, {
      MarkerSymbolID: markerSymbolId,
    })
  }

  /**
   * 设置点状符号的大小，单位为毫米，精确到0.1毫米。其值必须大于等于0。如果为0，则表示不显示，如果是小于0，会抛出异常。
   * @param size2D
   */
  setMarkerSize(size2D) {
    Object.assign(this.geoStyle, {
      MarkerSize: size2D,
    })
  }

  /**
   * 设置填充符号的前景色。
   * @param r
   * @param g
   * @param b
   * @param a
   */
  setFillForeColor(r, g, b, a = 1) {
    const rgba = (a << 24 | b << 16 | g << 8 | a * 255) & 0xff
    Object.assign(this.geoStyle, {
      FillForeColor: rgba,
    })
  }

  /**
   * 设置填充不透明度，合法值0-100的数值
   * @param rate
   */
  setFillOpaqueRate(rate) {
    Object.assign(this.geoStyle, {
      FillOpaqueRate: rate,
    })
  }

  /**
   * 设置点的颜色
   * @param r
   * @param g
   * @param b
   * @param a
   */
  setPointColor(r, g, b, a = 1) {
    const rgba = (a << 24 | b << 16 | g << 8 | a * 255) & 0xff
    Object.assign(this.geoStyle, {
      PointColor: rgba,
    })
  }

  /**
   * 获取线状符号型风格或点状符号的颜色
   * @returns {*}
   */
  getLineColor() {
    if (!this.geoStyle) {
      return null
    }
    const rgba = this.geoStyle['LineColor']
    const r = rgba & 0xff
    const g = rgba >> 8 & 0xff
    const b = rgba >> 16 & 0xff
    const a = (rgba >> 24 & 0xff) / 255
    return {
      r, g, b, a,
    }
  }

  /**
   * 返回线状符号的编码。此编码用于唯一标识各线状符号
   * @returns {*}
   */
  getLineSymbolID() {
    if (!this.geoStyle) {
      return null
    }
    return this.geoStyle['LineSymbolID']
  }

  /**
   * 获取线状符号的宽度。单位为毫米，精度到0.1
   * @returns {*}
   */
  getLineWidth() {
    if (!this.geoStyle) {
      return null
    }
    return this.geoStyle['LineWidth']
  }

  /**
   * 返回点状符号的编码。此编码用于唯一标识各点状符号
   * @returns {*}
   */
  getMarkerSymbolID() {
    if (!this.geoStyle) {
      return null
    }
    return this.geoStyle['MarkerSymbolID']
  }

  /**
   * 返回点状符号的大小，单位为毫米，精确到0.1毫米
   * @returns {*}
   */
  getMarkerSize() {
    if (!this.geoStyle) {
      return null
    }
    return this.geoStyle['MarkerSize']
  }

  /**
   * 返回填充符号的前景色
   * @returns {*}
   */
  getFillForeColor() {
    if (!this.geoStyle) {
      return null
    }
    const rgba = this.geoStyle['FillForeColor']
    const r = rgba & 0xff
    const g = rgba >> 8 & 0xff
    const b = rgba >> 16 & 0xff
    const a = (rgba >> 24 & 0xff) / 255
    return {
      r, g, b, a,
    }
  }

  /**
   * 返回填充不透明度，合法值0-100的数值
   * @returns {*}
   */
  getFillOpaqueRate() {
    if (!this.geoStyle) {
      return null
    }
    return this.geoStyle['FillOpaqueRate']
  }

  /**
   * 返回点的颜色
   * @returns {*}
   */
  getPointColor() {
    if (!this.geoStyle) {
      return null
    }
    const rgba = this.geoStyle['PointColor']
    const r = rgba & 0xff
    const g = rgba >> 8 & 0xff
    const b = rgba >> 16 & 0xff
    const a = (rgba >> 24 & 0xff) / 255
    return {
      r, g, b, a,
    }
  }
}
