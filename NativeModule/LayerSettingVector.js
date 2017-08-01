/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let LSV = NativeModules.JSLayerSettingVector;
import GeoStyle from './GeoStyle.js';
import LayerSetting from './LayerSetting.js';

/**
 * @class LayerSettingVector
 * @description 矢量图层设置类。
 */
export default class LayerSettingVector extends LayerSetting{
    constructor(){
        super();
        Object.defineProperty(this,"_SMLayerSettingVectorId",{
                              get:function(){
                              return this._SMLayerSettingId
                              },
                              set:function(_SMLayerSettingVectorId){
                              this._SMLayerSettingId = _SMLayerSettingVectorId;
                              }
                              })
    }
    
    /**
     * 创建一个LayerSettingVector实例
     * @memberOf LayerSettingVector
     * @returns {Promise.<LayerSettingVector>}
     */
    async createObj(){
        try{
            var {_layerSettingVectorId_} = await LSV.createObj();
            var layerSettingVector = new LayerSettingVector();
            layerSettingVector._SMLayerSettingVectorId = _layerSettingVectorId_
            return layerSettingVector;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取矢量图层的风格。
     * @memberOf LayerSettingVector
     * @returns {Promise.<GeoStyle>}
     */
    async getStyle(){
        try{

            var {geoStyleId} = await LSV.getStyle(this._SMLayerSettingVectorId);
            var geoStyle = new GeoStyle();
            geoStyle._SMGeoStyleId = geoStyleId;
            return geoStyle;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置矢量图层的风格。
     * @memberOf LayerSettingVector
     * @param {object} geoStyle - 矢量图层的风格。
     * @returns {Promise.<void>}
     */
    async setStyle(geoStyle){
        try{
            await LSV.setStyle(this._SMLayerSettingVectorId,geoStyle._SMGeoStyleId);
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 获取矢量图层的风格。
     * @memberOf LayerSettingVector
     * @returns {Promise.<type>}
     */
    async getType(){
        try{
            
            var {type} = await LSV.getType(this._SMLayerSettingVectorId);
            return type;
        }catch (e){
            console.error(e);
        }
    }
}

LayerSettingVector.TYPE = {
    VECTOR:0,
    RASTER:1,
    GRID:2
}
