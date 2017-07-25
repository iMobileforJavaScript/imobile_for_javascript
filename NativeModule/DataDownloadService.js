import {NativeModules} from 'react-native';
let DDS = NativeModules.JSDataDownloadService;
import ServiceBase from './ServiceBase.js';

/**
 * @class DataDownloadService
 */
export default class DataDownloadService extends ServiceBase{
    constructor(){
        super();
        //同步子类Id和父类Id
        Object.defineProperty(this,"_dataDownloadServiceId_",{
            get:function () {
                return this._serviceBaseID_
            },
            set:function (_dataDownloadServiceId_) {
                this._serviceBaseID_ = _dataDownloadServiceId_;
            }
        })
    }

    /**
     * 根据指定的url构造一个新的 DataDownloadService 对象。
     * @memberOf DataDownloadService
     * @param {string} url - 指定的url
     * @returns {Promise.<DataDownloadService>}
     */
    async createObj(url){
        try{
            var {_dataDownloadServiceId_} = await DDS.createObj(url);
            var dataDownloadService = new DataDownloadService();
            dataDownloadService._dataDownloadServiceId_ = _dataDownloadServiceId_;
            return dataDownloadService;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取指定的数据服务地址下对象集合。
     * @memberOf DataDownloadService
     * @param {string} fullUrl - 数据服务的地址，如：http://127.0.0.1:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
     * @param {number} fromIndex - 起始下标。
     * @param {number} toIndex - 结束下标。
     * @returns {Promise.<void>}
     */
    async download(fullUrl,fromIndex,toIndex){
        try{
            await DDS.download(this._dataDownloadServiceId_,fullUrl,fromIndex,toIndex);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 从iServer服务器上下载对象集合。
     * @memberOf DataDownloadService
     * @param serviceName - 服务名称。
     * @param datasourceName - 数据源名。
     * @param datasetName - 数据集名。
     * @param fromIndex - 起始下标。
     * @param toIndex - 结束下标。
     * @returns {Promise.<void>}
     */
    async downloadByName(serviceName,datasourceName,datasetName,fromIndex,toIndex){
        try{
            await DDS.downloadByName(this._dataDownloadServiceId_,
                serviceName,datasourceName,datasetName,fromIndex,toIndex);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取指定的数据服务地址下所有对象集合。
     * @memberOf DataDownloadService
     * @param fullUrl - 数据服务的地址，如：http://127.0.0.1:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
     * @returns {Promise.<void>}
     */
    async downloadAll(fullUrl){
        try{
            await DDS.downloadAll(this._dataDownloadServiceId_,fullUrl);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取指定的数据服务地址、数据源名称、数据集名称下所有对象集合。
     * @memberOf DataDownloadService
     * @param serviceName - 服务名称。
     * @param datasourceName - 数据源名。
     * @param datasetName - 数据集名。
     * @returns {Promise.<void>}
     */
    async downloadAllByName(serviceName,datasourceName,datasetName){
        try{
            await DDS.downloadAllByName(this._dataDownloadServiceId_,
                serviceName,datasourceName,datasetName);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 从服务器上下载一个数据集（支持点、线、面数据集），且在本地数据源中不存在与被下载的数据集同名的数据集，同时会在本地和服务器上创建一个同步属性数据集， 用于记录所下载的数据集在本地被修改的情况。同步数据集的名称为被下载的数据集名加上后缀“_Table”。如果下载失败，将调用ResponseCallback中的requestFaild（）方法；如果成功，将调用requestSuccess()方法。
     * @memberOf DataDownloadService
     * @param urlDatset - dataset在服务器上的地址。
     * @param datasource - 本地数据源。
     * @returns {Promise.<void>}
     */
    async downloadDataset(urlDatset,datasource){
        try{
            await DDS.downloadDataset(this._dataDownloadServiceId_,
                urlDatset,datasource.datasourceId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     *从服务器上更新本地数据集（支持点、线、面数据集），且要求本地存在同步数据集，服务器上存在要下载的数据集及其同步属性数据集。 如果更新失败，将调用ResponseCallback中的requestFaild（）方法；如果成功，将调用requestSuccess()方法。
     * @memberOf DataDownloadService
     * @param urlDatset - 数据集在服务器上的地址。
     * @param dataset - 本地数据集。
     * @returns {Promise.<void>}
     */
    async updateDataset(urlDatset,dataset){
        try{
            await DDS.updateDataset(this._dataDownloadServiceId_,
                urlDatset,dataset.datasetId);
        }catch(e){
            console.error(e);
        }
    }
}
