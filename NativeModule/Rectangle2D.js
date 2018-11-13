/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let R = NativeModules.JSRectangle2D;
import Point2D from './Point2D.js';

/**
 * @class Rectangle2D
 * @description 矩形类。
 */
export default class Rectangle2D {
    /**
     * 创建一个Rectangle2D矩形实例
     * @memberOf Rectangle2D
     * @param {object} point2D - 左下点，可选
     * @param {object} point2D - 右上点，可选
     * @returns {Promise.<*>}
     */
    async createObj(){
        try{
            if(arguments[0] instanceof Point2D && arguments[1] instanceof Point2D){
                console.log('create by two Point2D objects.');
                var {rectangle2DId} = await R.createObjBy2Pt(arguments[0].point2DId,arguments[1].point2DId);
                return this.returnObj(rectangle2DId);
            }else{
                console.log('create with nothing.');
                var {rectangle2DId} = await R.createObj();
                return this.returnObj(rectangle2DId);
            }
        }catch (e){
            console.error(e);
        }
    }

    returnObj(rectangle2DId){
        var rectangle2D = new Rectangle2D();
        rectangle2D._SMRectangle2DId = rectangle2DId;
        return rectangle2D;
    }
}
