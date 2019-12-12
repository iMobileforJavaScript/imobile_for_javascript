import { NativeModules } from 'react-native'
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

function createDatasourceOfLabel(info={}){
  try {
    return SDatasource.createDatasourceOfLabel(info)
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
function openDatasource2(info = {}) {
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

function createDataset(datasourceAlias, datasetName, type) {
  return SDatasource.createDataset(datasourceAlias, datasetName, type)
}

//删除打开数据源中的数据集
function deleteDataset(datasourceAlias, datasetName) {
  return SDatasource.deleteDataset(datasourceAlias, datasetName)
}

function isAvailableDatasetName(datasourceAlias, datasetName) {
  return SDatasource.isAvailableDatasetName(datasourceAlias, datasetName)
}

function removeDatasetByName(path,name){
  try {
    return SDatasource.removeDatasetByName(path,name)
  } catch (e) {
    console.error(e)
  }
}

function importDataset(type, filePath, datasourceParams, importParams = {}) {
  try {
    return SDatasource.importDataset(type, filePath, datasourceParams, importParams)
  } catch (e) {
    console.error(e)
  }
}

function copyDataset(datasoucePath,toDatasourcePath,datasets){
  try {
    return SDatasource.copyDataset(datasoucePath,toDatasourcePath,datasets)
  } catch (e) {
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
  } catch (e) {
    console.error(e)
  }
}

/**
 * 获取指定数据源中的数据集
 * @param info      DatasourceConnectionInfo
 * @param autoOpen  如果指定数据源没有打开，可设置是否打开
 */
function getDatasetsByDatasource(info, autoOpen = false){
  try {
    return SDatasource.getDatasetsByDatasource(info, autoOpen)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 根据数据源目录，获取指定数据源中的数据集（非工作空间已存在的数据源）
 * @param info
 * @returns {*}
 */
function getDatasetsByExternalDatasource(info){
  try {
    return SDatasource.getDatasetsByExternalDatasource(info)
  } catch (e) {
    console.error(e)
  }
}

function getDatasetToGeoJson(datasourceAlias, datasetName, path){
  try {
    return SDatasource.getDatasetToGeoJson(datasourceAlias, datasetName, path)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 获取数据集字段信息
 * @param data
 * @param filter
 * @param autoOpen
 * @returns {*}
 */
function getFieldInfos(data, filter, autoOpen = true) {
  try {
    if (!data) {
      console.warn('data is null')
      return
    }
    return SDatasource.getFieldInfos(data, filter, autoOpen)
  } catch (e) {
    console.error(e)
  }
}

function importDatasetFromGeoJson(datasourceAlias, datasetName, path, DatasetType, properties){
  try {
    return SDatasource.importDatasetFromGeoJson(datasourceAlias, datasetName, path, DatasetType, properties)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 获取数据集范围
 * @param sourceData
 * @returns {*}
 */
function getDatasetBounds(sourceData){
  try {
    return SDatasource.getDatasetBounds(sourceData)
  } catch (e) {
    console.error(e)
  }
}
/**
 *
 * @param datasourceAlias
 * @param datasetName
 * @returns {*}
 */
async function getAvailableDatasetName(datasourceAlias, datasetName){
  try {
    let result = false
    let name = datasetName
    let index = 1
    while(!result) {
      result = await SDatasource.isAvailableDatasetName(datasourceAlias, name)
      if (!result) {
        name = datasetName + '_' + (index++)
      }
    }
    return name
  } catch (error) {
    console.error(e)
  }
}


export {
  createDatasource,
  createDatasourceOfLabel,
  openDatasource2,
  renameDatasource,
  closeDatasource,
  deleteDatasource,
  createDataset,
  deleteDataset,
  importDataset,
  isAvailableDatasetName,
  removeDatasetByName,
  copyDataset,
  getDatasources,
  getDatasetsByDatasource,
  getDatasetsByExternalDatasource,
  getDatasetToGeoJson,
  getFieldInfos,
  importDatasetFromGeoJson,
  getDatasetBounds,
  getAvailableDatasetName,
}