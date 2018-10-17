/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SML = NativeModules.JSSymbolMarkerLibrary

import SymbolLibrary from './SymbolLibrary'

/**
 * @class SymbolMarkerLibrary
 * @description 点状符号库类。

 该类继承自符号库基类，即 SymbolLibrary 类，该类提供的方法都继承自符号库基类。
 */
export default class SymbolMarkerLibrary extends SymbolLibrary {
  constructor(){
    super()
    Object.defineProperty(this,"_SMSymbolMarkerLibraryId",{
      get:function () {
        return this._SMSymbolLibraryId
      },
      set:function (_SMSymbolMarkerLibraryId) {
        this._SMSymbolLibraryId = _SMSymbolMarkerLibraryId
      }
    })
  }

  async dispose() {
    try {
      await SML.dispose(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }
}
