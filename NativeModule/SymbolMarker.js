/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SM = NativeModules.JSSymbolMarker

import Symbol from './Symbol'

/**
 * @class SymbolMarker
 * @description 点状符号类。

 该类继承自符号基类，即 Symbol 类。
 */
export default class SymbolMarker extends Symbol {
  constructor(){
    super()
    Object.defineProperty(this,"_SMSymbolMarkerId",{
      get:function () {
        return this._SMSymbolId
      },
      set:function (_SMSymbolMarkerId) {
        this._SMSymbolId = _SMSymbolMarkerId
      }
    })
  }

  async dispose() {
    try {
      awaitSM.dispose(this._SMSymbolMarkerId)
    } catch (e) {
      console.error(e)
    }
  }

  async computeDisplaySize(value) {
    try {
      return await SM.computeDisplaySize(this._SMSymbolMarkerId, value)
    } catch (e) {
      console.error(e)
    }
  }

  async computeSymbolSize(value) {
    try {
      return await SM.computeSymbolSize(this._SMSymbolMarkerId, value)
    } catch (e) {
      console.error(e)
    }
  }

  async getCount() {
    try {
      return await SM.getCount(this._SMSymbolMarkerId)
    } catch (e) {
      console.error(e)
    }
  }

  async getOrigin() {
    try {
      return await SM.getOrigin(this._SMSymbolMarkerId)
    } catch (e) {
      console.error(e)
    }
  }

  async setOrigin(x, y) {
    try {
      await SM.setOrigin(this._SMSymbolMarkerId, x, y)
    } catch (e) {
      console.error(e)
    }
  }
}
