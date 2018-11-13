/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 description: 三维相机对象类;
 **********************************************************************************/
import { NativeModules } from 'react-native';
let L = NativeModules.JSLayer3DOSGBFile;
/**
 * @class Layer3DOSGBFile
 */
export default class Layer3DOSGBFile {
    /**
     * 设置指定OSGB模型ID队列的模型颜色。
     * @memberOf Layer3DOSGBFile
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
     * @memberOf Layer3DOSGBFile
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
