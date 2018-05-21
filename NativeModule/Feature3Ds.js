/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: Feature3Ds-三维要素集合类;
 **********************************************************************************/
import { NativeModules } from 'react-native';
let FS = NativeModules.JSFeature3Ds;
import Feature3D from './Feature3D';
/**
 * @class Feature3Ds
 */
export default class Feature3Ds {
    /**
     * 获取三维要素。
     * @memberOf Feature3Ds
     * @returns {Object}
     */
    async get(index) {
        try {
            var { objectId, type } = await FS.get(this._SMFeature3DsId, index);
            var object = undefined;
            if (type == 'feature3D') {
                object = new Feature3D();
                object._SMFeature3DId = objectId;
            } else if (type == 'feature3Ds') {
                object = new Feature3Ds();
                object._SMFeature3DsId = objectId;
            }
            return object;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 根据给定的三维要素对象ID以及指定的查询选项，查找并返回三维要素对象。
     * @memberOf Feature3Ds
     * @returns {Feature3D}
     */
    async findFeature(index) {
        try {
            var {objectId} = await FS.findFeature(this._SMFeature3DsId, index);
            var object = new Feature3D();
            object._SMFeature3DId = objectId;
            return object;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 获取三维要素的个数。
     * @memberOf Feature3Ds
     * @returns {Boolean}
     */
    async getCount() {
        try {
            var { count } = await FS.getCount(this._SMFeature3DsId);
            return count;
        } catch (e) {
            console.error(e);
        }
    }

}
