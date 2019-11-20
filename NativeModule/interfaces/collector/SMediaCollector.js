/**
 * 多媒体采集类
 *
 * 注：
 *   1. 添加多媒体采集图片点击回调事件 setCalloutTapListener
 *   2. 结束采集调用 removeListener
 */
import { NativeModules, DeviceEventEmitter, NativeEventEmitter, Platform } from 'react-native'
import { EventConst } from '../../constains'
const Collector = NativeModules.SMediaCollector
const LayerManager = NativeModules.SLayerManager
const nativeEvt = new NativeEventEmitter(Collector)

// let mediaCaptureListener
// let mediaCaptureHandler
let calloutTapListener
let calloutTapHandler

// function setListener (handler) {
//   mediaCaptureHandler = handler
//   if (!mediaCaptureListener) {
//     if (Platform.OS === 'ios') {
//       mediaCaptureListener = nativeEvt.addListener(EventConst.MEDIA_CAPTURE, function (e) {
//         if (mediaCaptureHandler && typeof mediaCaptureHandler === 'function') {
//           mediaCaptureHandler(e)
//         }
//       })
//     } else {
//       mediaCaptureListener = DeviceEventEmitter.addListener(EventConst.MEDIA_CAPTURE, function (e) {
//         if (mediaCaptureHandler && typeof mediaCaptureHandler === 'function') {
//           mediaCaptureHandler(e)
//         }
//       })
//     }
//   }
// }

/**
 * 添加多媒体采集图片点击回调事件
 * @param handler
 */
function setCalloutTapListener (handler) {
  calloutTapHandler = handler
  if (calloutTapListener) return
  if (Platform.OS === 'ios') {
    calloutTapListener = nativeEvt.addListener(EventConst.MEDIA_CAPTURE_TAP_ACTION, function (e) {
      if (calloutTapHandler && typeof calloutTapHandler === 'function') {
        calloutTapHandler(e)
      }
    })
  } else {
    calloutTapListener = DeviceEventEmitter.addListener(EventConst.MEDIA_CAPTURE_TAP_ACTION, function (e) {
      if (calloutTapHandler && typeof calloutTapHandler === 'function') {
        calloutTapHandler(e)
      }
    })
  }
}

/**
 * 移除监听事件
 * @param handler
 */
function removeListener () {
  try {
    calloutTapHandler = null
    if (calloutTapListener) {
      calloutTapListener.remove()
      calloutTapListener = null
    }
  } catch (e) {

  }
}

function initMediaCollector (path = '') {
  if (!path) return false
  return Collector.initMediaCollector(path)
}

// /**
//  * 初始化MDataCollector
//  * @param datasourceName
//  * @param datasetName
//  * @returns {*}
//  */
// // function initMediaCollector(datasourceName, datasetName = 'MediaDataset') {
// //   try {
// //     if (datasourceName === undefined) return false
// //     return Collector.initMediaCollector(datasourceName, datasetName)
// //   } catch (e) {
// //     console.error(e)
// //   }
// // }
//
// /**
//  * 采集图片
//  * @param datasourceName
//  * @param datasetName
//  * @param handler
//  * @returns {*}
//  */
// function captureImage({datasourceName, datasetName}, handler) {
//   try {
//     if (datasourceName === undefined) return false
//     if (datasetName === undefined) datasetName = 'MediaDataset'
//     let result = Collector.captureImage(datasourceName, datasetName)
//
//     if (!handler) return result
//     setListener(handler)
//     return result
//   } catch (e) {
//     console.error(e)
//   }
// }
//
// /**
//  * 捕获视频
//  * @param datasourceName
//  * @param datasetName
//  * @param handler
//  * @returns {*}
//  */
// function captureVideo({datasourceName, datasetName}, handler) {
//   try {
//     if (datasourceName === undefined) return false
//     if (datasetName === undefined) datasetName = 'MediaDataset'
//     let result = Collector.captureVideo(datasourceName, datasetName)
//
//     if (!handler) return result
//     setListener(handler)
//     return result
//   } catch (e) {
//     console.error(e)
//   }
// }
//
// /**
//  * 开始采集音频
//  * @param datasourceName
//  * @param datasetName
//  * @param handler
//  * @returns {*}
//  */
// function startCaptureAudio({datasourceName, datasetName}, handler) {
//   try {
//     if (datasourceName === undefined) return false
//     if (datasetName === undefined) datasetName = 'MediaDataset'
//     if (!handler) setListener(handler)
//     let result = Collector.startCaptureAudio(datasourceName, datasetName)
//
//     return result
//   } catch (e) {
//     console.error(e)
//   }
// }
//
// /**
//  * 开始采集音频
//  * @param datasourceName
//  * @param datasetName
//  * @param handler
//  * @returns {*}
//  */
// function stopCaptureAudio() {
//   try {
//     let result = Collector.stopCaptureAudio()
//
//     return result
//   } catch (e) {
//     console.error(e)
//   }
// }

/**
 *
 * @param info
 * {
        datasourceName: 'Hunan',
        datasetName: 'MediaDataset',
        sourcePaths: 'absolutePath' - [],
        targetPath 'absolutePath of parent dictionary',
        addToMap: true, // 是否添加图片到地图上
      }
 * @param addToMap
 * @returns {*}
 */
