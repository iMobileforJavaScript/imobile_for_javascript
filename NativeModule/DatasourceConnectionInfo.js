/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import { NativeModules } from 'react-native';
let DCI = NativeModules.JSDatasourceConnectionInfo;

/**
 * @class DatasourceConnectionInfo
 * @description 数据源连接信息类。
 */
export default class DatasourceConnectionInfo {
  /**
   * 创建一个DatasourceConnectionInfo实例
   * @memberOf DatasourceConnectionInfo
   * @returns {Promise.<DatasourceConnectionInfo>}
   */
  async createObj() {
    try {
      var { datasourceConnectionInfoId } = await DCI.createObj();
      var datasourceConnectionInfo = new DatasourceConnectionInfo();
      datasourceConnectionInfo._SMDatasourceConnectionInfoId = datasourceConnectionInfoId;
      return datasourceConnectionInfo;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置数据库服务器名或文件名。
   * @description 对于 UDB 文件，为其文件的名称，其中包括路径名称和文件的后缀名。特别地，此处的路径为绝对路径。
   * @memberOf DatasourceConnectionInfo
   * @param {string} url - 数据库服务器名或文件名。
   * @returns {Promise.<void>}
   */
  async setServer(url) {
    try {
      await DCI.setServer(this._SMDatasourceConnectionInfoId, url);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置数据源连接的引擎类型。
   * @description 对不同类型的空间数据源，需要不同的空间数据库引擎来存储和管理，对文件型数据源，即 UDB 数据源，需要 SDX+ for UDB，引擎类型为 UDB。目前版本支持的引擎类型包括 UDB 引擎（UDB），影像只读引擎（IMAGEPLUGINS）。
   * @memberOf DatasourceConnectionInfo
   * @param {string} engineType - 数据源连接的引擎类型。BaiDu，BingMaps，GoogleMaps，OGC，OpenGLCache，OpenStreetMaps，Rest，SuperMapCloud，UDB
   * @returns {Promise.<void>}
   */
  async setEngineType(engineType) {
    try {
      await DCI.setEngineType(this._SMDatasourceConnectionInfoId, engineType);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 设置数据源别名
   * @memberOf DatasourceConnectionInfo
   * @param {string} alias - 别名
   * @returns {Promise.<void>}
   */
  async setAlias(alias) {
    try {
      await DCI.setAlias(this._SMDatasourceConnectionInfoId, alias);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取数据源别名
   * @returns {Promise}
   */
  async getAlias() {
    try {
      return await DCI.getAlias(this._SMDatasourceConnectionInfoId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取数据库服务器名或文件名
   * @returns {Promise}
   */
  async getServer() {
    try {
      return await DCI.getServer(this._SMDatasourceConnectionInfoId);
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 获取返回数据源连接的引擎类型
   * @returns {Promise}
   */
  async getEngineType() {
    try {
      return await DCI.getEngineType(this._SMDatasourceConnectionInfoId);
    } catch (e) {
      console.error(e);
    }
  }
}
