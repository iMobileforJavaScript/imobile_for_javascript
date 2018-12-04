import { NativeModules, Platform } from 'react-native'
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

/**
 * 获取指定名字的图层索引
 * @param name
 * @param promise
 */
function getLayerIndexByName(name) {
  try {
    if (Platform.OS === 'ios') return
    return LayerManager.getLayerIndexByName(name)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 获取图层属性
 * @param path
 * @returns {*}
 */
function getLayerAttribute(path) {
  try {
    if (!path) {
      console.warn('path is null')
      return
    }
    return LayerManager.getLayerAttribute(path)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 获取Selection中对象的属性
 * @param path
 * @returns {*}
 */
function getSelectionAttributeByLayer(path) {
  try {
    if (!path) {
      console.warn('path is null')
      return
    }
    return LayerManager.getSelectionAttributeByLayer(path)
  } catch (e) {
    console.error(e)
  }
}

export {
  getLayersByType,
  getLayersByGroupPath,
  setLayerVisible,
  getLayerIndexByName,
  getLayerAttribute,
  getSelectionAttributeByLayer,
}