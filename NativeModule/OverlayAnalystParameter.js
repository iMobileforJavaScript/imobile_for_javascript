/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let OAP = NativeModules.JSOverlayAnalystParameter;

/**
 * @class OverlayAnalystParameter
 * 叠加分析参数类。
 * 该类主要提供进行叠加分析时，输出结果数据集的字段选择。在矢量叠加分析中，至少涉及到三个数据集，其中一个数据集的类型可以是点、线、面等，被称作输入数据集（在SuperMap GIS 中称作第一数据集）；另一个数据集是面数据集被称作叠加数据集（在SuperMap GIS 中称作第二数据集）；还有一个数据集就是叠加结果数据集 ，包含叠加后数据的几何信息和属性信息。叠加结果数据集中的属性信息来自于第一数据集和第二数据集的属性表，在进行叠加分析的时候，用户可以根据自己的需要在这两个数据集的属性表中选择需要保留的属性字段。
 */
export default class OverlayAnalystParameter {
    /**
     * 创建一个OverlayAnalystParameter对象
     * @memberOf OverlayAnalystParameter
     * @returns {Promise.<object>}
     */
    async createObj(){
        try{
            var {overlayAnalystParameterId} = await OAP.createObj();
            var overlayAnalystParameter = new OverlayAnalystParameter();
            overlayAnalystParameter._SMOverlayAnalystParameterId = overlayAnalystParameterId;
            return overlayAnalystParameter;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置叠加分析的容限值。
     * @memberOf OverlayAnalystParameter
     * @param {number} rate - 叠加分析的容限值。
     * @returns {Promise.<void>}
     */
    async setTolerance(rate){
        try{
            await OAP.setTolerance(this._SMOverlayAnalystParameterId,rate);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回叠加分析的容限值。
     * @memberOf OverlayAnalystParameter
     * @returns {Promise.<void>}
     */
    async getTolerance(){
        try{
            var {tolerance} = await OAP.getTolerance(this._SMOverlayAnalystParameterId);
            return tolerance;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
     * @memberOf OverlayAnalystParameter
     * @returns {Promise.<array<string>>}
     */
    async getOperationRetainedFields(){
        try{
            var {fields} = await OAP.getOperationRetainedFields(this._SMOverlayAnalystParameterId);
            return fields;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
     * @memberOf OverlayAnalystParameter
     * @param fields - 进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
     * @returns {Promise.<void>}
     */
    async setOperationRetainedFields(fields){
        try{
            await OAP.setOperationRetainedFields(this._SMOverlayAnalystParameterId,fields);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回进行叠加分析的第一数据集或记录集中需要保留的字段名称集合。
     * @memberOf OverlayAnalystParameter
     * @returns {Promise.<Promise.fields>}
     */
    async getSourceRetainedFields(){
        try{
            var {fields} = await OAP.getSourceRetainedFields(this._SMOverlayAnalystParameterId);
            return fields;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
     * @memberOf OverlayAnalystParameter
     * @param fields - 进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
     * @returns {Promise.<void>}
     */
    async setSourceRetainedFields(fields){
        try{
            await OAP.setSourceRetainedFields(this._SMOverlayAnalystParameterId,fields);
        }catch(e){
            console.error(e);
        }
    }
}
