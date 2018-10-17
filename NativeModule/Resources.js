/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let R = NativeModules.JSResources

import Workspace from './Workspace'

/**
 * @class Resources
 * @description 资源库类。
 该类用于管理工作空间中的资源，包括线型库、点状符号库和填充符号库。
 */
export default class Resources {

  async createObj() {
    try {
      let id = await R.createObj();
      let res = new Resources();
      res._SMResourcesId = id;
      return res;
    } catch (e) {
      console.error(e);
    }
  }

  async dispose() {
    try {
      await R.dispose()
    } catch (e) {
      console.error(e)
    }
  }

  async getFillLibrary() {
    try {
      await R.getFillLibrary(this._SMResourcesId)
    } catch (e) {
      console.error(e)
    }
  }

  async getLineLibrary() {
    try {
      await R.getFillLibrary(this._SMResourcesId)
    } catch (e) {
      console.error(e)
    }
  }

  async getMarkerLibrary() {
    try {
      await R.getMarkerLibrary(this._SMResourcesId)
    } catch (e) {
      console.error(e)
    }
  }

  async getWorkspace() {
    try {
      await R.getWorkspace(this._SMResourcesId)
    } catch (e) {
      console.error(e)
    }
  }
}
