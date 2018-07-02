/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let OA = NativeModules.JSOverlayAnalyst;

/**
 * @Class OverlayAnalyst
 * @description 叠加分析类（静态类）
 * 该类用于对输入的两个数据集或记录集之间进行各种叠加分析运算，如裁剪（clip）、擦除（erase）、合并（union）、同一（identity）、对称差（xOR）和更新（update）。
 */
export default class OverlayAnalyst {
    /**
     * 对矢量数据集进行裁剪，将被裁减数据集（第一个数据集）中不在裁剪数据集（第二个数据集）内的对象裁剪并删除。
     * @memberOf OverlayAnalyst
     * @param {object} datasetVector - 被裁减的数据集，也称第一数据集。该数据集的类型可以是点、线和面。
     * @param {object} clipDatasetVector - 用于裁剪的数据集，也称第二数据集。该数据集类型必须是面。
     * @param {object} resultDatasetVector - 存放裁剪结果的数据集。
     * @param {object} paramter - 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。此处该对象设置无效。
     * @returns {Promise.<boolean>}
     */
    async clip(datasetVector,clipDatasetVector,resultDatasetVector,paramter){
        try{
            var {clipped} = await OA.clip(datasetVector._SMDatasetVectorId,clipDatasetVector._SMDatasetVectorId,
                resultDatasetVector._SMDatasetVectorId,paramter._SMOverlayAnalystParameterId);
            return clipped;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 用于对数据集进行擦除方式的叠加分析，将第一个数据集中包含在第二个数据集内的对象裁剪并删除。
     * @memberOf OverlayAnalyst
     * @param {object} datasetVector - 被擦除的数据集，也称第一数据集。该数据集类型为点、线和面类型。
     * @param {object} eraseDatasetVector - 用于擦除的数据集，也称第二数据集。该数据集类型必须是面数据集类型。
     * @param {object} resultDatasetVector - 存放分析结果的数据集。
     * @param {object} paramter - 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
     * @returns {Promise.<boolean>}
     */
    async erase(datasetVector,eraseDatasetVector,resultDatasetVector,paramter){
        try{
            var {erased} = await OA.erase(datasetVector._SMDatasetVectorId,eraseDatasetVector._SMDatasetVectorId,
                resultDatasetVector._SMDatasetVectorId,paramter._SMOverlayAnalystParameterId);
            return erased;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 用于对数据集进行同一方式的叠加分析，结果数据集中保留被同一运算的数据集的全部对象和被同一运算的数据集与用来进行同一运算的数据集相交的对象。
     * @memberOf OverlayAnalyst
     * @param datasetVector - 被同一运算的数据集，可以是点、线、面类型。
     * @param identityDatasetVector - 用来进行同一运算的数据集，必须为面类型。
     * @param resultDatasetVector - 存放分析结果的数据集。
     * @param paramter - 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
     * @returns {Promise.<boolean>}
     */
    async identity(datasetVector,identityDatasetVector,resultDatasetVector,paramter){
        try{
            var {identified} = await OA.identity(datasetVector._SMDatasetVectorId,identityDatasetVector._SMDatasetVectorId,
                resultDatasetVector._SMDatasetVectorId,paramter._SMOverlayAnalystParameterId);
            return identified;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 进行相交方式的叠加分析，将被相交叠加分析的数据集不包含在用来相交叠加分析的数据集中的对象切割并删除。即两个数据集中重叠的部分将被输出到结果数据集中，其余部分将被排除。
     * @memberOf OverlayAnalyst
     * @param datasetVector - 被相交叠加分析的数据集，该数据集的类型可以是点、线、面数据集。
     * @param intersectDatasetVector - 用来相交叠加分析的数据集，该数据集必须是面数据集。
     * @param resultDatasetVector - 存放分析结果的数据集。
     * @param paramter - 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
     * @returns {Promise.<boolean>}
     */
    async intersect(datasetVector,intersectDatasetVector,resultDatasetVector,paramter){
        try{
            var {intersected} = await OA.intersect(datasetVector._SMDatasetVectorId,intersectDatasetVector._SMDatasetVectorId,
                resultDatasetVector._SMDatasetVectorId,paramter._SMOverlayAnalystParameterId);
            return intersected;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 用于对两个面数据集进行合并方式的叠加分析，结果数据集中保存被合并叠加分析的数据集和用于合并叠加分析的数据集中的全部对象，并且对相交部分进行求交和分割运算。
     * @memberOf OverlayAnalyst
     * @param datasetVector - 被合并叠加分析的数据集，必须是面数据集类型。
     * @param unionDatasetVector - 用于合并叠加分析的数据集，必须是面数据集类型。
     * @param resultDatasetVector - 存放分析结果的数据集。
     * @param paramter - 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
     * @returns {Promise.<boolean>}
     */
    async union(datasetVector,unionDatasetVector,resultDatasetVector,paramter){
        try{
            var {unioned} = await OA.union(datasetVector._SMDatasetVectorId,unionDatasetVector._SMDatasetVectorId,
                resultDatasetVector._SMDatasetVectorId,paramter._SMOverlayAnalystParameterId);
            return unioned;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 用于对两个面数据集进行更新方式的叠加分析，更新运算时用用于更新的数据集替换与被更新数据集重合的部分，是一个先擦除后粘贴的过程。
     * 用于更新叠加分析的数据集、被更新叠加分析的数据集以及结果数据集的地理坐标系必须一致。
     * 第一数据集与第二数据集的类型都必须是面数据集。结果数据集中保留了更新数据集的几何形状和属性信息。
     * @memberOf OverlayAnalyst
     * @param datasetVector - 被更新叠加分析的数据集，必须是面类型。
     * @param updateDatasetVector - 用于更新叠加分析的数据集，必须是面数据集。
     * @param resultDatasetVector - 存放分析结果的数据集。
     * @param paramter - 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
     * @returns {Promise.<boolean>}
     */
    async update(datasetVector,updateDatasetVector,resultDatasetVector,paramter){
        try{
            var {updated} = await OA.update(datasetVector._SMDatasetVectorId,updateDatasetVector._SMDatasetVectorId,
                resultDatasetVector._SMDatasetVectorId,paramter._SMOverlayAnalystParameterId);
            return updated;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 对两个面数据集进行对称差运算。即交集取反运算。
     * 用于对称差分析的数据集、被对称差分析的数据集以及结果数据集的地理坐标系必须一致。
     * 对称差运算是两个数据集的异或运算。操作结果是，对于每一个面对象，去掉其与另一个数据集中的几何对象相交的部分，而保留剩下的部分。对称差运算的输出结果的属性表包含两个输入数据集的非系统属性字段。
     * @memberOf OverlayAnalyst
     * @param datasetVector - 被对称差分析的原数据集，必须是面数据集。
     * @param xORDatasetVector - 用于对称差分析的数据集，必须是面数据集。
     * @param resultDatasetVector - 存放分析结果的数据集
     * @param paramter - 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
     * @returns {Promise.<boolean>}
     */
    async xOR(datasetVector,xORDatasetVector,resultDatasetVector,paramter){
        try{
            var {finished} = await OA.xOR(datasetVector._SMDatasetVectorId,xORDatasetVector._SMDatasetVectorId,
                resultDatasetVector._SMDatasetVectorId,paramter._SMOverlayAnalystParameterId);
            return finished;
        }catch(e){
            console.error(e);
        }
    }
}
