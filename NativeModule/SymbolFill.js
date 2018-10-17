/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SF = NativeModules.JSSymbolFill

import Symbol from './Symbol'

/**
 * @class SymbolFill
 * @description 填充符号类。

 该类继承自符号基类，即 Symbol 类。
 */
export default class SymbolFill extends Symbol {
  constructor(){
    super()
    Object.defineProperty(this,"_SMSymbolFillId",{
      get:function () {
        return this._SMSymbolId
      },
      set:function (_SMSymbolFillId) {
        this._SMSymbolId = _SMSymbolFillId
      }
    })
  }

  async dispose() {
    try {
      await SF.dispose(this._SMSymbolFillId)
    } catch (e) {
      console.error(e)
    }
  }
}
