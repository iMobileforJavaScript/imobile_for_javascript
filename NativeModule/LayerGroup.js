/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yangshanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native'
let L = NativeModules.JSLayerGroup
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
export default class LayerGroup extends Layer{
  // async add(editable){
  //   try{
  //     await L.add(this._SMLayerId)
  //   }catch(e){
  //     console.error(e)
  //   }
  // }
}
