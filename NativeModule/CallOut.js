/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:N/A
 
 **********************************************************************************/
import { NativeModules } from 'react-native';
let C = NativeModules.JSCallOut;

const STARTPOINT = './resource/startpoint.png'
const DESTPOINT = './resource/destpoint.png'

/**
 * @class Callout
 * @description 点标注类,最多支持500条记录的显示。
 * @property {number} TYPE(NONE) - 无对齐方式。
 * @property {number} TYPE(LEFT) - 左对齐。
 * @property {number} TYPE(TOP) - 上对齐。
 * @property {number} TYPE(RIGHT) - 右对齐。
 * @property {number} TYPE(BOTTOM) - 下对齐。
 * @property {number} TYPE(CENTER) - 中心对齐。
 * @property {number} TYPE(LEFTTOP) - 左上对齐。
 * @property {number} TYPE(RIGHTTOP) - 右上对齐。
 * @property {number} TYPE(LEFTBOTTOM) - 左下对齐。
 * @property {number} TYPE(RIGHTBOTTOM) - 右下对齐。
 */
export default class CallOut {
  /**
   * 创建Callout对象
   * @memberOf CallOut
   * @param {object} mapControl
   * @returns {Promise.<CallOut>}
   */
  // async createObj(mapCtrl, colorArr, alignment) {
  async createObj(mapView, colorArr, alignment) {
    try {
      if (arguments.length === 1) {
        // var { callOutId } = await C.createObj(mapCtrl._SMMapControlId);
        var { callOutId } = await C.createObj(mapView._SMMapViewId);
      } else if (arguments.length === 3) {
        // var { callOutId } = await C.createObjWithStyle(mapCtrl._SMMapControlId, colorArr, alignment);
        var { callOutId } = await C.createObjWithStyle(mapView._SMMapViewId, colorArr, alignment);
      } else {
        throw new Error('input param number should be 1 or 3,please check your params');
      }
      var callout = new CallOut();
      callout._SMCalloutId = callOutId;
      return callout;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在指定位置显示Callout
   * @memberOf CallOut
   * @param {object} point2D
   * @returns {Promise.<boolean>}
   */
  async showAtPoint2d(point2D) {
    try {
      await C.showAtPoint2d(this._SMCalloutId, point2D.point2DId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 在指定位置显示Callout
   * @memberOf CallOut
   * @param {number} x
   * @param {number} y
   * @returns {Promise.<boolean>}
   */
    async showAtXY(x, y) {
    try {
      await C.showAtXY(this._SMCalloutId, x, y);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 更新Callout标注位置
   * @memberOf CallOut
   * @param {object} point2D
   * @returns {Promise.<boolean>}
   */
  async updataPoint2d(point2D) {
    try {
      await C.updataByPoint2d(this._SMCalloutId, point2D.point2DId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 更新Callout标注位置
   * @memberOf CallOut
   * @param {number} x
   * @param {number} y
   * @returns {Promise.<boolean>}
   */
  async updataXY(x, y) {
    try {
      await C.updataByXY(this._SMCalloutId, x, y);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置Callout高度
   * @memberOf CallOut
   * @param {number} height
   * @returns {Promise.<void>}
   */
  async setHeight(height) {
    try {
      await C.setHeight(this._SMCalloutId, height);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置Callout宽度
   * @memberOf CallOut
   * @param {number} width
   * @returns {Promise.<void>}
   */
  async setWidth(width) {
    try {
      await C.setWidth(this._SMCalloutId, width);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置是否自定义背景
   * @param isSet
   * @returns {Promise.<void>}
   */
  async setCustomize(isSet) {
    try {
      await C.setCustomize(this._SMCalloutId, isSet);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置位置
   * @param point2D / x, y
   * @returns {Promise.<void>}
   */
  async setLocation() {
    try {
      if (typeof arguments[0] === 'number' && typeof arguments[1] === 'number') {
        await C.setLocationByXY(this._SMCalloutId, arguments[0], arguments[1]);
      } else {
        await C.setLocation(this._SMCalloutId, arguments[0]._SMPoint2DId);
      }
    } catch (e) {
      console.error(e);
    }
  }
  
  // /**
  //  * 设置位置
  //  * @param x
  //  * @param y
  //  * @returns {Promise.<void>}
  //  */
  // async setLocation(x, y) {
  //   try {
  //     await C.setLocation(this._SMCalloutId, x, y);
  //   } catch (e) {
  //     console.error(e);
  //   }
  // }
  
  /**
   * 设置图片
   * @param imagePath
   * @returns {Promise.<void>}
   */
  async setContentView(imagePath) {
    try {
      await C.setContentView(this._SMCalloutId, imagePath);
    } catch (e) {
      console.error(e);
    }
  }
  
  static TYPE(type) {
    var value;
    switch (type) {
      case 'NONE':
      case 'none':
        value = -1;
        break;
      case 'LEFT':
      case 'left':
        value = 0;
        break;
      case 'TOP':
      case 'top':
        value = 1;
        break;
      case 'RIGHT':
      case 'right':
        value = 2;
        break;
      case 'BOTTOM':
      case 'bottom':
        value = 3;
        break;
      case 'CENTER':
      case 'center':
        value = 4;
        break;
      case 'LEFTTOP':
      case 'lefttop':
        value = 5;
        break;
      case 'righttop':
      case 'RIGHTTOP':
        value = 6;
        break;
      case 'LEFTBOTTOM':
      case 'leftbottom':
        value = 7;
        break;
      case 'RIGHTBOTTOM':
      case 'rightbottom':
        value = 8;
        break;
    }
    return value;
  }
}


CallOut.Image = {
  STARTPOINT,
  DESTPOINT,
}