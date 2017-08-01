/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com

 **********************************************************************************/
import {NativeModules} from 'react-native';
let S = NativeModules.JSSize2D;

/**
 * @class Size2D
 * @description 存储有序双精度数对。
 */
export default class Size2D {
    /**
     * 创建一个Size2D实例
     * @param {number} w - 宽度
     * @param {number} h - 高度
     * @returns {Promise.<Size2D>}
     */
    async createObj(w,h){
        try{
            var {size2DId} = await S.createObj(w,h);
            var size2D = new Size2D();
            size2D._SMSize2DId = size2DId;
            return size2D;
        }catch (e){
            console.log(e);
        }
    }
}
