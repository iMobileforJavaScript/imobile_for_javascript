/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 ref:DatasetVector
 **********************************************************************************/
import {NativeModules} from 'react-native';
let BA = NativeModules.JSBufferAnalyst;

/**
 * @class BufferAnalyst
 * @description 缓冲区分析类。该类用于为点、线、面数据集（或记录集）创建缓冲区，包括单边缓冲区、多重缓冲区和线单边多重缓冲区。
 **/
export default class BufferAnalyst {
    
    /**
     * 创建矢量数据集缓冲区
     * @memberOf BufferAnalyst
     * @param {Dataset} sourceDataSet - 源矢量数据集
     * @param {Dataset} sourceDataSet - 用于存储缓冲区分析结果的数据集
     * @param {BufferAnalystParameter} bufferAnalystParam - 缓冲区分析参数对象
     * @param {boolean} isUnion - 是否合并缓冲区
     * @param {boolean} isAttributeRetained - 是否保留进行缓冲区分析的对象的字段属性
     * @returns {Promise.<boolean>}
     */
    async createBuffer(sourceDataSet,resultDataSet,bufferAnalystParam,isUnion,isAttributeRetained){
        try{
            var {isCreate} = await BA.createBuffer(sourceDataSet._SMDatasetVectorId,resultDataSet._SMDatasetVectorId,bufferAnalystParam._SMBufferAnalystParameterId,isUnion,isAttributeRetained);
            
            return isCreate;
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 创建矢量数据集单边多重缓冲区
     * @memberOf BufferAnalyst
     * @param {Dataset} sourceDataSet - 源矢量数据集
     * @param {Dataset} sourceDataSet - 用于存储缓冲区分析结果的数据集
     * @param {array} arrBufferRadius - 指定的多重缓冲区半径列表
     * @param {number} bufferRadiusUnit - 指定的缓冲区半径单位
     * @param {number} semicircleSegment - 指定的弧短拟合数
     * @param {boolean} isLeft - 是否生成左缓冲区
     * @param {boolean} isUnion - 是否合并缓冲区
     * @param {boolean} isAttributeRetained - 是否保留进行缓冲区分析的对象的字段属性
     * @param {boolean} isRing - 是否生成环装缓冲区
     * @returns {Promise.<boolean>}
     */
    async createLineOneSideMultiBuffer(sourceDataSet,resultDataSet,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isLeft,isUnion,isAttributeRetained,isRing){
        try{
            var {isCreate} = await BA.createLineOneSideMultiBuffer(sourceDataSet._SMDatasetVectorId,resultDataSet._SMDatasetVectorId,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isLeft,isUnion,isAttributeRetained,isRing);
            
            return isCreate;
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 创建矢量数据集多重缓冲区
     * @memberOf BufferAnalyst
     * @param {Dataset} sourceDataSet - 源矢量数据集
     * @param {Dataset} sourceDataSet - 用于存储缓冲区分析结果的数据集
     * @param {array} arrBufferRadius - 指定的多重缓冲区半径列表
     * @param {number} bufferRadiusUnit - 指定的缓冲区半径单位
     * @param {number} semicircleSegment - 指定的弧短拟合数
     * @param {boolean} isUnion - 是否合并缓冲区
     * @param {boolean} isAttributeRetained - 是否保留进行缓冲区分析的对象的字段属性
     * @param {boolean} isRing - 是否生成环装缓冲区
     * @returns {Promise.<boolean>}
     */
    async createMultiBuffer(sourceDataSet,resultDataSet,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isUnion,isAttributeRetained,isRing){
        try{
            var {isCreate} = await BA.createMultiBuffer(sourceDataSet._SMDatasetVectorId,resultDataSet._SMDatasetVectorId,arrBufferRadius,bufferRadiusUnit,semicircleSegment,isUnion,isAttributeRetained,isRing);
            
            return isCreate;
        }catch (e){
            console.error(e);
        }
    }
}
