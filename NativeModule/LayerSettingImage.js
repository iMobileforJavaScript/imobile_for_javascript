/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let LSI = NativeModules.JSLayerSettingImage;
import GeoStyle from './GeoStyle.js';
import LayerSetting from './LayerSetting.js';

/**
 * @class LayerSettingImage
 * @description 影像图层设置类。
 */
export default class LayerSettingImage extends LayerSetting{
    constructor(){
        super();
        Object.defineProperty(this,"_SMLayerSettingImageId",{
                              get:function(){
                              return this._SMLayerSettingId
                              },
                              set:function(_SMLayerSettingImageId){
                              this._SMLayerSettingId = _SMLayerSettingImageId;
                              }
                              })
    }
    
    /**
     * 创建一个LayerSettingImage实例
     * @memberOf LayerSettingImage
     * @returns {Promise.<LayerSettingImage>}
     */
    async createObj(){
        try{
            var {_layerSettingImageId_} = await LSI.createObj();
            var layerSettingImage = new LayerSettingImage();
            layerSettingImage._SMLayerSettingImageId = _layerSettingImageId_
            return layerSettingImage;
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 获取矢量图层的风格。
     * @memberOf LayerSettingImage
     * @returns {Promise.<type>}
     */
    async getType(){
        try{
            
            var {type} = await LSI.getType(this._SMLayerSettingImageId);
            var typeStr = 'type';
            switch (type){
                case 0 : typeStr = 'Image';
                    break;
                case 1 : typeStr = 'RASTER';
                    break;
                case 2 : typeStr = 'GRID';
                    break;
                default : throw new Error("Unknown LayerSetting Type");
            }
            return typeStr;
        }catch (e){
            console.error(e);
        }
    }
}

LayerSettingImage.TYPE = {
    Image:0,
    RASTER:1,
    GRID:2
}
