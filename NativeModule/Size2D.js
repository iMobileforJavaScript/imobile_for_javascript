/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import { NativeModules } from 'react-native';
let S = NativeModules.JSSize2D;

/**
 * @class Size2D
 * @description 存储有序双精度数对。
 */
export default class Size2D {
  /**
   * 创建一个Size2D实例
   * @param {number} w - 宽度
   * @param {number} h - 高度
   * @returns {Promise.<Size2D>}
   */
  async createObj(w, h) {
    try {
      let size2DId = await S.createObj(w, h);
      let size2D = new Size2D();
      size2D._SMSize2DId = size2DId;
      return size2D;
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 返回一个新的 Size2D 对象，其宽度和高度值为大于等于指定 Size2D 对象对应值的最小整数值，例如给定 Size2D(2.3,6.8)，则生成的新的对象为 Size2D(3,7)
   * @param size2D
   * @returns {Promise.<Size2D>}
   */
  async ceiling(size2D) {
    try {
      let size2DId = await S.ceiling(size2D._SMSize2DId);
      let newSize2D = new Size2D();
      newSize2D._SMSize2DId = size2DId;
      return newSize2D;
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 返回当前 Size2D 对象的一个拷贝
   * @returns {Promise.<Size2D>}
   */
  async clone() {
    try {
      let size2DId = await S.clone(this._SMSize2DId);
      let size2D = new Size2D();
      size2D._SMSize2DId = size2DId;
      return size2D;
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 判定此 Size2D 是否与指定 Size2D 有相同的坐标
   * @param size2D
   * @returns {Promise<boolean|*>}
   */
  async ceiling(size2D) {
    try {
      return await S.equals(this._SMSize2DId, size2D._SMSize2DId);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 返回此 Size2D 的垂直分量，即高度
   * @returns {Promise}
   */
  async getHeight() {
    try {
      return await S.getHeight(this._SMSize2DId);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 返回此 Size2D 的水平分量，即宽度
   * @returns {Promise}
   */
  async getWidth() {
    try {
      return await S.getWidth(this._SMSize2DId);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 判断当前 Size2D 对象是否为空，即是否宽度和高度均为 -1.7976931348623157e+308
   * @returns {Promise.<Promise|Promise.<Promise|*|boolean>|boolean|*>}
   */
  async isEmpty() {
    try {
      return await S.isEmpty(this._SMSize2DId);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 返回一个新的 Size2D 对象，其宽度和高度值是通过对给定 Size2D 对象的对应值进行四舍五入得到，例如给定 Size2D(2.3,6.8)， 则四舍五入后的新的对象为 Size2D(2,7)
   * @returns {Promise.<Promise|Promise.<Promise|Promise.<Promise|*|boolean>|boolean|*>|Promise.<Promise|*|boolean>|boolean|*>}
   */
  async round() {
    try {
      let id = await S.round(this._SMSize2DId);
      let size2D = new Size2D()
      size2D._SMSize2DId = id
      return size2D
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 设置此 Size2D 的垂直分量，即高度
   * @param value
   * @returns {Promise.<void>}
   */
  async setHeight(value) {
    try {
      await S.setHeight(this._SMSize2DId, value);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 设置此 Size2D 的水平分量，即宽度
   * @param value
   * @returns {Promise.<void>}
   */
  async setWidth(value) {
    try {
      await S.setWidth(this._SMSize2DId, value);
    } catch (e) {
      console.log(e);
    }
  }
  
  /**
   * 返回一个此 Size2D 对象宽度和高度的格式化字符串
   * @param value
   * @returns {Promise.<string>}
   */
  async toString() {
    try {
      return await S.toString(this._SMSize2DId);
    } catch (e) {
      console.log(e);
    }
  }
}
