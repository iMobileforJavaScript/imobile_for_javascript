/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let GT = NativeModules.JSGeoText;

import TextPart from './TextPart'
import TextStyle from './TextStyle'
/**
 * 文本类，派生于 Geometry 类。
 * 该类主要用于对地物要素进行标识和必要的注记说明。
 * 文本对象由一个或多个部分组成，每个部分称为文本对象的一个子对象，每个子对象都是一个 TextPart 的实例。
 * 同一个文本对象的所有子对象都使用相同的文本风格，即使用该文本对象的文本风格进行显示。
 */
export default class GeoText {
  async createObj() {
    try {
      let geoTextId = await GT.createObj();
      let geoText = new GeoText();
      geoText._SMGeoTextId = geoTextId;
      return geoText;
    } catch (e) {
      console.error(e);
    }
  }
  
  async createObjWithTextPart(textPart) {
    try {
      let geoTextId = await GT.createObjWithTextPart(textPart._SMTextPartId);
      let geoText = new GeoText();
      geoText._SMGeoTextId = geoTextId;
      return geoText;
    } catch (e) {
      console.error(e);
    }
  }
  
  async dispose () {
    try {
      await GT.dispose(this._SMGeoTextId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在文本对象中添加文本子对象
   * @param textPartId
   * @returns {Promise.<void>}
   */
  async addPart(textPartId) {
    try {
      await GT.addPart(this._SMGeoTextId, textPartId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回此文本对象的指定序号的子对象
   * @returns {Promise}
   */
  async getPart(index) {
    try {
      let textPartId = await GT.getRotation(this._SMGeoTextId, index);
      let textPart = new TextPart();
      textPart._SMTextPartId = textPartId
      return textPart;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本对象的子对象个数
   * @returns {Promise.<Promise|string>}
   */
  async getPartCount() {
    try {
      let count = await GT.getPartCount(this._SMGeoTextId);
      return count
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本对象的内容
   * @returns {Promise.<Promise|Promise.<Promise|string>|string>}
   */
  async getText() {
    try {
      let text = await GT.getText(this._SMGeoTextId);
      return text;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回文本对象的文本风格
   * @returns {Promise.<TextStyle>}
   */
  async getTextStyle() {
    try {
      let textStyleId = await GT.getTextStyle(this._SMGeoTextId);
      let textStyle = new TextStyle();
      textStyle._SMTextStyleId = textStyleId;
      return textStyle;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在此文本对象的指定位置插入一个文本子对象
   * @param index
   * @param textPartId
   * @returns {Promise.<void>}
   */
  async insertPart(index, textPart) {
    try {
      await GT.insertPart(this._SMGeoTextId, index, textPart._SMPoint2DId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 判定该文本对象是否为空，即其子对象的个数是否为0
   * @returns {Promise.<Promise|*|boolean>}
   */
  async isEmpty() {
    try {
      let isEmpty = await GT.isEmpty(this._SMGeoTextId);
      return isEmpty;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 删除此文本对象的指定序号的文本子对象
   * @param index
   * @returns {Promise.<void>}
   */
  async removePart(index) {
    try {
      await GT.removePart(this._SMGeoTextId, index);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 修改此文本对象的指定序号的子对象，即用新的文本子对象来替换原来的文本子对象
   * @param index
   * @param textPart
   * @returns {Promise.<void>}
   */
  async setPart(index, textPart) {
    try {
      await GT.setPart(this._SMGeoTextId, index, textPart._SMPoint2DId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置文本对象的文本风格
   * @param textStyle
   * @returns {Promise.<void>}
   */
  async setTextStyle(textStyle) {
    try {
      await GT.setTextStyle(this._SMGeoTextId, textStyle._SMPoint2DId);
    } catch (e) {
      console.error(e);
    }
  }
}
