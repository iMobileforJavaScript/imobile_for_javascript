/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SL = NativeModules.JSSymbolLibrary
import SymbolGroup from './SymbolGroup'
import Symbol from './Symbol'
/**
 * @class SymbolLibrary
 * @description 符号库基类。

 点状符号库类、线型符号库类和填充符号库类都继承自该抽象类。用来管理符号对象，包括符号对象的添加、删除。
 */
export default class SymbolLibrary {

  async add(symbol) {
    try {
      return await SL.add(this._SMSymbolLibraryId, symbol._SMSymbolId)
    } catch (e) {
      console.error(e)
    }
  }

  async addToGroup(symbol, group) {
    try {
      return await SL.addToGroup(this._SMSymbolLibraryId, symbol._SMSymbolId, group._SMSymbolGroupId)
    } catch (e) {
      console.error(e)
    }
  }

  async clear() {
    try {
      await SL.clear(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }

  async contains(symbolId) {
    try {
      return await SL.contains(this._SMSymbolLibraryId, symbolId)
    } catch (e) {
      console.error(e)
    }
  }

  async findGroup(symbolId) {
    try {
      let id = await SL.findGroup(this._SMSymbolLibraryId, symbolId)
      let group = new SymbolGroup()
      group._SMSymbolGroupId = id
      return group
    } catch (e) {
      console.error(e)
    }
  }

  async findSymbol(symbolId) {
    try {
      let id = await SL.findSymbol(this._SMSymbolLibraryId, symbolId)
      let symbol = new Symbol()
      symbol._SMSymbolId = id
      return symbol
    } catch (e) {
      console.error(e)
    }
  }

  async findSymbolWithName(name) {
    try {
      let id = await SL.findSymbolWithName(this._SMSymbolLibraryId, name)
      let symbol = new Symbol()
      symbol._SMSymbolId = id
      return symbol
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 导入符号库文件，该操作会先删除当前符号库中已经存在的符号
   * @returns {Promise}
   */
  async fromFile() {
    try {
      return await SL.fromFile(this._SMSymbolLibraryId)
    } catch (e) {
      console.error(e)
    }
  }

  async getRootGroup() {
    try {
      let id = await SL.getRootGroup(this._SMSymbolLibraryId)
      let group = new SymbolGroup()
      group._SMSymbolGroupId = id
      return group
    } catch (e) {
      console.error(e)
    }
  }

  async moveTo(targetId, group) {
    try {
      return await SL.moveTo(this._SMSymbolLibraryId, targetId, group._SMSymbolGroupId)
    } catch (e) {
      console.error(e)
    }
  }

  async remove(targetId) {
    try {
      return await SL.remove(this._SMSymbolLibraryId, targetId)
    } catch (e) {
      console.error(e)
    }
  }
}
