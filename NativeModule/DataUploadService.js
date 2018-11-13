/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let DUS = NativeModules.JSDataUploadService;
import ServiceBase from './ServiceBase.js';

/**
 * @class DataUploadService
 * @description 数据上传类，用于将本地数据上传到iServer服务器。
 */
export default class DataUploadService extends ServiceBase{

    constructor(){
        super();
        Object.defineProperty(this,"_SMDataUploadServiceId",{
            get:function () {
                return this._SMServiceBaseId
            },
            set:function (_SMDataUploadServiceId) {
                this._SMServiceBaseId = _SMDataUploadServiceId;
            }
        })
    }

    /**
     * 指定url地址创建一个DataUploadService实例
     * @memberOf DataUploadService
     * @param {string} url - 指定的url
     * @returns {Promise.<DataUploadService>}
     */
    async createObj(url){
        try{
            var {_dataUploadServiceId_} = await DUS.createObj(url);
            var datauploadService = new DataUploadService();
            datauploadService._SMDataUploadServiceId = _dataUploadServiceId_;
            return datauploadService;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 根据指定的数据集名称和数据类型添加数据集。
     * @memberOf DataUploadService
     * @param {string} fullUrl - 服务名称。
     * @param {string} datasetName - 数据集名。
     * @param {Dataset.Type} datasetType - 数据类型。
     * @returns {Promise.<void>}
     */
    async addDataset(fullUrl,datasetName,datasetType){
        try{
            await DUS.addDataset(this._SMDataUploadServiceId,fullUrl,datasetName,datasetType);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 通过复制指定数据源中的指定数据集向服务中添加数据集。
     * @memberOf DataUploadService
     * @param {string} serviceName - 服务名称。
     * @param {string} datasourceName - 数据源名。
     * @param {string} destDatasetName - 目标数据集名。
     * @param {string} srcDatasourceName - 源数据源名。
     * @param {string} srcDatasetName - 源数据集名。
     * @returns {Promise.<void>}
     */
    async cloneDataset(serviceName,datasourceName,destDatasetName,srcDatasourceName,srcDatasetName){
        try{
            await DUS.cloneDataset(this._SMDataUploadServiceId,serviceName,
                datasourceName,destDatasetName,srcDatasourceName,srcDatasetName);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 向指定的数据服务地址添加对象。
     * @memberOf DataUploadService
     * @param {string} fullUrl - 指定的数据服务地址，如：http://192.168.120.1:8090/iserver/services/data-world/rest/data/datasources/World/datasets/Lakes。
     * @param {object} feature - 待添加对象。
     * @returns {Promise.<void>}
     */
    async addFeature(fullUrl,feature){
        try{
            await DUS.addFeature(this._SMDataUploadServiceId,fullUrl,feature._SMFeatureId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 向iServer服务器中添加对象。
     * @memberOf DataUploadService
     * @param {string} serviceName - 服务名称。
     * @param {string} datasourceName - 数据源名。
     * @param {string} datasetName - 数据集名。
     * @param {object} feature - 添加对象。
     * @returns {Promise.<void>}
     */
    async addFeatureByName(serviceName,datasourceName,datasetName,feature){
        try{
            await DUS.addFeatureByName(this._SMDataUploadServiceId,serviceName,datasourceName,
                datasetName,feature._SMFeatureId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 根据指定的对象ID数组删除iServer服务器中的对象。
     * @memberOf DataUploadService
     * @param {string} fullUrl - 指定数据服务地址，如:http://192.168.120.1:8090/iserver/services/data-world/rest/data/datasources/World/datasets/Lakes。
     * @param {object} featureIDs - 对象ID数组。
     * @returns {Promise.<void>}
     */
    async deleteFeature(fullUrl,featureIDs){
        try{
            await DUS.deleteFeature(this._SMDataUploadServiceId,fullUrl,featureIDs);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 根据指定的对象ID数组删除iServer服务器中的对象。
     * @memberOf DataUploadService
     * @param {string} serviceName - 服务名称。
     * @param {string} datasourceName - 数据源名。
     * @param {string} datasetName - 数据集名。
     * @param {array} featureIDs - 对象ID数组。
     * @returns {Promise.<void>}
     */
    async deleteFeatureByName(serviceName,datasourceName,datasetName,featureIDs){
        try{
            await DUS.deleteFeatureByName(this._SMDataUploadServiceId,serviceName,
                datasourceName,datasetName,featureIDs);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 根据指定的ID修改对象。
     * @memberOf DataUploadService
     * @param {string} fullUrl - 要修改的对象地址，如：http://192.168.120.1:8090/iserver/services/data-world/rest/data/datasources/World/datasets/Lakes。
     * @param {number} featureID - 要修改的对象ID。
     * @param {object} feature - 修改的值。
     * @returns {Promise.<void>}
     */
    async modifyFeature(fullUrl,featureID,feature){
        try{
            await DUS.modifyFeature(this._SMDataUploadServiceId,fullUrl,featureID,feature._SMFeatureId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 根据指定的ID和数据名称修改对象。
     * @memberOf DataUploadService
     * @param {string} serviceName - 服务名称。
     * @param {string} datasourceName - 数据源名。
     * @param {string} datasetName - 数据集名。
     * @param {number} featureID - 要修改的对象ID。
     * @param {object} feature - 结果对象。
     * @returns {Promise.<void>}
     */
    async modifyFeatureByName(serviceName,datasourceName,datasetName,featureID,feature){
        try{
            await DUS.modifyFeatureByName(this._SMDataUploadServiceId,serviceName,
                datasourceName,datasetName,featureID,feature._SMFeatureId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 提交
     * @description 将本地数据集中修改、删除、新增的数据提交到服务器上对应的数据集中。提交时要求本地和服务器上都存在该数据集及其对应的属性数据集（属性数据集用于记录被修改和被删除的记录）。 同时本地数据集的版本不得高于服务器上的版本（即本地的Max[SmUserID]不大于服务器上的Max[SMID]），否则不能提交，需要先进行更新。目前数据集的类型支持点、线、面数据集。 如果提交失败，将调用ResponseCallback中的requestFaild（）方法；如果成功，将调用requestSuccess()方法。
     * @memberOf DataUploadService
     * @param {string} urlDataset  - dataset在服务器上的地址。
     * @param {objecg} dataset - 本地数据集，可以使点、线、面数据集。
     * @returns {Promise.<void>}
     */
    async commitDataset(urlDataset,dataset){
        try{
            await DUS.commitDataset(this._SMDataUploadServiceId,fullUrl,dataset._SMDatasetId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 删除数据集
     * @memberOf DataUploadService
     * @param {string} fullUrl - 要删除的数据集地址，如：http://192.168.120.1:8090/iserver/services/data-world/rest/data/datasources/World/datasets/Lakes。
     * @returns {Promise.<void>}
     */
    async deleteDataset(fullUrl){
        try{
            await DUS.deleteDataset(this._SMDataUploadServiceId,fullUrl);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 删除数据集。
     * @memberOf DataUploadService
     * @param {string} serviceName - 服务名称。
     * @param {string} datasourceName - 数据源名。
     * @param {string} datasetName - 源数据集名。
     * @returns {Promise.<void>}
     */
    async deleteDatasetByName(serviceName,datasourceName,datasetName){
        try{
            await DUS.deleteDatasetByName(this._SMDataUploadServiceId,serviceName,datasourceName,datasetName);
        }catch(e){
            console.error(e);
        }
    }
}
