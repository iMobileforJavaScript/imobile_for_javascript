import {NativeModules} from 'react-native';
let LSV = NativeModules.JSLayerSettingVector;
import GeoStyle from './GeoStyle.js';
import LayerSetting from './LayerSetting.js';

/**
 * @class LayerSettingVector
 */
export default class LayerSettingVector extends LayerSetting{
    constructor(){
        super();
        Object.defineProperty(this,"_layerSettingVectorId_",{
                              get:function(){
                              return this._layerSettingId_
                              },
                              set:function(_layerSettingVectorId_){
                              this._layerSettingId_ = _layerSettingVectorId_;
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
            layerSettingVector._layerSettingVectorId_ = _layerSettingVectorId_
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

            var {geoStyleId} = await LSV.getStyle(this._layerSettingVectorId_);
            var geoStyle = new GeoStyle();
            geoStyle.geoStyleId = geoStyleId;
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
            await LSV.setStyle(this._layerSettingVectorId_,geoStyle.geoStyleId);
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
            
            var {type} = await LSV.getType(this._layerSettingVectorId_);
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