function addMedia (info, addToMap = true) {
  if (info === undefined) return false
  if (info.datasetName === undefined) datasetName = 'MediaDataset'
  let result = Collector.addMedia(info, addToMap)

  return result
}

/**
 *
 * @param info
 * {
        datasourceName: 'Hunan',
        datasetName: 'MediaDataset',
        mediaName: 图片名称，非路径,
        addToMap: true, // 是否添加图片到地图上
      }
 * @param addToMap
 * @returns {*}
 */
function addArMedia (info, addToMap = true) {
  if (info === undefined) return false
  if (info.datasetName === undefined) datasetName = 'MediaDataset'
  let result = Collector.addArMedia(info, addToMap)

  return result
}

function addAIClassifyMedia (info, addToMap = true) {
  if (info === undefined) return false
  if (info.datasetName === undefined) datasetName = 'MediaDataset'
  let result = Collector.addAIClassifyMedia(info, addToMap)

  return result
}

// /**
//  * 添加多媒体文件
//  * @param files       多媒体文件绝对路径数组
//  * @param layerName   多媒体采集点所在图层
//  * @param geoID       多媒体采集点ID
//  * @returns {*}
//  */
// function addMediaFiles (files = [], layerName = '', geoID = -1) {
//   let result = Collector.addMediaFiles(files, layerName, geoID)
//
//   return result
// }
//
// /**(
//  * 删除多媒体文件
//  * @param files       多媒体文件绝对路径数组
//  * @param layerName   多媒体采集点所在图层
//  * @param geoID       多媒体采集点ID
//  * @returns {*}
//  */
// function deleteMediaFiles (files = [], layerName = '', geoID = -1) {
//   let result = Collector.deleteMediaFiles(files, layerName, geoID)
//
//   return result
// }

/**
 * 保存/修改 Media数据
 * @param layerName  指定图层名称
 * @param geoID      修改对象的ID
 * @param toPath     保存Media 数据路径
 * @param fieldInfo  修改数据的属性
 * @param addToMap   是否添加到地图上
 * @returns {*}
 */
function saveMediaByLayer (layerName = '', geoID = -1, toPath = '', fieldInfo = [], addToMap = true) {
  if (fieldInfo.length === 0 || geoID < 0) return false
  let info = []
  for (let i = 0; i < fieldInfo.length; i++) {
    let name = fieldInfo[i].name.substring(0, 1).toUpperCase() + fieldInfo[i].name.slice(1)
    info.push({
      name,
      value: fieldInfo[i].value,
    })
  }
  return Collector.saveMediaByLayer(layerName, geoID, toPath, info, addToMap)
}

function saveMediaByDataset (datasetName = '', geoID = -1, toPath = '', fieldInfo = [], addToMap = true) {
  if (fieldInfo.length === 0 || geoID < 0) return false
  let info = []
  for (let i = 0; i < fieldInfo.length; i++) {
    let name = fieldInfo[i].name.substring(0, 1).toUpperCase() + fieldInfo[i].name.slice(1)
    info.push({
      name,
      value: fieldInfo[i].value,
    })
  }
  return Collector.saveMediaByDataset(datasetName, geoID, toPath, info, addToMap)
}

/**
 * 更新指定多媒体callout
 * @returns {*}
 */
function updateMedia (layerName = '', geoIDs = []) {
  if (layerName === '' || geoIDs.length === 0) return
  return Collector.updateMedia(layerName, geoIDs)
}

/**
 * 移除多媒体callout
 * @returns {*}
 */
function removeMedias () {
  return Collector.removeMedias()
}

/**
 * 显示指定图层多媒体采集callouts
 * @returns {*}
 */
function showMedia (layerName) {
  if (!layerName) return false
  return Collector.showMedia(layerName)
}

/**
 * 移除指定图层多媒体采集callouts
 * @returns {*}
 */
function hideMedia (layerName) {
  if (!layerName) return false
  return Collector.hideMedia(layerName)
}

/**
 * 获取视频缩略图
 * @param videoPath
 * @returns {Promise.<*>}
 */
function getVideoInfo (videoPath) {
  return Collector.getVideoInfo(videoPath)
}

/**
 * 获取多媒体信息
 * @param layerName
 * @param geoID
 * @returns {*}
 */
function getMediaInfo (layerName = '', geoID = -1) {
  if (!layerName || geoID < 0) return
  return Collector.getMediaInfo(layerName, geoID)
}

/**
 * 添加多媒体旅行轨迹
 * @param layerName
 * @param files
 * @returns {*}
 */
function addTour (layerName = '', files = []) {
  if (!layerName || files.length <= 0) return
  return Collector.addTour(layerName, files)
}

export default {
  initMediaCollector,
  // captureImage,
  // captureVideo,
  // startCaptureAudio,
  // stopCaptureAudio,
  setCalloutTapListener,
  removeListener,

  addMedia,
  addArMedia,
  addAIClassifyMedia,
  addTour,
  // addMediaFiles,
  // deleteMediaFiles,
  saveMediaByLayer,
  saveMediaByDataset,
  removeMedias,
  showMedia,
  hideMedia,
  updateMedia,

  getVideoInfo,
  getMediaInfo,
}