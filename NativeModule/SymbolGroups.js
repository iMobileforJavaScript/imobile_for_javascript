/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let SGS = NativeModules.JSSymbolGroups

import Symbol from './Symbol'
import SymbolGroup from './SymbolGroup'

/**
 * @class SymbolGroups
 * @description 符号库分组集合类。
 */
export default class SymbolGroups {

  async createObj() {
    try {
      let id = await SGS.createObj()
      let groups = new SymbolGroups()
      groups._SMSymbolGroupsId = id
      return groups
    } catch (e) {
      console.error(e)
    }
  }

  async dispose() {
    try {
      await SGS.dispose(this._SMSymbolGroupsId)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 测试指定的名称在分组集合中是否已经存在
   * @param name
   * @returns {Promise.<*>}
   */
  async contains(name) {
    try {
      return await SGS.contains(this._SMSymbolGroupsId, name)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 在该分组集合中创建子分组
   * @param name
   * @returns {Promise.<SymbolGroup>}
   */
  async create(name) {
    try {
      let id = await SGS.create(this._SMSymbolGroupsId, name)
      let group = new SymbolGroup()
      group._SMSymbolGroupId = id
      return group
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 返回该分组集合中指定 索引/名称 处的子分组
   * @returns {Promise.<SymbolGroup>}
   */
  async get() {
    try {
      if (!arguments || arguments.length !== 1) throw new Error("请传入参数：名称或者序号")
      let id = ''
      if (typeof arguments[0] === 'string') {
        id = await SGS.getByName(this._SMSymbolGroupsId, arguments[0])
      } else {
        id = await SGS.getByIndex(this._SMSymbolGroupsId, arguments[0])
      }
      let group = new SymbolGroup()
      group._SMSymbolGroupId = id
      return group
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 返回该分组集合中的子分组的个数
   * @returns {Promise.<*>}
   */
  async getCount() {
    try {
      return await SGS.getCount(this._SMSymbolGroupsId)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 返回指定名称的子分组对象（即 SymbolGroup 类对象）在该分组集合中的索引值
   * @param name
   * @returns {Promise.<*>}
   */
  async indexOf(name) {
    try {
      return await SGS.indexOf(this._SMSymbolGroupsId, name)
    } catch (e) {
      console.error(e)
    }
  }

  /**
   * 移除该分组集合中指定名称的子分组对象
   * @param name
   * @returns {Promise.<*>}
   */
  async remove(name) {
    try {
      return await SGS.remove(this._SMSymbolGroupsId, name)
    } catch (e) {
      console.error(e)
    }
  }
}
