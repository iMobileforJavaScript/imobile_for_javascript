/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: 三维相机对象类;
 **********************************************************************************/
import { NativeModules } from 'react-native';
let C = NativeModules.JSCamera;
/**
 * @class Camera
 */
export default class Camera {
    /**
     * 创建Camera对象。
     * @memberOf Camera
     * @returns {Camera}
     */
    async createObj(lon, lat, alt) {
        try {
            var { cameraId } = await C.createObj(lon, lat, alt);
            var camera = new Camera();
            camera._SMCameraId = cameraId;
            return camera;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 获取Camera的lon分量。
     * @memberOf Camera
     * @returns {number}
     */
    async getLon() {
        try {
            var { lon } = await C.getLon(this._SMCameraId);
            return lon;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 获取Camera的lat分量。
     * @memberOf Camera
     * @returns {number}
     */
    async getLat() {
        try {
            var { lat } = await C.getLat(this._SMCameraId);
            return lat;
        } catch (e) {
            console.error(e);
        }
    }

    /**
    * 获取Camera的alt分量。
    * @memberOf Camera
    * @returns {number}
    */
    async getAlt() {
        try {
            var { alt } = await C.getAlt(this._SMCameraId);
            return alt;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Camera的lon分量。
     * @memberOf Camera
     * @returns {number}
     */
    async setLon(lon) {
        try {
            await C.setLon(this._SMCameraId,lon);
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Camera的lat分量。
     * @memberOf Camera
     * @returns {number}
     */
    async setLat(lat) {
        try {
            await C.setLat(this._SMCameraId,lat);
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Camera的alt分量。
     * @memberOf Camera
     * @returns {number}
     */
    async setAlt(alt) {
        try {
            await C.setAlt(this._SMCameraId,alt);
        } catch (e) {
            console.error(e);
        }
    }

    /**
    * 获取Camera的方位角。
    * @memberOf Camera
    * @returns {number}
    */
    async getHeading() {
        try {
            var { heading } = await C.getHeading(this._SMCameraId);
            return heading;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Camera的方位角。
     * @memberOf Camera
     * @returns {number}
     */
    async setHeading(heading) {
        try {
            await C.setHeading(this._SMCameraId,heading);
        } catch (e) {
            console.error(e);
        }
    }

    /**
    * 获取Camera的俯仰角。
    * @memberOf Camera
    * @returns {number}
    */
    async getTilt() {
        try {
            var { tilt } = await C.getTilt(this._SMCameraId);
            return tilt;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 设置Camera的俯仰角。
     * @memberOf Camera
     * @returns {number}
     */
    async setTilt(tilt) {
        try {
            await C.setTilt(this._SMCameraId,tilt);
        } catch (e) {
            console.error(e);
        }
    }
}
