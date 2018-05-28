/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: Layer3Ds-三维图层集合类，用于获取三维图层；
 **********************************************************************************/
import { NativeModules } from 'react-native';
let LS = NativeModules.JSLayer3Ds;
import Layer3D from './Layer3D';
/**
 * @class Layer3Ds
 */
export default class Layer3Ds {

    /**
     *返回此图层集合中指定名称的三维图层对象。
     * @memberOf Layer3Ds
     * @param {number} index - 图层序号
     * @returns {Promise.<Layer>}
     */
    async get(index) {
        try {
            // if (typeof index == "string") {
            //     var { layerId } = await LS.getByName(this._SMLayer3DsId, index);
            // } else {
            //     var { layerId } = await LS.getByIndex(this._SMLayer3DsId, index);
            // }
            var { layerId } = await LS.getByIndex(this._SMLayer3DsId, index);
            var layer = new Layer3D();
            layer._SMLayer3DId = layerId;
            return layer;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 返回此图层集合中三维图层对象的总数。
     * @memberOf Layer3Ds
     * @returns {Promise.<Promise.count>}
     */
    async getCount() {
        try {
            var { count } = await LS.getCount(this._SMLayer3DsId);
            return count;
        } catch (e) {
            console.error(e);
        }
    }
}
