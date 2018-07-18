/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let TP = NativeModules.JSTextPart;

import Point2D from './Point2D'
/**
 * 文本子对象类。
 * 用于表示文本对象的子对象，其存储子对象的文本，旋转角度，锚点等信息并提供对子对象进行处理的相关方法。
 * 当该类的实例已被 dispose() 方法释放后，再调用该类成员的时候，则会抛出 ObjectDisposedException 异常。
 */
export default class TextPart {
  async createObj() {
    try {
      let textPartId = await TP.createObj();
      let textPart = new TextPart();
      textPart._SMTextPartId = textPartId;
      return textPart;
    } catch (e) {
      console.error(e);
    }
  }
  async createObjWithPoint2D(text, point2D) {
    try {
      let textPartId = await TP.createObjWithPoint2D(text, point2D._SMPoint2DId);
      let textPart = new TextPart();
      textPart._SMTextPartId = textPartId;
      return textPart;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 检查网络环路，返回构成环路的弧段 ID 数组
   * @returns {Promise.<Promise|*|{type}>}
   */
  async getAnchorPoint () {
    try {
      let id = await TP.getAnchorPoint(this._SMTextPartId);
      let point2D = new Point2D().createObj();
      point2D._SMPoint2DId = id;
      
      return point2D;
    } catch (e) {
      console.error(e);
    }
  }
  
  async dispose () {
    try {
      await TP.dispose(this._SMTextPartId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回此文本子对象的旋转角度
   * @returns {Promise}
   */
  async getRotation() {
    try {
      let rotation = await TP.getRotation(this._SMTextPartId);
      return rotation;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回此文本子对象的文本内容
   * @returns {Promise.<Promise|string>}
   */
  async getText() {
    try {
      let text = await TP.getText(this._SMTextPartId);
      return text
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置此文本子对象锚点的横坐标
   * @returns {Promise.<Promise|number|Promise.<Promise.number>>}
   */
  async getX() {
    try {
      let x = await TP.getX(this._SMTextPartId);
      return x
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 置此文本子对象锚点的纵坐标
   * @returns {Promise.<Promise|number|Promise.<Promise.number>>}
   */
  async getY() {
    try {
      let y = await TP.getY(this._SMTextPartId);
      return y
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置此文本子对象实例的锚点，其类型为 Point2D
   * @param point2D
   * @returns {Promise.<void>}
   */
  async setAnchorPoint(point2D) {
    try {
      await TP.setAnchorPoint(this._SMTextPartId, point2D._SMPoint2DId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置此文本子对象的旋转角度
   * @param value
   * @returns {Promise}
   */
  async setRotation(value) {
    try {
      await TP.setRotation(this._SMTextPartId, value);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置此文本子对象的文本内容
   * @param value
   * @returns {Promise.<void>}
   */
  async setText(value) {
    try {
      await TP.setText(this._SMTextPartId, value);
    } catch (e) {
      console.error(e);
    }
  }
}
