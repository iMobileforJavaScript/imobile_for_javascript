import { NativeModules } from 'react-native'
import Utility from '../../utility/utility'
let Collector = NativeModules.SCollector
let CollectorType = NativeModules.SCollectorType
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
    
    return Collector.setDataset(info)
  } catch (e) {
    console.error(e)
  }
}

let gpsTimer = null
async function initCollect(type = -1) {
  if (gpsTimer) {
    clearInterval(gpsTimer)
    gpsTimer = null
  }
  currentType = type
  return await Collector.startCollect(type)
}

async function startAddGPSPoint () {
  if (!gpsTimer) {
    await addGPSPoint()
    gpsTimer = setInterval(async () => {
      await addGPSPoint()
      // let point = await Collector.getGPSPoint()
      // if (point) {
      //   if (lastPoint) {
      //     let distance = Utility.convertDistanceByPoints(point, lastPoint)
      //     if (distance >= 0.005) {
      //       lastPoint = await addGPSPoint()
      //     }
      //   } else {
      //     lastPoint = await addGPSPoint()
      //   }
      // }
    }, 1000)
  }
}

async function startCollect(type = -1) {
  try {
    if (gpsTimer) {
      clearInterval(gpsTimer)
      gpsTimer = null
    }
    currentType = type
    // let result = await Collector.startCollect(type)
    // if (result) {
    //   switch (type) {
    //     case CollectorType.LINE_GPS_PATH:
    //     case CollectorType.REGION_GPS_PATH:
    //       await startAddGPSPoint()
    //   }
    // }
    switch (type) {
      case CollectorType.LINE_GPS_PATH:
      case CollectorType.REGION_GPS_PATH:
        await startAddGPSPoint()
    }
  } catch (e) {
    console.error(e)
  }
}

async function getGPSPoint() {
  try {
    return Collector.getGPSPoint()
  } catch (e) {
    console.error(e)
  }
}

async function pauseCollect() {
  try {
    currentType = -1
    if (gpsTimer !== null) {
      clearInterval(gpsTimer)
    }
  } catch (e) {
    console.error(e)
  }
}

async function stopCollect() {
  try {
    currentType = -1
    if (gpsTimer !== null) {
      clearInterval(gpsTimer)
    }
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

async function removeByIds(ids = [], layerPath) {
  try {
    return Collector.removeByIds(ids, layerPath)
  } catch (e) {
    console.error(e)
  }
}

export default {
  setStyle,
  getStyle,
  initCollect,
  startCollect,
  pauseCollect,
  stopCollect,
  getGPSPoint,
  setDataset,
  undo,
  redo,
  submit,
  cancel,
  addGPSPoint,
  remove,
  removeByIds,
}