/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: Feature3Ds-三维要素集合类;
 **********************************************************************************/
import { NativeModules } from 'react-native';
let G = NativeModules.JSGeometry3D;
/**
 * @class Geometry3D
 */
export default class Geometry3D {
    /**
     * 获取三维要素。
     * @memberOf Geometry3D
     * @returns {void}
     */
    async setColor(r, g, b, a) {
        try {
            await G.setColor(this._SMFeature3DsId, r, g, b, a);
        } catch (e) {
            console.error(e);
        }
    }
}
