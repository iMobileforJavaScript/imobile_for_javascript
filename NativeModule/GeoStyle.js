/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
/**
 * @class GeoStyle
 * @description 几何风格类。用于定义点状符号、线状符号、填充符号及其相关设置。对于文本对象只能设置文本风格，不能设置几何风格。
 */
export default class GeoStyle {

  /**
   * 设置线状符号型风格或点状符号的颜色
   * @param r
   * @param g
   * @param b
   * @param a
   */
  setLineColor(r, g, b, a = 1) {
    const rgba = (a * 255) << 24 | b << 16 | g << 8 | r
    // Object.assign(this.geoStyle, {
    //   LineColor: rgba,
    // })
    this.LineColor = rgba
  }

  /**
   * 返回线状符号的编码。此编码用于唯一标识各线状符号。
   线状符号可以用户自定义，也可以使用系统自带的符号库。使用系统自带符号库时，其相应的的编码参见开发指南 SuperMap Objects 资源库一览。
   * @param symbolId
   */
  setLineStyle(symbolId) {
    // Object.assign(this.geoStyle, {
    //   LineStyle: symbolId
    // })
    this.LineStyle = symbolId
  }

  /**
   * 设置线状符号的宽度。单位为毫米，精度到0.1。
   * @param lineWidth
   */
  setLineWidth(lineWidth) {
    // Object.assign(this.geoStyle, {
    //   LineWidth: lineWidth,
    // })
    this.LineWidth = lineWidth
  }

  /**
   * 返回点状符号的编码。此编码用于唯一标识各点状符号。
   点状符号可以用户自定义，也可以使用系统自带的符号库。使用系统自带符号库时，其相应的的编码参见开发指南 SuperMap Objects 资源库一览。
   * @param markerSymbolId
   */
  setMarkerStyle(markerSymbolId) {
    // Object.assign(this.geoStyle, {
    //   MarkerStyle: markerSymbolId,
    // })
    this.MarkerStyle = markerSymbolId
  }

  /**
   * 设置点状符号的大小，单位为毫米，精确到0.1毫米。其值必须大于等于0。如果为0，则表示不显示，如果是小于0，会抛出异常。
   * @param size2D
   */
  setMarkerSize(size2D) {
    // Object.assign(this.geoStyle, {
    //   MarkerSize: size2D,
    // })
    this.MarkerSize = size2D
  }

  /**
   * 设置填充符号ID
   * @param id
   */
  setFillStyle(id) {
    // Object.assign(this.geoStyle, {
    //   FillStyle: id,
    // })
    this.FillStyle = id
  }

  /**
   * 设置填充符号的前景色。
   * @param r
   * @param g
   * @param b
   * @param a
   */
  setFillForeColor(r, g, b, a = 1) {
    const rgba = (a * 255) << 24 | b << 16 | g << 8 | r
    // Object.assign(this.geoStyle, {
    //   FillForeColor: rgba,
    // })
    this.FillForeColor = rgba
  }

  /**
   * 设置填充不透明度，合法值0-100的数值
   * @param rate
   */
  setFillOpaqueRate(rate) {
    // Object.assign(this.geoStyle, {
    //   FillOpaqueRate: rate,
    // })
    this.FillOpaqueRate = rate
  }

  /**
   * 设置点的颜色
   * @param r
   * @param g
   * @param b
   * @param a
   */
  setPointColor(r, g, b, a = 1) {
    const rgba = (a * 255) << 24 | b << 16 | g << 8 | r
    // Object.assign(this.geoStyle, {
    //   PointColor: rgba,
    // })
    this.PointColor = rgba
  }

  /**
   * 获取线状符号型风格或点状符号的颜色
   * @returns {*}
   */
  getLineColor() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // const rgba = this.geoStyle['LineColor']
    if (!this.LineColor) return null
    const rgba = this.LineColor
    const r = rgba & 0xff
    const g = (rgba >> 8) & 0xff
    const b = (rgba >> 16) & 0xff
    const a = ((rgba >> 24) & 0xff) / 255
    return {
      r, g, b, a,
    }
  }

  /**
   * 返回线状符号的编码。此编码用于唯一标识各线状符号
   * @returns {*}
   */
  getLineStyle() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // return this.geoStyle['LineStyle']
    if (!this.LineStyle) {
      return null
    }
    return this.LineStyle
  }

  /**
   * 获取线状符号的宽度。单位为毫米，精度到0.1
   * @returns {*}
   */
  getLineWidth() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // return this.geoStyle['LineWidth']
    if (!this.LineWidth) {
      return null
    }
    return this.LineWidth
  }

  /**
   * 返回点状符号的编码。此编码用于唯一标识各点状符号
   * @returns {*}
   */
  getMarkerStyle() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // return this.geoStyle['MarkerStyle']
    if (!this.MarkerStyle) {
      return null
    }
    return this.MarkerStyle
  }

  /**
   * 返回点状符号的大小，单位为毫米，精确到0.1毫米
   * @returns {*}
   */
  getMarkerSize() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // return this.geoStyle['MarkerSize']
    if (!this.MarkerSize) {
      return null
    }
    return this.MarkerSize
  }

  /**
   * 返回填充符号的编码。此编码用于唯一标识各点状符号
   * @returns {*}
   */
  getFillStyle() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // return this.geoStyle['FillStyle']
    if (!this.FillStyle) {
      return null
    }
    return this.FillStyle
  }

  /**
   * 返回填充符号的前景色
   * @returns {*}
   */
  getFillForeColor() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // const rgba = this.geoStyle['FillForeColor']
    if (!this.FillForeColor) {
      return null
    }
    const rgba = this.FillForeColor
    const r = rgba & 0xff
    const g = (rgba >> 8) & 0xff
    const b = (rgba >> 16) & 0xff
    const a = ((rgba >> 24) & 0xff) / 255
    return {
      r, g, b, a,
    }
  }

  /**
   * 返回填充不透明度，合法值0-100的数值
   * @returns {*}
   */
  getFillOpaqueRate() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // return this.geoStyle['FillOpaqueRate']
    if (!this.FillOpaqueRate) {
      return null
    }
    return this.FillOpaqueRate
  }

  /**
   * 返回点的颜色
   * @returns {*}
   */
  getPointColor() {
    // if (!this.geoStyle) {
    //   return null
    // }
    // const rgba = this.geoStyle['PointColor']
    if (!this.PointColor) {
      return null
    }
    const rgba = this.PointColor
    const r = rgba & 0xff
    const g = (rgba >> 8) & 0xff
    const b = (rgba >> 16) & 0xff
    const a = ((rgba >> 24) & 0xff) / 255
    return {
      r, g, b, a,
    }
  }
}
