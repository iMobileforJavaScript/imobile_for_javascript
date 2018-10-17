/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SL = NativeModules.JSSymbolLine

import Symbol from './Symbol'

/**
 * @class SymbolLine
 * @description 线状符号类。

 该类继承自符号基类，即 Symbol 类。
 */
export default class SymbolLine extends Symbol {
  constructor(){
    super()
    Object.defineProperty(this,"_SMSymbolLineId",{
      get:function () {
        return this._SMSymbolId
      },
      set:function (_SMSymbolLineId) {
        this._SMSymbolId = _SMSymbolLineId
      }
    })
  }

  async dispose() {
    try {
      await SL.dispose(this._SMSymbolLineId)
    } catch (e) {
      console.error(e)
    }
  }
}
