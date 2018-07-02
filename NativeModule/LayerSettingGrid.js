/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native'
let LSG = NativeModules.JSLayerSettingGrid
import GeoStyle from './GeoStyle.js'
import LayerSetting from './LayerSetting.js'

/**
 * @class LayerSettingGrid
 * @description 栅格图层设置类。
 */
export default class LayerSettingGrid extends LayerSetting{
    constructor(){
        super()
        Object.defineProperty(this,"_SMLayerSettingGridId", {
            get:function(){
                return this._SMLayerSettingId
            },
            set:function(_SMLayerSettingGridId){
                this._SMLayerSettingId = _SMLayerSettingGridId
            },
        })
    }
    
    /**
     * 创建一个LayerSettingGrid实例
     * @memberOf LayerSettingGrid
     * @returns {Promise.<LayerSettingGrid>}
     */
    async createObj(){
        try{
            var {_layerSettingGridId_} = await LSG.createObj()
            var layerSettingGrid = new LayerSettingGrid()
            layerSettingGrid._SMLayerSettingGridId = _layerSettingGridId_
            return layerSettingGrid
        } catch(e) {
            console.error(e)
        }
    }
    
    /**
     * 获取矢量图层的风格。
     * @memberOf LayerSettingGrid
     * @returns {Promise.<type>}
     */
    async getType() {
        try{
            
            var {type} = await LSG.getType(this._SMLayerSettingGridId)
            var typeStr = 'type'
            switch (type){
                case 0 : typeStr = 'Grid'
                    break
                case 1 : typeStr = 'RASTER'
                    break
                case 2 : typeStr = 'GRID'
                    break
                default : throw new Error("Unknown LayerSetting Type")
            }
            return typeStr
        } catch(e) {
            console.error(e)
        }
    }

    /**
     * 获取栅格图层特殊值
     * @memberOf LayerSettingGrid
     * @returns {Promise.<type>}
     */
    async getSpecialValue(){
        try{
            var { specialValue } = await LSG.getSpecialValue(this._SMLayerSettingGridId)
            return specialValue
        } catch(e) {
            console.error(e)
        }
    }

    /**
     * 设置栅格图层特殊值
     * @param specialValue
     * @memberOf LayerSettingGrid
     * @returns {Promise.<type>}
     */
    async setSpecialValue(specialValue){
        try {
            await LSG.setSpecialValue(this._SMLayerSettingGridId, specialValue)
        } catch(e) {
            console.error(e)
        }
    }

    /**
     * 获取栅格图层指定的特殊值是否要透明显示
     * @memberOf LayerSettingGrid
     * @returns {Promise.<type>}
     */
    async isSpecialValueTransparent(){
        try {
            var { isSpecialValueTransparent } = await LSG.isSpecialValueTransparent(this._SMLayerSettingGridId)
            return isSpecialValueTransparent
        } catch(e) {
            console.error(e)
        }
    }

    /**
     * 设置栅格图层特殊值
     * @param specialValueTransparent
     * @memberOf LayerSettingGrid
     * @returns {Promise.<type>}
     */
    async setSpecialValueTransparent(specialValueTransparent){
        try {
            await LSG.setSpecialValueTransparent(this._SMLayerSettingGridId, specialValueTransparent)
        } catch(e) {
            console.error(e)
        }
    }

    /**
     * 获取栅格图层当前指定特殊值对应的像元要显示的颜色
     * @memberOf LayerSettingGrid
     * @returns {Promise.<type>}
     */
    async getSpecialValueColor(){
        try {
            var { specialValueColor } = await LSG.isSpecialValueTransparent(this._SMLayerSettingGridId)
            return specialValueColor
        } catch(e) {
            console.error(e)
        }
    }

    /**
     * 设置栅格图层当前指定特殊值对应的像元要显示的颜色
     * @param r - red
     * @param g - green
     * @param b - blue
     * @param a - alpha
     * @memberOf LayerSettingGrid
     * @returns {Promise.<type>}
     */
    async setSpecialValueTransparent(r, g, b, a){
        try {
            await LSG.setSpecialValueTransparent(this._SMLayerSettingGridId, r, g, b, a)
        } catch(e) {
            console.error(e)
        }
    }
}

LayerSettingGrid.TYPE = {
    Grid:0,
    RASTER:1,
    GRID:2
}
