/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: 三维点类;
 **********************************************************************************/
import { NativeModules } from 'react-native';
let P = NativeModules.JSPoint3D;
/**
 * @class Point3D
 */
export default class Point3D {
    /**
     * 创建Point3D对象。
     * @memberOf Point3D
     * @returns {Point3D}
     */
    async createObj(x, y, z) {
        try {
            var { pointId } = await P.createObj(x, y, z);
            var point = new Point3D();
            point._SMPoint3DId = pointId;
            return point;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 获取Point3D的X分量。
     * @memberOf Point3D
     * @returns {number}
     */
    async getX() {
        try {
            var { x } = await P.getX(this._SMPoint3DId);
            return x;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 获取Point3D的Y分量。
     * @memberOf Point3D
     * @returns {number}
     */
    async getY() {
        try {
            var { y } = await P.getY(this._SMPoint3DId);
            return y;
        } catch (e) {
            console.error(e);
        }
    }

    /**
    * 获取Point3D的Z分量。
    * @memberOf Point3D
    * @returns {number}
    */
    async getZ() {
        try {
            var { z } = await P.getZ(this._SMPoint3DId);
            return z;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Point3D的X分量。
     * @memberOf Point3D
     * @returns {number}
     */
    async setX(x) {
        try {
            await P.setX(this._SMPoint3DId,x);
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Point3D的Y分量。
     * @memberOf Point3D
     * @returns {number}
     */
    async setY(y) {
        try {
            await P.setY(this._SMPoint3DId,y);
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Point3D的Z分量。
     * @memberOf Point3D
     * @returns {number}
     */
    async setZ(z) {
        try {
            await P.setZ(this._SMPoint3DId,z);
        } catch (e) {
            console.error(e);
        }
    }
}
