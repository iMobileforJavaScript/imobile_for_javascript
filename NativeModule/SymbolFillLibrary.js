/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SFL = NativeModules.JSSymbolFillLibrary

import SymbolLibrary from './SymbolLibrary'

/**
 * @class SymbolFillLibrary
 * @description 填充符号库类。

 该类继承自符号库基类，即 SymbolLibrary 类，该类提供的方法都继承自符号库基类。
 */
export default class SymbolFillLibrary extends SymbolLibrary {
  constructor(){
    super()
    Object.defineProperty(this,"_SMSymbolFillLibraryId",{
      get:function () {
        return this._SMSymbolLibraryId
      },
      set:function (_SMSymbolFillLibraryId) {
        this._SMSymbolLibraryId = _SMSymbolFillLibraryId
      }
    })
  }

  async dispose() {
    try {
      await SFL.dispose(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }
}
