/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import { NativeModules } from 'react-native'
let PCS = NativeModules.JSPrjCoordSys

/**
 * @class PrjCoordSys
 * @description 投影坐标系类。投影坐标系统由地图投影方式、投影参数、坐标单位和地理坐标系组成。
 */
export default class PrjCoordSys {
  /**
   * 创建一个PrjCoordSys对象
   * @param {int} type 类型枚举值
   * @returns {Promise.<PrjCoordSys>}
   */
  async createObj(type) {
    try {
      let _SMPrjCoordSysId
      if (type) {
        _SMPrjCoordSysId = await PCS.createObjWithType(type)
      } else {
        _SMPrjCoordSysId = await PCS.createObj()
      }
      let prjCoorSys = new PrjCoordSys()
      prjCoorSys._SMPrjCoordSysId = _SMPrjCoordSysId
      return prjCoorSys
    } catch (e) {
      console.error(e)
    }
  }
  
  async getType() {
    try {
      let type = await PCS.getType(this._SMPrjCoordSysId)
      return type
    } catch (e) {
      debugger
      console.error(e)
    }
  }
  
  async setType(type) {
    try {
      await PCS.setType(this._SMPrjCoordSysId, type)
    } catch (e) {
      console.error(e)
    }
  }
}
