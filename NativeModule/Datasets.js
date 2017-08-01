/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com
 Description: 该类作为辅助类，不对外开放，后期可能考虑移除。
 **********************************************************************************/
import {NativeModules} from 'react-native';
let D = NativeModules.JSDatasets;
import Dataset from './Dataset.js';
import DatasetVector from './DatasetVector.js';
import Recordset from './Recordset.js';

/**
 * @class Datasets
 * @deprecated
 * @description 数据集集合类。提供对数据集的管理功能，如创建、删除、重命名等操作。
 */
export default class Datasets{
    
    /**
     * 返回指定序号的数据集。
     * @memberOf Datasets
     * @param {number} index - 指定数据集的序号
     * @returns {Promise.<Dataset>}
     */
    async get(index){
        this._drepecated();
        try{
            var dataset = new Dataset();
            if(typeof index != "string"){
                var {datasetId} = await D.get(this._SMDatasetsId,index);
            }else{
                var {datasetId} = await D.getByName(this._SMDatasetsId,index);
            }
            dataset._SMDatasetId = datasetId;

            return dataset;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 返回一个数据源中未被使用的数据集的名称。
     * @memberOf Datasets
     * @param {string} name - 数据集名称
     * @returns {Promise.<string>}
     */
    async getAvailableDatasetName(name){
        this._drepecated();
        try{
            var {datasetName} = await D.getAvailableDatasetName(this._SMDatasetsId,name);
            return datasetName;
        }catch(e){
            console.error(e);
        }
    }

    
    /**
     * 根据指定的矢量数据集信息来创建矢量数据集。
     * @memberOf Datasets
     * @param {DatasetVectorInfo} datasetVectorInfo - 矢量数据集信息
     * @returns {Promise.<DatasetVector>}
     */
    async create(datasetVectorInfo){
        this._drepecated();
        try{
            var {datasetVectorId} = await D.create(this._SMDatasetsId,datasetVectorInfo._SMDatasetVectorInfoId);
            var datasetVector = new DatasetVector();
            datasetVector._SMDatasetVectorId = datasetVectorId;
            return datasetVector;
        }catch(e){
            console.error(e);
        }
    }

    _drepecated(){
        console.warn("Datasets.js:This class has been deprecated. " +
            "All its implements has been migrated to the Datasource class." +
            "Relevant modifications refer to the API documents please");
    }
}
