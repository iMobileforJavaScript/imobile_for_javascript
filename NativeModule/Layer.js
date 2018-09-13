/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import { NativeModules } from 'react-native'
let L = NativeModules.JSLayer
let ThemeType = NativeModules.JSThemeType;
import Dataset from './Dataset.js'
import Recordset from './Recordset.js'
import Selection from './Selection.js'
import LayerSetting from './LayerSetting.js'
import LayerSettingVector from './LayerSettingVector.js'
import LayerSettingGrid from './LayerSettingGrid'
import LayerSettingImage from './LayerSettingImage'
import Theme from './Theme'
import ThemeLabel from './ThemeLabel'
import ThemeRange from './ThemeRange'
import ThemeUnique from './ThemeUnique'

/**
 * @class Layer
 * @description (该类的实例不可被创建,只可以通过在 Map 类中的 addLayer 方法来创建)该类提供了图层显示和控制等的便于地图管理的一系列方法。当数据集被加载到地图窗口中显示的时，就形成了一个图层，因此图层是数据集的可视化显示。一个图层是对一个数据集的引用或参考。通过对可视化的图层的编辑，可以对 相应的数据集的要素进行编辑。一个图层或多个图层叠加显示则形成了地图。图层分为普通图层和专题图层，矢量的普通图层中所有要素采用相同的渲染风格，栅格图层采用颜色表来显示其像元；而专题图层则采用指定类型的专题图风格来渲染其中的 要素或像元。
 */
