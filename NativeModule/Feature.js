import {NativeModules} from 'react-native';
let F = NativeModules.JSFeature;
import Geometry from './Geometry.js';

/**
 * @class Feature
 */
export default class Feature {
    /**
     * 根据指定的参数构造一个新的Feature对象。
     * @memberOf Feature
     * @param {array} fieldNames - 指定的属性名数组。
     * @param {array} fieldValues - 指定的属性值数组。
     * @param {object} geometry - 指定的几何对象。
     * @returns {Promise.<Feature>}
     */
    async createObj(fieldNames,fieldValues,geometry){
        try{
            var {_featureId_} = await F.createObj(fieldNames,fieldValues,geometry.geometryId);
            var feature = new Feature();
            feature._featureId_ = _featureId_;
            return feature;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取属性名数组。
     * @memberOf Feature
     * @returns {Promise}
     */
    async getFieldNames(){
        try{
            var arr = F.getFieldNames(this._featureId_);
            return arr;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 获取属性值数组。
     * @memberOf Feature
     * @returns {Promise<array>}
     */
    async getFieldValues(){
        try{
            var arr = F.getFieldValues(this._featureId_);
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
            var {geometryId} = await F.getGeometry(this._featureId_);
            var geometry = new Geometry();
            geometry.geometryId = geometryId;
            return geometry;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 将类对象转换成Json串。
     * @returns {Promise.<object>}
     */
    async toJson(){
        try{
            var jsonString = await F.toJson(this._featureId_);
            var jsonObj = JSON.parse(jsonString);
            return jsonObj;
        }catch (e){
            console.error(e);
        }
    }
}
