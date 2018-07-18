/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let TS = NativeModules.JSTextStyle;


/**
 * 文本风格类。
 * 用于设置 GeoText 类对象的风格。当文本风格对象实例使用 dispose() 方法释放后再调用该对象成员，将抛出 ObjectDisposedException 异常。
 */
export default class TextStyle {
  async createObj() {
    try {
      let textStyleId = await TS.createObj();
      let textStyle = new TextStyle();
      textStyle._SMTextStyleId = textStyleId;
      return textStyle;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回当前 TextStyle 对象的一个拷贝
   * @returns {Promise.<TextStyle>}
   */
  async clone () {
    try {
      let id = await TS.clone(this._SMTextStyleId);
      let newTextStyle = new TextStyle();
      newTextStyle._SMTextStyleId = id;
      
      return newTextStyle;
    } catch (e) {
      console.error(e);
    }
  }
  
  async dispose () {
    try {
      await TS.dispose(this._SMTextStyleId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 将指定的几何对象绘制成图片
   * @returns {Promise.<void>}
   */
  async drawToPNG() {
    try {
      // TODO 待做
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本的对齐方式
   * @returns {Promise}
   */
  async getAlignment() {
    try {
      let textAlignment = await TS.getAlignment(this._SMTextStyleId);
      return textAlignment
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本的背景色
   * @returns {Promise.<{r: Promise.r, g: Promise.g, b: Promise.b, a: Promise.a}>}
   */
  async getBackColor() {
    try {
      let { r, g, b, a } = await TS.getBackColor(this._SMTextStyleId);
      return { r, g, b, a }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取背景半透明度
   * @returns {Promise}
   */
  async getBackTransparency() {
    try {
      let backTransparency = await TS.getBackTransparency(this._SMTextStyleId);
      return backTransparency
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本字体的高度
   * @returns {Promise}
   */
  async getFontHeight() {
    try {
      let fontHeight = await TS.getFontHeight(this._SMTextStyleId);
      return fontHeight
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本字体的名称
   * @returns {Promise}
   */
  async getFontName() {
    try {
      let name = await TS.getFontName(this._SMTextStyleId);
      return name
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取注记字体的缩放比例
   * @returns {Promise.<Promise|number|*>}
   */
  async getFontScale() {
    try {
      let scale = await TS.getFontScale(this._SMTextStyleId);
      return scale
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本的宽度
   * @returns {Promise}
   */
  async getFontWidth() {
    try {
      let width = await TS.getFontWidth(this._SMTextStyleId);
      return width
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本的前景色
   * @returns {Promise.<{r: Promise.r, g: Promise.g, b: Promise.b, a: Promise.a}>}
   */
  async getForeColor() {
    try {
      let { r, g, b, a } = await TS.getForeColor(this._SMTextStyleId);
      return { r, g, b, a }
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本是否采用斜体，true 表示采用斜体
   * @returns {Promise}
   */
  async getItalic() {
    try {
      let isItalic = await TS.getItalic(this._SMTextStyleId);
      return isItalic
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回字体倾斜角度，正负度之间，以度为单位，精确到0.1度
   * @returns {Promise.<{coast: Promise.coast, edges: Promise.edges, nodes: Promise.nodes}>}
   */
  async getItalicAngle() {
    try {
      let italicAngle = await TS.findPathFromEdges(this._SMTextStyleId);
      return italicAngle
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回是否以轮廓的方式来显示文本的背景
   * @returns {Promise}
   */
  async getOutline() {
    try {
      let isOutline= await TS.getOutline(this._SMTextStyleId);
      return isOutline
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本旋转的角度
   * @returns {Promise}
   */
  async getRotation() {
    try {
      let rotation = await TS.getRotation(this._SMTextStyleId);
      return rotation
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本是否有阴影
   * @returns {Promise}
   */
  async getShadow() {
    try {
      let hasShadow = await TS.getShadow(this._SMTextStyleId);
      return hasShadow
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本字体是否加删除线
   * @returns {Promise}
   */
  async getStrikeout() {
    try {
      let strikeout = await TS.getStrikeout(this._SMTextStyleId);
      return strikeout
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本字体是否加下划线
   * @returns {Promise}
   */
  async getUnderline() {
    try {
      let underline = await TS.getUnderline(this._SMTextStyleId);
      return underline
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本字体的磅数，表示粗体的具体数值
   * @returns {Promise}
   * @deprecated
   */
  async getWeight() {
    try {
      let value = await TS.getWeight(this._SMTextStyleId);
      return value
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回注记背景是否透明
   * @returns {Promise}
   */
  async isBackOpaque() {
    try {
      let value = await TS.isBackOpaque(this._SMTextStyleId);
      return value
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回注记是否为粗体字
   * @returns {Promise}
   */
  async isBold() {
    try {
      let isBold = await TS.isBold(this._SMTextStyleId);
      return isBold
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本大小是否固定
   * @returns {Promise}
   */
  async isSizeFixed() {
    try {
      let isSizeFixed = await TS.isSizeFixed(this._SMTextStyleId);
      return isSizeFixed
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本大小是否固定
   * @param textAlignment
   * @returns {Promise.<void>}
   */
  async setAlignment(textAlignment) {
    try {
      await TS.setAlignment(this._SMTextStyleId, textAlignment);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本的背景色
   * @param r
   * @param g
   * @param b
   * @param a
   * @returns {Promise.<void>}
   */
  async setBackColor(r, g, b, a = 1) {
    try {
      await TS.setBackColor(this._SMTextStyleId, r, g, b, a);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本背景是否不透明，true 表示文本背景不透明
   * @param value
   * @returns {Promise.<void>}
   */
  async setBackOpaque(value) {
    try {
      await TS.setBackOpaque(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置背景透明度
   * @param value
   * @returns {Promise}
   */
  async setBackTransparency(value) {
    try {
      await TS.setBackTransparency(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本是否为粗体字，true 表示为粗
   * @param value
   * @returns {Promise.<void>}
   */
  async setBold(value) {
    try {
      await TS.setBold(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本字体的高度
   * @param value
   * @returns {Promise.<void>}
   */
  async setFontHeight(value) {
    try {
      await TS.setFontHeight(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本字体的名称
   * @param value
   * @returns {Promise}
   */
  async setFontName(value) {
    try {
      await TS.setFontName(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置注记字体的缩放比例
   * @param value
   * @returns {Promise}
   */
  async setFontScale(value) {
    try {
      await TS.setFontScale(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本的宽度
   * @param value
   * @returns {Promise}
   */
  async setFontWidth(value) {
    try {
      await TS.setFontWidth(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本的前景色
   * @param r
   * @param g
   * @param b
   * @param a
   * @returns {Promise.<void>}
   */
  async setForeColor(r, g, b, a = 1) {
    try {
      await TS.setForeColor(this._SMTextStyleId, r, g, b, a);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本是否采用斜体，true 表示采用斜体
   * @param value
   * @returns {Promise}
   */
  async setItalic(value) {
    try {
      await TS.setItalic(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置字体倾斜角度，正负度之间，以度为单位，精确到0.1度
   * @param value
   * @returns {Promise}
   */
  async setItalicAngle(value) {
    try {
      await TS.setItalicAngle(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置是否以轮廓的方式来显示文本的背景
   * @param value
   * @returns {Promise}
   */
  async setOutline(value) {
    try {
      await TS.setOutline(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本旋转的角度
   * @param value
   * @returns {Promise}
   */
  async setRotation(value) {
    try {
      await TS.setRotation(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置背景透明度
   * @param value
   * @returns {Promise}
   */
  async setBackTransparency(value) {
    try {
      await TS.setBackTransparency(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本是否有阴影
   * @param value
   * @returns {Promise}
   */
  async setShadow(value) {
    try {
      await TS.setShadow(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本大小是否固定
   * @param value
   * @returns {Promise}
   */
  async setSizeFixed(value) {
    try {
      await TS.setSizeFixed(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本字体是否加删除线
   * @param value
   * @returns {Promise}
   */
  async setStrikeout(value) {
    try {
      await TS.setStrikeout(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本字体是否加下划线
   * @param value
   * @returns {Promise}
   */
  async setUnderline(value) {
    try {
      await TS.setUnderline(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本字体的磅数，表示粗体的具体数值
   * @param value
   * @returns {Promise}
   * @deprecated
   */
  async setWeight(value) {
    try {
      await TS.setWeight(this._SMTextStyleId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回一个表示此文本风格类对象的格式化字符串
   * @returns {Promise.<string>}
   */
  async toString() {
    try {
      let value = await TS.toString(this._SMTextStyleId, value);
      return value
    } catch (e) {
      console.error(e);
    }
  }
  
}
