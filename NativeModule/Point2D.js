/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let X = NativeModules.JSPoint2D;

/**
 * @class Point2D 
 * @description 点类。点类的的实例为点对象，用于表示坐标值为双精度的点对象，即其坐标值的范围为±5.0*1e-324到±1.7*1e308，有效位为15-16位。
 */
export default class Point2D {
    /**
     * 构造一个新的 Point2D 对象。
     * @memberOf Point2D
     * @returns {Promise.<Point2D>}
     */
    async createObj(){
        try{
            if(typeof arguments[0] == 'number' && typeof arguments[1] == 'number'){
                var {point2DId} = await X.createObjByXY(arguments[0],arguments[1]);
                var point2D = new Point2D();
                point2D._SMPoint2DId = point2DId;
                return point2D;
            }else{
                var {point2DId} = await X.createObj();
                var point2D = new Point2D();
                point2D._SMPoint2DId = point2DId;
                return point2D;
            }
        }catch (e){
            console.error(e);
        }
    }
}