export default class Layer {
  /**
   * 设置图层是否处于可编辑状态。该方法控制是否对图层所引用的数据进行修改。
   * @memberOf Layer
   * @param {boolean} editable
   * @returns {Promise.<void>}
   */
  async setEditable(editable) {
    try {
      await L.setEditable(this._SMLayerId, editable)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 判断图层是否处于可编辑状态。
   * @memberOf Layer
   * @returns {Promise.<boolean>}
   */
  async getEditable() {
    try {
      var { isEditable } = await L.getEditable(this._SMLayerId)
      return isEditable
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回图层的名称。图层的名称在图层所在的地图中唯一标识此图层。该标识不区分大小写。
   * @memberOf Layer
   * @returns {Promise.<void>}
   */
  async getName() {
    try {
      var { layerName } = await L.getName(this._SMLayerId)
      return layerName
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回此图层对应的数据集对象。图层是对数据集的引用，因而，一个图层与一个数据集相对应。
   * @memberOf Layer
   * @returns {Promise.<Dataset>}
   */
  async getDataset() {
    try {
      var { datasetId } = await L.getDataset(this._SMLayerId)
      var dataset = new Dataset()
      dataset._SMDatasetId = datasetId
      return dataset
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置图层关联的数据集。 设置的数据集必须与当前地图属于同一工作空间，且数据集类型与原有数据集类型一致，否则会抛出异常(该方法暂不支持iOS设备)。
   * @memberOf Layer
   * @param {object} dataset - 图层关联的数据集
   * @returns {Promise.<void>}
   */
  async setDataset(dataset) {
    try {
      await L.setDataset(this._SMLayerId, dataset._SMDatasetId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回此图层中的选择集对象。选择集是个集合，其中包含选择的图层中的一个或多个要素。在选择集中的要素才可以被编辑。注意选择集只适用于矢量数据集，栅格数据集和影像数据集没有选择集。
   * @memberOf Layer
   * @returns {Promise.<Selection>}
   */
  async getSelection() {
    try {
      var { selectionId, recordsetId } = await L.getSelection(this._SMLayerId)
      var selection = new Selection()
      var recordset = new Recordset()
      selection._SMSelectionId = selectionId
      recordset._SMRecordsetId = recordsetId
      
      selection.recordset = recordset
      return selection
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置图层中对象是否可以选择。
   * @memberOf Layer
   * @param {boolean} b
   * @returns {Promise.<void>}
   */
  async setSelectable(b) {
    try {
      await L.setSelectable(this._SMLayerId, b)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回图层中对象是否可以选择
   * @memberOf Layer
   * @param {void}
   * @returns {Promise.<boolean>}
   */
  async isSelectable() {
    try {
      var { selectable } = await L.isSelectable(this._SMLayerId)
      return selectable
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取此图层是否可见。true 表示此图层可见，false 表示图层不可见。当图层不可见时，其他所有的属性的设置将无效。
   * @memberOf Layer
   * @returns {Promise.<boolean>}
   */
  async getVisible() {
    try {
      var isVisible = await L.getVisible(this._SMLayerId)
      return isVisible
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置此图层是否可见。true 表示此图层可见，false 表示图层不可见。当图层不可见时，其他所有的属性的设置将无效。
   * @memberOf Layer
   * @param {boolean} b
   * @returns {Promise.<void>}
   */
  async setVisible(b) {
    try {
      await L.setVisible(this._SMLayerId, b)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取此图层是否可捕捉
   * @returns {Promise}
   */
  async isSnapable() {
    try {
      var isSnapable = await L.isSnapable(this._SMLayerId)
      return isSnapable
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置此图层是否可捕捉，false不可捕捉， true可捕捉
   * @param isSnapable
   * @returns {Promise.<void>}
   */
  async setSnapable(isSnapable) {
    try {
      await L.setSnapable(this._SMLayerId, isSnapable)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回普通图层的风格设置。LayerSettingVector 类用来对矢量数据图层风格进行设置和修改。
   * @memberOf Layer
   * @returns {Promise.<LayerSetting>}
   */
  async getAdditionalSetting() {
    try {
      let layerSetting
      let { _layerSettingId_, type } = await L.getAdditionalSetting(this._SMLayerId)
      if (type === 0) {
        layerSetting = new LayerSettingVector()
        layerSetting._SMLayerSettingId = _layerSettingId_
      } else if (type === 1) {
        //image
        layerSetting = new LayerSettingImage()
        layerSetting._SMLayerSettingId = _layerSettingId_
      } else {
        //grid
        layerSetting = new LayerSettingGrid()
        layerSetting._SMLayerSettingId = _layerSettingId_
      }
      return layerSetting
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置普通图层的风格。普通图层风格的设置对矢量数据图层、栅格数据图层以及影像数据图层是不相同的。LayerSettingVector类用来对矢量数据图层的风格进行设置和修改。
   * @memberOf Layer
   * @param {LayerSetting} layerSetting - 普通图层的风格设置.{@link LayerSetting}
   * @returns {Promise.<void>}
   */
  async setAdditionalSetting(layerSetting) {
    try {
      await L.setAdditionalSetting(this._SMLayerId, layerSetting._SMLayerSettingId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回选中的对象的集合
   * @param point2DId
   * @param tolerance
   * @returns {Promise.<Selection>}
   */
  async hitTest(point2DId, tolerance) {
    try {
      let { selectionId, recordsetId } = await L.hitTest(this._SMLayerId, point2DId, tolerance)
      let selection = await new Selection()
      selection._SMSelectionId = selectionId
      let recordset = await new Recordset()
      recordset._SMRecordsetId = recordsetId
      
      selection.recordset = recordset
      return selection
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回选中的对象的集合
   * @param point
   * @param tolerance
   * @returns {Promise.<Selection>}
   */
  async hitTestEx(point, tolerance) {
    try {
      let { selectionId, recordsetId } = await L.hitTestEx(this._SMLayerId, point._SMPointId, tolerance)
      let selection = await new Selection()
      selection._SMSelectionId = selectionId
      let recordset = await new Recordset()
      recordset._SMRecordsetId = recordsetId
      
      selection.recordset = recordset
      return selection
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 返回图层标题
   * @returns {Promise}
   */
  async getCaption() {
    try {
      return await L.getCaption(this._SMLayerId)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 设置图层标题
   * @param value
   * @returns {Promise.<void>}
   */
  async setCaption(value) {
    try {
      await L.setCaption(this._SMLayerId, value)
    } catch (e) {
      console.error(e)
    }
  }
  
  /**
   * 获取专题图层的专题图对象
   * @returns {Promise.<void>}
   */
  async getTheme() {
    try {
      let mTheme = await L.getTheme(this._SMLayerId) // {themeId, type}
      if (mTheme && mTheme.themeId) {
        let theme;
        switch (mTheme.type) {
          case ThemeType.UNIQUE:
            theme = new ThemeUnique()
            break
          case ThemeType.RANGE:
            theme = new ThemeRange()
            break
          case ThemeType.LABEL:
            theme = new ThemeLabel()
            break
          default:
            theme = new Theme()
            break
        }
        theme._SMThemeId = mTheme.themeId
        theme.type = mTheme.type
        return theme
      } else {
        return null
      }
    } catch (e) {
      console.error(e)
    }
  }
}
