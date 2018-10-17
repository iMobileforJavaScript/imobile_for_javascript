/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let S = NativeModules.JSSymbol

/**
 * @class Symbol
 * @description 符号基类。
                符号库中所有的符号类，包括点状符号类，线型符号类和填充符号类都继承自符号基类。
 */
export default class Symbol {

  async dispose() {
    try {
      await S.dispose(this._SMSymbolId)
    } catch (e) {
      console.error(e)
    }
  }

  async draw(w, h) {
    try {
      return await S.draw(this._SMSymbolId, w, h)
    } catch (e) {
      console.error(e)
    }
  }

  async getID() {
    try {
      return await S.getID(this._SMSymbolId)
    } catch (e) {
      console.error(e)
    }
  }

  async getLibrary() {
    try {
      // TODO lib
      return await S.getLibrary(this._SMSymbolId,)
    } catch (e) {
      console.error(e)
    }
  }

  async getName() {
    try {
      return await S.getName(this._SMSymbolId)
    } catch (e) {
      console.error(e)
    }
  }

  async getType() {
    try {
      return await S.getType(this._SMSymbolId)
    } catch (e) {
      console.error(e)
    }
  }

  async setSymbolStyle(geoStyle) {
    try {
      return await S.draw(this._SMSymbolId, geoStyle._SMGeoStyleId)
    } catch (e) {
      console.error(e)
    }
  }

  async toString() {
    try {
      return await S.toString(this._SMSymbolId)
    } catch (e) {
      console.error(e)
    }
  }
}
