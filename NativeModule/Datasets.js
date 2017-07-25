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
 */
export default class Datasets{
    async get(index){
        this._drepecated();
        try{
            var dataset = new Dataset();
            if(typeof index != "string"){
                var {datasetId} = await D.get(this.datasetsId,index);
            }else{
                var {datasetId} = await D.getByName(this.datasetsId,index);
            }
            dataset.datasetId = datasetId;

            return dataset;
        }catch(e){
            console.error(e);
        }
    }

    async getAvailableDatasetName(name){
        this._drepecated();
        try{
            var {datasetName} = await D.getAvailableDatasetName(this.datasetsId,name);
            return datasetName;
        }catch(e){
            console.error(e);
        }
    }

    async create(datasetVectorInfo){
        this._drepecated();
        try{
            var {datasetVectorId} = await D.create(this.datasetsId,datasetVectorInfo.datasetVectorInfoId);
            var datasetVector = new DatasetVector();
            datasetVector.datasetVectorId = datasetVectorId;
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
