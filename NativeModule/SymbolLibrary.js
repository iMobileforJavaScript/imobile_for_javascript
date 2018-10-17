/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SL = NativeModules.JSSymbolLibrary

/**
 * @class SymbolLibrary
 * @description 符号库基类。

 点状符号库类、线型符号库类和填充符号库类都继承自该抽象类。用来管理符号对象，包括符号对象的添加、删除。
 */
export default class SymbolLibrary {

  async add() {
    try {
      await SL.dispose(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }

  async draw(w, h) {
    try {
      return await SL.draw(this._SMSymbolLibraryId, w, h)
    } catch (e) {
      console.error(e)
    }
  }

  async getID() {
    try {
      return await SL.getID(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }

  async getLibrary() {
    try {
      // TODO lib
      return await SL.getLibrary(this._SMSymbolLibraryId,)
    } catch (e) {
      console.error(e)
    }
  }

  async getName() {
    try {
      return await SL.getName(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }

  async getType() {
    try {
      return await SL.getType(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }

  async setSymbolStyle(geoStyle) {
    try {
      return await SL.draw(this._SMSymbolLibraryId, geoStyle._SMGeoStyleId)
    } catch (e) {
      console.error(e)
    }
  }

  async toString() {
    try {
      return await SL.toString(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }
}
