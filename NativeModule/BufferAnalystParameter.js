/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 ref:none
 description:涉及枚举。
 **********************************************************************************/
import {NativeModules} from 'react-native';
let BAP = NativeModules.JSBufferAnalystParameter;

/**
 * @class BufferAnalystParameter
 * @description 缓冲区分析参数类，用于为缓冲区分析提供必要的参数信息。
 **/
export default class BufferAnalystParameter {
    static ENDTYPE = {
        ROUND:1,
        FLAT:2,
    }
    
    static RADIUSUNIT = {
        MiliMeter:10,
        CentiMeter:100,
        DeciMeter:1000,
        Meter:10000,
        KiloMeter:10000000,
        Yard:9144,
        Inch:254,
        Foot:3048,
        Mile:16090000,
    }

    /**
     * 构造BufferAnalystParameter对象
     * @memberOf BufferAnalystParameter
     * @returns {Promise.<BufferAnalystParameter>}
     */
    async createObj(){
        try{
            var {bufferAnalystParameterId} = await BAP.createObj();
            var bufferAnalystParameter = new BufferAnalystParameter();
            bufferAnalystParameter._SMBufferAnalystParameterId = bufferAnalystParameterId;
            return bufferAnalystParameter;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置缓冲区端点类型。
     * @memberOf BufferAnalystParameter
     * @param {number} bufferEndType - 缓冲区端点类型
     * @returns {Promise.<void>}
     */
    async setEndType(bufferEndType){
        try{
            await BAP.setEndType(this._SMBufferAnalystParameterId,bufferEndType);
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 获取缓冲区端点类型。
     * @memberOf BufferAnalystParameter
     * @returns {Promise.<number>}
     */
    async getEndType(){
        try{
            var {EndType} = await BAP.getEndType(this._SMBufferAnalystParameterId);
            return EndType;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置左缓冲区的距离。
     * @memberOf BufferAnalystParameter
     * @param {number | string} distance - 左缓冲区的距离
     * @returns {Promise.<void>}
     */
    async setLeftDistance(distance){
        try{
            if(typeof distance == 'number'){
                await BAP.setLeftDistance(this._SMBufferAnalystParameterId,distance);
            }else{
                await BAP.setLeftDistanceByStr(this._SMBufferAnalystParameterId,distance);
            }
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 获取左缓冲区的距离。
     * @memberOf BufferAnalystParameter
     * @returns {Promise.<string>}
     */
    async getLeftDistance(){
        try{
            var {leftDistance} = await BAP.getLeftDistance(this._SMBufferAnalystParameterId);
            return leftDistance;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 设置右缓冲区的距离。
     * @memberOf BufferAnalystParameter
     * @param {number | string} distance - 左缓冲区的距离
     * @returns {Promise.<void>}
     */
    async setRightDistance(distance){
        try{
            if(typeof distance == 'number'){
                await BAP.setRightDistance(this._SMBufferAnalystParameterId,distance);
            }else{
                await BAP.setRightDistanceByStr(this._SMBufferAnalystParameterId,distance);
            }
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 获取右缓冲区的距离。
     * @memberOf BufferAnalystParameter
     * @returns {Promise.<string>}
     */
    async getRightDistance(){
        try{
            var {rightDistance} = await BAP.getRightDistance(this._SMBufferAnalystParameterId);
            return rightDistance;
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 设置缓冲区分析的半径单位。
     * @memberOf BufferAnalystParameter
     * @param {number} radiusUnit - 缓冲区分析的半径单位
     * @returns {Promise.<void>}
     */
    async setRadiusUnit(radiusUnit){
        try{
            await BAP.setRadiusUnit(this._SMBufferAnalystParameterId,radiusUnit);
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 获取缓冲区分析的半径单位。
     * @memberOf BufferAnalystParameter
     * @returns {Promise.<number>}
     */
    async getRadiusUnit(){
        try{
            var {radiusUnit} = await BAP.getRadiusUnit(this._SMBufferAnalystParameterId);
            return radiusUnit;
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 设置半圆弧线段个数，即用多少个线段来模拟一个半圆。
     * @memberOf BufferAnalystParameter
     * @param {number} segment - 半圆弧线段个数
     * @returns {Promise.<void>}
     */
    async setSemicircleLineSegment(segment){
        try{
            await BAP.setSemicircleLineSegment(this._SMBufferAnalystParameterId,segment);
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 获取半圆弧线段个数，即用多少个线段来模拟一个半圆。
     * @memberOf BufferAnalystParameter
     * @returns {Promise.<number>}
     */
    async getSemicircleLineSegment(){
        try{
            var {segment} = await BAP.getSemicircleLineSegment(this._SMBufferAnalystParameterId);
            return segment;
        }catch (e){
            console.error(e);
        }
    }
}
