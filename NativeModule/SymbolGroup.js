/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SG = NativeModules.JSSymbolGroup

import Symbol from './Symbol'
import SymbolGroups from './SymbolGroups'
import SymbolLibrary from './SymbolLibrary'

/**
 * @class SymbolGroup
 * @description 符号库分组类。
 */
export default class SymbolGroup {

  async dispose() {
    try {
      await SG.dispose(this._SMSymbolGroupId)
    } catch (e) {
      console.error(e)
    }
  }

  async get(index) {
    try {
      let id = await SG.get(this._SMSymbolGroupId, index)
      let symbol = new Symbol()
      symbol._SMSymbolId = id
      return symbol
    } catch (e) {
      console.error(e)
    }
  }

  async getChildGroups() {
    try {
      let id = await SG.getChildGroups(this._SMSymbolGroupId)
      let groups = new SymbolGroups()
      groups._SMSymbolGroupsId = id
      return groups
    } catch (e) {
      console.error(e)
    }
  }

  async getCount() {
    try {
      return await SG.getCount(this._SMSymbolGroupId)
    } catch (e) {
      console.error(e)
    }
  }

  async getLibrary() {
    try {
      let id = await SG.getLibrary(this._SMSymbolGroupId)
      let lib = new SymbolLibrary()
      lib._SMSymbolLibraryId = id
      return lib
    } catch (e) {
      console.error(e)
    }
  }

  async getName() {
    try {
      return await SG.getName(this._SMSymbolGroupId)
    } catch (e) {
      console.error(e)
    }
  }

  async getParent() {
    try {
      let id = await SG.getParent(this._SMSymbolGroupId)
      let group = new SymbolGroup()
      group._SMSymbolGroupId = id
      return group
    } catch (e) {
      console.error(e)
    }
  }

  async indexOf(id) {
    try {
      return await SG.indexOf(this._SMSymbolGroupId, id)
    } catch (e) {
      console.error(e)
    }
  }
}
