/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: Feature3Ds-三维要素类;
 **********************************************************************************/
import { NativeModules } from 'react-native';
let F = NativeModules.JSFeature3D;
import Geometry3D from './Geometry3D';
/**
 * @class Feature3D
 */
export default class Feature3D {

    /**
     * 获取／设置三维要素可见性。
     * @memberOf Feature3D
     * @returns {Boolean}
     */
    async visable(isVisable) {
        try {
            if (arguments.length >= 1) {
                await F.setVisable(this._SMFeature3DId, isVisable);
                var visable = isVisable;
            } else {
                var { visable } = await F.getVisable(this._SMFeature3DId);
            }
            return visable;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 获取三维要素对应三维几何对象。
     * @memberOf Feature3D
     * @returns {Geometry3D}
     */
    async getGeometry3D() {
        try {
            var {geometry3dId} = await F.getGeometry3D(this._SMFeature3DId);
            var geometry3d = new Geometry3D();
            geometry3d._SMGeometry3DId = geometry3dId;
            return geometry3d;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 返回三维要素对象的描述信息。
     * @memberOf Feature3D
     * @returns {string}
     */
    async getDescription() {
        try {
            var {description} = await F.getDescription(this._SMFeature3DId);
            return description;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 返回三维要素对象指定字段索引对应的字段值。
     * @memberOf Feature3D
     * @returns {string}
     */
    async getFieldValueByIndex(index) {
        try {
            var {value} = await F.getFieldValueByIndex(this._SMFeature3DId,index);
            return value;
        } catch (e) {
            console.error(e);
        }
    }

        /**
     * 返回三维要素对象指定字段索引对应的字段值。
     * @memberOf Feature3D
     * @returns {string}
     */
    async getFieldValueByName(name) {
        try {
            var {value} = await F.getFieldValueByName(this._SMFeature3DId,name);
            return value;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 返回三维要素对象指定字段索引对应的字段值。
     * @memberOf Feature3D
     * @returns {number}
     */
    async getID() {
        try {
            var {id} = await F.getID(this._SMFeature3DId);
            return id;
        } catch (e) {
            console.error(e);
        }
    }

}
