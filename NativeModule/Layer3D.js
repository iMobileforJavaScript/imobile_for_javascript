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
     * 获取Layer3D名称。
     * @memberOf Layer3D
     * @returns {Boolean}
     */
    async getName() {
        try {
            var { layer3DName } = await L.getName(this._SMLayer3DId);
            return layer3DName;
        } catch (e) {
            console.error(e);
        }
    }

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

    /**
     * 返回设置颜色的对象个数。
     * @memberOf Layer3D
     * @returns {number}
     */
    async getObjectsColorCount() {
        try {
            let { count } = await L.getObjectsColorCount(this._SMLayer3DId);
            return count;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置指定OSGB模型ID队列的模型颜色。
     * @memberOf Layer3D
     * @returns {void}
     */
    async setObjectsColor(index, r, g, b, a) {
        try {
            await L.setObjectsColor(this._SMLayer3DId, index, r, g, b, a);
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置指定OSGB模型ID队列的模型是否可见。
     * @memberOf Layer3D
     * @returns {number}
     */
    async setObjectsVisible(index,visable) {
        try {
            var { lon } = await L.setObjectsVisible(this._SMLayer3DId,index,visable);
            return lon;
        } catch (e) {
            console.error(e);
        }
    }
}
