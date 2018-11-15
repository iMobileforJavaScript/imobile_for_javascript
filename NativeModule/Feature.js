/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let F = NativeModules.JSFeature;
import Geometry from './Geometry.js';

/**
 * @class Feature
 * @description 几何对象类，包含几何对象与属性信息。
 */
export default class Feature {
    /**
     * Feature对象构造函数。
     * @memberOf Feature
     * @param {array} fieldNames - 指定的属性名数组。
     * @param {array} fieldValues - 指定的属性值数组。
     * @param {object} geometry - 指定的几何对象。
     * @returns {Promise.<Feature>}
     */
    async createObj(fieldNames,fieldValues,geometry){
        try{
            var {_featureId_} = await F.createObj(fieldNames,fieldValues,geometry._SMGeometryId);
            var feature = new Feature();
            feature._SMFeatureId = _featureId_;
            return feature;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取属性名数组。
     * @memberOf Feature
     * @returns {Promise.<Array>}
     */
    async getFieldNames(){
        try{
            var arr = F.getFieldNames(this._SMFeatureId);
            return arr;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取属性值数组。
     * @memberOf Feature
     * @returns {Promise.<array>}
     */
    async getFieldValues(){
        try{
            var arr = F.getFieldValues(this._SMFeatureId);
            return arr;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取几何对象。
     * @memberOf Feature
     * @returns {Promise.<Geometry>}
     */
    async getGeometry(){
        try{
            var {geometryId} = await F.getGeometry(this._SMFeatureId);
            var geometry = new Geometry();
            geometry._SMGeometryId = geometryId;
            return geometry;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 将类对象转换成Json串。
     * @memberOf Feature
     * @returns {Promise.<object>}
     */
    async toJson(){
        try{
            var jsonString = await F.toJson(this._SMFeatureId);
            var jsonObj = JSON.parse(jsonString);
            return jsonObj;
        }catch (e){
            console.error(e);
        }
    }
}
