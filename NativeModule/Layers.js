/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let L = NativeModules.JSLayers;
import Layer from './Layer.js';

/**
 * @class Layers
 * @deprecated
 */
export default class Layers{
    /**
     * 用于把一个数据集添加到此图层集合作为一个普通图层显示，即创建一个普通图层。
     * @memberOf Layers
     * @param {object} dataset - 要添加到图层的数据集。
     * @param {boolean} b - 指定新创建图层是否放在图层集合的最上面一层。当设置为 false 时，则将此新创建图层放在最底层。
     * @returns {Promise.<void>}
     */
    async add(dataset,b){
        this._drepecated();
        try{
            await L.add(this._SMLayersId,dataset._SMDatasetId,b);
        }catch (e){
            console.error(e);
        }
    }

    /**
     *返回此图层集合中指定名称的图层对象。
     * @memberOf Layers
     * @param {number} index - 图层序号
     * @returns {Promise.<Layer>}
     */
    async get(index){
        this._drepecated();
        try{
            var layer = new Layer();
            if(typeof index == "string"){
                var {layerId} = await L.getByName(this._SMLayersId,index);
            }else{
                var {layerId} = await L.get(this._SMLayersId,index);
            }
            layer._SMLayerId = layerId;
            return layer;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回此图层集合中图层对象的总数。
     * @memberOf Layers
     * @returns {Promise.<Promise.count>}
     */
    async getCount(){
        this._drepecated();
        try{
            var {count} = await L.getCount(this._SMLayersId);
            return count;
        }catch(e){
            console.error(e);
        }
    }

    _drepecated(){
        console.warn("Layers.js:This class has been deprecated. " +
            "All its implements has been migrated to the Map class." +
            "eg:Layers.get(index) now has been substituted by map.getLayer(index)." +
            "Relevant modifications refer to the API documents please");
    }
}
