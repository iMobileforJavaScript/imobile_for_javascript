/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SLL = NativeModules.JSSymbolLineLibrary

import SymbolLibrary from './SymbolLibrary'

/**
 * @class SymbolLineLibrary
 * @description 线状符号库类。

 该类继承自符号库基类，即 SymbolLibrary 类，该类提供方法均继承自符号库基类。
 */
export default class SymbolLineLibrary extends SymbolLibrary {
  constructor(){
    super()
    Object.defineProperty(this,"_SMSymbolLineLibraryId",{
      get:function () {
        return this._SMSymbolLibraryId
      },
      set:function (_SMSymbolLineLibraryId) {
        this._SMSymbolLibraryId = _SMSymbolLineLibraryId
      }
    })
  }

  async dispose() {
    try {
      await SLL.dispose(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }
}
