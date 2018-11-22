import { NativeModules } from 'react-native'
const LayerManager = NativeModules.SLayerManager

/**
 * 获取指定SymbolGroup中所有的symbol
 * @param type
 * @param path
 */
function getLayersByType(type = -1, path = '') {
  try {
    return LayerManager.getLayersByType(type, path)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 获取指定名字的LayerGroup
 * @param path
 * @returns {*}
 */
function getLayersByGroupPath(path = ''){
  try {
    return LayerManager.getLayersByGroupPath(path)
  } catch (e) {
    console.error(e)
  }
}


/**
 * 设置制定名字图层是否可见
 * @param path
 * @param value
 * @returns {{}}
 */
function setLayerVisible(path, value){
  try {
    return LayerManager.setLayerVisible(path, value)
  } catch (e) {
    console.error(e)
  }
}

export {
  getLayersByType,
  getLayersByGroupPath,
  setLayerVisible,
}