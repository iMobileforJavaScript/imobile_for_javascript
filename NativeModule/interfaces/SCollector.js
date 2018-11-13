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
 * @param name
 * @param type
 * @param datasourceName
 * @param datasourcePath  数据源所在路径，不含文件名
 * @returns {Promise.<Promise|Promise.<void>>}
 */
async function setDataset(name = '', type = DatasetType.POINT, datasourceName = 'Collection', datasourcePath = '') {
  try {
    let path = (datasourcePath ? datasourcePath : (await Utility.appendingHomeDirectory() + '/iTablet/data/local/'))
    return Collector.setDataset(name, type, datasourceName, path)
  } catch (e) {
    console.error(e)
  }
}

async function startCollect(type) {
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

async function undo(type) {
  try {
    type = type >= 0 ? type : currentType
    return Collector.undo(type)
  } catch (e) {
    console.error(e)
  }
}

async function redo(type) {
  try {
    type = type >= 0 ? type : currentType
    return Collector.redo(type)
  } catch (e) {
    console.error(e)
  }
}

async function submit(type) {
  try {
    type = type >= 0 ? type : currentType
    // currentType = -1
    let result = Collector.submit(type)
    if (result) {
      Collector.startCollect(type)
    }
    return result
  } catch (e) {
    console.error(e)
  }
}

async function cancel(type) {
  try {
    // type = type >= 0 ? type : currentType
    return Collector.cancel(type)
  } catch (e) {
    console.error(e)
  }
}

async function addGPSPoint(type) {
  try {
    type = type >= 0 ? type : currentType
    return Collector.addGPSPoint(type)
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
}