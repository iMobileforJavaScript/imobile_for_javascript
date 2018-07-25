/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com
 Description:数据源类
 
 **********************************************************************************/
import { NativeModules } from 'react-native';
let D = NativeModules.JSDatasource;
import Datasets from './Datasets.js';
import Dataset from './Dataset.js';
import DatasetVector from './DatasetVector.js';
import PrjCoordSys from './PrjCoordSys.js';

/**
 * @class Datasource
 * @description 该类管理投影信息、数据源与数据库的连接信息和对其中的数据集的相关操作，如通过已有数据集复制生成新的数据集等。
 * @property {number} EncodeType - 数据集存储时的压缩编码方式 NONE | BYTE | INT16 | INT24 | INT32 | LZW | SGL | DCT
 * @property {number} DatasourceEncrytionType - 数据集存储时的压缩编码方式 DEFAULT | AES
 */
export default class Datasource {
  
  async getAlias() {
    try {
      var { alias } = await D.getAlias(this._SMDatasourceId);
      
      return alias;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取数据集集合。
   * @memberOf Datasource
   * @deprecated - 已弃用，Datasets类不建议使用，后续版本即将移除此接口
   * @returns {Promise.<Datasets>}
   */
  async getDatasets() {
    console.warn("Datasource.js:getDatasets() function has been deprecated. If you want to get dataset , please call the getDataset() function");
    try {
      var { datasetsId } = await D.getDatasets(this._SMDatasourceId);
      var datasets = new Datasets();
      datasets._SMDatasetsId = datasetsId;
      
      return datasets;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 指定名称或序号来获取数据集。
   * @memberOf Datasource
   * @param {number | string} index|name - 既可以是序号，也可以是数据集名称
   * @returns {Promise.<Dataset>}
   */
  async getDataset(arg) {
    try {
      var dataset = new Dataset();
      if (typeof arg != "string") {
        var { datasetId } = await D.getDataset(this._SMDatasourceId, arg);
      } else {
        var { datasetId } = await D.getDatasetByName(this._SMDatasourceId, arg);
      }
      dataset._SMDatasetId = datasetId;
      
      return dataset;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回一个数据源中未被使用的数据集的名称。
   * @memberOf Datasource
   * @param {string} name - 待检测名称
   * @returns {Promise.<string>}
   */
  async getAvailableDatasetName(name) {
    try {
      var { datasetName } = await D.getAvailableDatasetName(this._SMDatasourceId, name);
      return datasetName;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 根据指定的矢量数据集信息来创建矢量数据集。可传入一个datasetVectorInfo类对象，或直接传入数据集名称、数据集类型和编码类型三个参数。
   * @memberOf Datasource
   * @param {object | string} datasetVectorInfo|datasetName - 数据集矢量信息对象
   * @param {number} datasetType - {@link Dataset}
   * @param {number} encodeType - 数据集存储时的压缩编码方式 NONE | BYTE | INT16 | INT24 | INT32 | LZW | SGL | DCT
   * @returns {Promise.<DatasetVector>}
   */
  async createDatasetVector(nameOrInfoObj, datasetType, encodeType) {
    try {
      if (arguments.length === 1) {
        var { datasetVectorId } = await D.createDatasetVector(this._SMDatasourceId, nameOrInfoObj.datasetVectorInfoId);
        var datasetVector = new DatasetVector();
        datasetVector._SMDatasetVectorId = datasetVectorId;
        return datasetVector;
      } else {
        var { datasetVectorId } = await D.createDatasetVectorDirectly(this._SMDatasourceId, nameOrInfoObj, datasetType, encodeType);
        var datasetVector = new DatasetVector();
        datasetVector._SMDatasetVectorId = datasetVectorId;
        return datasetVector;
      }
    } catch (e) {
      console.error(e);
    }
  }
  
  
  /**
   * 用于在相同或不同引擎数据源中复制数据集。
   * @memberOf Datasource
   * @param {object} srcDataset - 要复制的源数据集。
   * @param {string} desDatasetName - 目标数据集的名称。
   * @param {Datasource.EncodeType}encodeType - 数据集的编码方式。
   * @returns {Promise.<Dataset>}
   */
  async copyDataset(srcDataset, desDatasetName, encodeType) {
    try {
      var { datasetId } = await D.copyDataset(this._SMDatasourceId, srcDataset._SMDatasetId, desDatasetName, encodeType | 0);
      var dataset = new Dataset();
      dataset.datasetId = datasetId;
      return dataset;
    } catch (e) {
      console.error(e);
    }
  }
  
  /*
   * 修改当前数据源的密码
   * @memberOf Datasource
   * @param {number} oldPassword - 原始密码,不能为null
   * @param {number} newPassword - 新密码,不能为null
   * @param {Datasource.DatasourceEncrytionType} datasourceEncrytionType
   * @returns {Promise.<Promise.changed>} 新密码使用的加密类型
   */
  /* async changepassword(oldPassword,newPassword,datasourceEncrytionType){
   try{
   if(!oldPassword || !newPassword) throw new Error("Datasource.js:原始密码和新密码不能为空。");
   var {changed} = await D.changepassword(this._SMDatasourceId,oldPassword,newPassword, datasourceEncrytionType | 0);
   return changed;
   }catch(e){
   console.error(e);
   }
   } */
  
  /**
   * 返回数据源的投影信息。
   * @memberOf Datasource
   * @returns {Promise.<PrjCoordSys>}
   */
  async getPrjCoordSys() {
    try {
      var { prjCoordSysId } = await D.getPrjCoordSys(this._SMDatasourceId);
      var prjCoordSys = new PrjCoordSys();
      prjCoordSys._SMPrjCoordSysId = prjCoordSysId;
      return prjCoordSys;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 检查当前数据源中是否包含指定名称的数据集。
   * @memberOf Datasource
   * @param {string} datasetName - 数据集名称
   * @returns {Promise.<boolean>}
   */
  async containDataset(datasetName) {
    try {
      var { contain } = await D.containDataset(this._SMDatasourceId, datasetName);
      return contain;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 用于删除指定名称的数据集。
   * @memberOf Datasource
   * @param {string} datasetName - 数据集名称
   * @returns {Promise.<boolean>}
   */
  async deleteDataset(datasetName) {
    try {
      var { deleted } = await D.deleteDataset(this._SMDatasourceId, datasetName);
      return deleted;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回数据集集合中数据集的个数。
   * @memberOf Datasource
   * @returns {Promise.<number>}
   */
  async getDatasetCount() {
    try {
      var { count } = await D.getDatasetCount(this._SMDatasourceId);
      return count;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回数据源是否已打开
   * @returns {Promise.<Promise|*>}
   */
  async isOpened() {
    try {
      return await D.isOpened(this._SMDatasourceId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回数据源是否有改动
   * @returns {Promise.<Promise|Promise.<Promise.isModified>>}
   */
  async isModified() {
    try {
      return await D.isModified(this._SMDatasourceId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 返回数据源是否以制度方式打开
   * @returns {Promise.<Promise|Promise.<void>>}
   */
  async isReadOnly() {
    try {
      return await D.isReadOnly(this._SMDatasourceId);
    } catch (e) {
      console.error(e);
    }
  }
}

Datasource.EncodeType = {
  NONE: 0,
  BYTE: 1,
  INT16: 2,
  INT24: 3,
  INT32: 4,
  DCT: 8,
  SGL: 9,
  LZW: 11
}

Datasource.DatasourceEncrytionType = {
  DEFAULT: 0,
  AES: 1
}
