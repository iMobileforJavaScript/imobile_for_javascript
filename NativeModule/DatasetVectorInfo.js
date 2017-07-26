/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let DVI = NativeModules.JSDatasetVectorInfo;

/**
 * @class DatasetVectorInfo
 * @description 矢量数据集信息类。
   包括了矢量数据集的信息，如矢量数据集的名称，数据集的类型。
 */
export default class DatasetVectorInfo {

    /**
     * 创建DatasetVectorInfo实例
     * @param name - 数据集的名称
     * @param type - 数据集的类型
     * @returns {Promise.<DatasetVectorInfo>}
     */
    async createObjByNameType(name,type){
        try{
            var {datasetVectorInfoId} = await DVI.createObjByNameType(name,type);
            var datasetVectorInfo = new DatasetVectorInfo();
            datasetVectorInfo.datasetVectorInfoId = datasetVectorInfoId;
            return datasetVectorInfo;
        }catch (e){
            console.error(e);
        }
    }
}
