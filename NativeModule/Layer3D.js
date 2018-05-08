/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: Layer3D-三维图层类；
 **********************************************************************************/
import { NativeModules, Platform } from 'react-native';
let L = NativeModules.JSLayer3D;
/**
 * @class Layer3D
 */
export default class Layer3D {

    /**
     *更新三维图层。
     * @memberOf Layer3D
     * @returns {Boolean}
     */
    async updateData() {
        try {
            await L.updateData(this._SMLayer3DId);
            return true;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置图层的可见性 。
     * @memberOf Layer3D
     * @param {boolean} visable - 可见性（可选参数，通过此参数区分get／set）
     * @returns {Boolean}
     */
    async setVisable(visable) {
        try {
            var { isVisable } = await L.setVisable(this._SMLayer3DId, visable);
            return isVisable;
        } catch (e) {
            console.error(e);
        }
    }

    /**
    * 获取图层对视口的可见性 。
    * @memberOf Layer3D
    * @returns {Boolean}
    */
    async getVisable() {
        try {
            var { isVisable } = await L.getVisable(this._SMLayer3DId)
            return isVisable;
        } catch (e) {
            console.error(e);
        }
    }

    /**
    * 获取或设置图层不可见释放内存。
    * @memberOf Layer3D
    * @param {Boolean} release - 是否释放内存(可选参数，通过此参数区分get／set）
    * @returns {Boolean}
     */
    async releaseWhenInvisible(release) {
        try {
            if (arguments.length >= 1) {
                await L.setRelease(this._SMLayer3DId, release);
                var isRelease = release;
            } else {
                var { isRelease } = await L.getRelease(this._SMLayer3DId);
            }
            return isRelease;
        } catch (e) {
            console.error(e);
        }
    }
}
