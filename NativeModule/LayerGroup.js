/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yangshanglong
 E-mail: yangshanglong@supermap.com

 **********************************************************************************/
import { NativeModules } from 'react-native'
let LG = NativeModules.JSLayerGroup
import Layer from './Layer.js'

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

  async getLayer(index) {
    try {
      let item = await LG.get(this._SMLayerId, index);
      let layer
      if (item) {
        if (item.type === 'layerGroup') {
          layer = new LayerGroup();
        } else {
          layer = new Layer();
        }
        layer._SMLayerId = item.id;
        item.layer = layer
      }
      return item;
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

  async insert(layer, index) {
    try {
      await LG.insert(this._SMLayerId, layer._SMLayerId, index);
    } catch (e) {
      console.error(e);
    }
  }

  async insertGroup(index, groupName) {
    try {
      let id = await LG.insertGroup(this._SMLayerId, index, groupName);
      let group = new LayerGroup()
      group._SMLayerId = id
      return group
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
