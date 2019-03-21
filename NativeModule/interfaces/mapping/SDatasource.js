import { NativeModules, Platform } from 'react-native'
const SDatasource = NativeModules.SDatasource

/**
 *
 * @param info
     "alias"
     "engineType"
     "server"
     "driver"
     "user"
     "readOnly"
     "password"
     "webCoordinate"
     "webVersion"
     "webFormat"
     "webVisibleLayers"
     "webExtendParam"
 * @returns {Promise.<Datasource>}
 */
function createDatasource(info = {}) {
  try {
    return SDatasource.createDatasource(info)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 打开数据源
 * @param info
     "alias"
     "engineType"
     "server"
     "driver"
     "user"
     "readOnly"
     "password"
     "webCoordinate"
     "webVersion"
     "webFormat"
     "webVisibleLayers"
     "webExtendParam"
 * @returns {*|Promise.<void>|Promise.<datasource>}
 */
function openDatasource(info = {}) {
  try {
    return SDatasource.openDatasource(info)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 重命名数据源
 * @param oldName
 * @param newName
 * @returns {Promise.<void>|Promise}
 */
function renameDatasource(oldName = '', newName = '') {
  try {
    if (!oldName || !newName) return
    return SDatasource.renameDatasource(oldName, newName)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 关闭数据源
 * @param value  alias | index
 * @returns {*}
 */
function closeDatasource(value = '') {
  try {
    if (typeof value === 'number') {
      return SDatasource.closeDatasourceByIndex(value)
    } else if (typeof value === 'string') {
      return SDatasource.closeDatasourceByAlias(value)
    }
  } catch (e) {
    console.error(e)
  }
}

/**
 * 删除数据源(本地数据源)
 * @param path
 * @returns {*}
 */
function deleteDatasource(path = '') {
  try {
    if (!path) return
    return SDatasource.deleteDatasource(path)
  } catch (e) {
    console.error(e)
  }
}

function removeDatasetByName(path,name){
  try {
    return SDatasource.removeDatasetByName(path,name)
  } catch (error) {
    console.error(e)
  }
}

function copyDataset(datasoucePath,toDatasourcePath,datasets){
  try {
    return SDatasource.copyDataset(datasoucePath,toDatasourcePath,datasets)
  } catch (error) {
    console.error(e)
  }
}

/**
 * 获取数据源列表
 * @returns {Promise.<Datasources>}
 */
function getDatasources(){
  try {
    return SDatasource.getDatasources()
  } catch (error) {
    console.error(e)
  }
}

export {
  createDatasource,
  // openDatasource,
  renameDatasource,
  closeDatasource,
  deleteDatasource,
  removeDatasetByName,
  copyDataset,
  getDatasources,
}