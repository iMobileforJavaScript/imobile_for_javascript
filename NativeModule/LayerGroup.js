/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yangshanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let LG = NativeModules.JSLayerGroup
import Dataset from './Dataset.js'
import Selection from './Selection.js'
import LayerSetting from './LayerSetting.js'
import LayerSettingVector from './LayerSettingVector.js'
import LayerSettingGrid from './LayerSettingGrid'
import LayerSettingImage from './LayerSettingImage'
import Layer from './Layer'

/**
 * @class LayerGroup
 * @description (该类的实例不可被创建,只可以通过在 Map 类中的 addLayerGroup 方法来创建)该类提供了图层组分类
 */
export default class LayerGroup extends Layer {
  constructor() {
    super();
    Object.defineProperty(this, "_SMLayerGroupId", {
      get: function () {
        return this._SMLayerId
      },
      set: function (_SMLayerGroupId) {
        this._SMLayerId = _SMLayerGroupId;
      }
    })
  }

  async add(layer) {
    try {
      await LG.add(this._SMLayerId, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  async addGroup(groupName) {
    try {
      let groupId = await LG.addGroup(this._SMLayerId, groupName);
      let group = new LayerGroup();
      group._SMLayerId = groupId;
      return group;
    } catch (e) {
      console.error(e);
    }
  }

  async get(index) {
    try {
      let groupId = await LG.get(this._SMLayerId, index);
      let layer = new Layer();
      layer._SMLayerId = groupId;
      return layer;
    } catch (e) {
      console.error(e);
    }
  }

  async getCount() {
    try {
      return await LG.getCount(this._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  async indexOf(layer) {
    try {
      return await LG.indexOf(this._SMLayerId, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  async insert(layer) {
    try {
      await LG.insert(this._SMLayerId, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  async insertGroup(layer) {
    try {
      await LG.insertGroup(this._SMLayerId, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  async remove(layer) {
    try {
      return await LG.remove(this._SMLayerId, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  async removeGroup(layer) {
    try {
      return await LG.removeGroup(this._SMLayerId, layer._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }

  async ungroup() {
    try {
      return await LG.ungroup(this._SMLayerId);
    } catch (e) {
      console.error(e);
    }
  }
}
