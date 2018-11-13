/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let FS = NativeModules.JSFeatureSet;
import Geometry from './Geometry.js';

/**
 * @class FeatureSet
 * @description 要素资源集合类。
 */
export default class FeatureSet {
    /**
     * 删除要素
     * @description 物理性删除指定要素集中的所有要素，即把要素从设备的物理存储介质上删除，无法恢复。
     * @memberOf FeatureSet
     * @returns {Promise.<void>}
     */
    async deleteAll(){
        try{
            await FS.deleteAll(this._SMFeatureSetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 用于删除当前要素，成功则返回 true。
     * @memberOf FeatureSet
     * @returns {Promise.<void>}
     */
    async delete(){
        try{
            await FS.delete(this._SMFeatureSetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 返回要素集合中要素的个数。
     * @memberOf FeatureSet
     * @returns {Promise<number>}
     */
    async getFeatureCount(){
        try{
            var count = await FS.getFeatureCount(this._SMFeatureSetId);
            return count;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 根据字段名指定字段，返回当前要素该字段的值。
     * @memberOf FeatureSet
     * @param {string} fieldName - 字段名。
     * @returns {Promise<string>}
     */
    async getFieldValue(fieldName){
        try{
            var value = await FS.getFieldValue(this._SMFeatureSetId,fieldName);
            return value;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取当前要素中的几何对象。
     * @memberOf FeatureSet
     * @returns {Promise.<Geometry>}
     */
    async getGeometry(){
        try{
            var {geometryId} = await FS.getGeometry(this._SMFeatureSetId);
            var geometry = new Geometry();
            geometry._SMGeometryId = geometryId;
            return geometry;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 返回要素集是否是只读的，如果是只读的，则返回 true，表示要素集中的信息将不可被修改。
     * @memberOf FeatureSet
     * @returns {Promise.<void>}
     */
    async isReadOnly(){
        try{
            await FS.isReadOnly(this._SMFeatureSetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 用于移动当前要素位置到第一个要素，使第一个要素成为当前要素。
     * @memberOf FeatureSet
     * @returns {Promise.<void>}
     */
    async moveFirst(){
        try{
            await FS.moveFirst(this._SMFeatureSetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 用于移动当前要素位置到最后一个要素，使最后一个要素成为当前要素。
     * @memberOf FeatureSet
     * @returns {Promise.<void>}
     */
    async moveLast(){
        try{
            await FS.moveLast(this._SMFeatureSetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 移动当前要素位置到下一个要素，使该要素成为当前要素。
     * @memberOf FeatureSet
     * @returns {Promise.<void>}
     */
    async moveNext(){
        try{
            await FS.moveNext(this._SMFeatureSetId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 移动当前要素位置到上一个要素，使该要素成为当前要素。
     * @memberOf FeatureSet
     * @returns {Promise.<void>}
     */
    async movePrev(){
        try{
            await FS.movePrev(this._SMFeatureSetId);
        }catch (e){
            console.error(e);
        }
    }
}
