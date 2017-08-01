/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 Description:该类已经被废弃，计划下个大版本进行移除
 **********************************************************************************/
import { NativeModules } from 'react-native';
let P = NativeModules.JSPoint;

/**
 * @class Point
 * @deprecated
 * @description 像素点类。用于标示移动设备屏幕的像素点。（该类已经被废弃，计划下个大版本进行移除）
 */
export default class Point{
    /**
     * 创建一个Point对象
     * @param x - 像素坐标 x 的值
     * @param y - 像素坐标 y 的值
     * @returns {Promise.<Point>}
     */
    async createObj(x,y){
        try{
            var {pointId} = await P.createObj(x,y);
            var point = new Point();
            point._SMPointId = pointId;
            return point;
        }catch (e){
            console.error(e);
        }
    }
}
