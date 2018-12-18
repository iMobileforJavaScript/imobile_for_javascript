import { NativeModules } from 'react-native'
import Utility from '../utility/utility'
let Collector = NativeModules.SCollector
let DatasetType = NativeModules.JSDatasetType

let currentType = -1;

/**
 *
 * @param style - GeoStyle
 * @returns {*|Promise.<void>}
 */
function setStyle(style) {
  try {
    return Collector.setStyle(JSON.stringify(style))
  } catch (e) {
    console.error(e)
  }
}

async function getStyle() {
  try {
    const styleJson = await Collector.getStyle()
    return JSON.parse(styleJson)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 设置数据集。若所在数据源不可用，则新建数据源后，再创建数据集
 * @param datasetName
 * @param datasetType
 * @param datasourceName  若为空，则用当前地图命名；若地图还未保存，则命名为Collection
 * @param datasourcePath  数据源所在路径，不含文件名
 * @returns {Promise.<Promise|Promise.<void>>}
 */
async function setDataset(info = {}) {
  try {
    // name = '', type = DatasetType.POINT, datasourceName = 'Collection', datasourcePath = ''
    info.datasetName = info.datasetName || ''
    info.datasetType = info.datasetType || DatasetType.POINT
    info.datasourcePath = info.datasourcePath || (await Utility.appendingHomeDirectory() + '/iTablet/User/Customer/Data/Datasource/')
    info.datasourceName = info.datasourceName || ''
    info.style = info.style ? JSON.stringify(info.style) : ''
  
  
    console.warn('datasetName--' + info.datasetName)
    console.warn('datasetType--' + info.datasetType)
    console.warn('datasourcePath--' + info.datasourcePath)
    return Collector.setDataset(info)
  } catch (e) {
    console.error(e)
  }
}

async function startCollect(type = -1) {
  try {
    currentType = type
    return Collector.startCollect(type)
  } catch (e) {
    console.error(e)
  }
}

async function stopCollect() {
  try {
    currentType = -1
    return Collector.stopCollect()
  } catch (e) {
    console.error(e)
  }
}

async function undo(type = -1) {
  try {
    type = type >= 0 ? type : currentType
    return Collector.undo(type)
  } catch (e) {
    console.error(e)
  }
}

async function redo(type = -1) {
  try {
    type = type >= 0 ? type : currentType
    return Collector.redo(type)
  } catch (e) {
    console.error(e)
  }
}

async function submit(type = -1) {
  try {
    type = type >= 0 ? type : currentType
    // currentType = -1
    let result = await Collector.submit(type)
    if (result) {
      Collector.startCollect(type)
    }
    return result
  } catch (e) {
    console.error(e)
  }
}

async function cancel(type = -1) {
  try {
    // type = type >= 0 ? type : currentType
    return Collector.cancel(type)
  } catch (e) {
    console.error(e)
  }
}

async function addGPSPoint() {
  try {
    return Collector.addGPSPoint()
  } catch (e) {
    console.error(e)
  }
}

async function remove(id, layerPath) {
  try {
    return Collector.remove(id, layerPath)
  } catch (e) {
    console.error(e)
  }
}

export default {
  setStyle,
  getStyle,
  startCollect,
  stopCollect,
  setDataset,
  undo,
  redo,
  submit,
  cancel,
  addGPSPoint,
  remove,
}