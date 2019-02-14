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
 * 设置制定名字图层是否可编辑
 * @param path
 * @param value
 * @returns {*}
 */
function setLayerEditable(path, value){
  try {
    return LayerManager.setLayerEditable(path, value)
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
function getLayerAttribute(path, page = 0, size = 20) {
  try {
    if (!path) {
      console.warn('path is null')
      return
    }
    return LayerManager.getLayerAttribute(path, page, size)
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

/**
 * 根据数据源名称/序号 和 数据集序号，添加图层
 * @param datasourceNameOrIndex
 * @param datasetIndex
 * @returns {*}
 */
function addLayer(datasourceNameOrIndex, datasetIndex = -1) {
  try {
    if (datasourceNameOrIndex === '' || datasourceNameOrIndex === -1 || datasetIndex === -1) {
      return
    }
    if (typeof datasourceNameOrIndex === 'number') {
      return LayerManager.addLayerByIndex(datasourceNameOrIndex, datasetIndex)
    } else {
      return LayerManager.addLayerByName(datasourceNameOrIndex, datasetIndex)
    }
  } catch (e) {
    console.error(e)
  }
}

/**
 * 根据图层路径，找到对应的图层并修改指定recordset中的FieldInfo
 * @param layerPath
 * @param fieldInfo
 * @param index
 * @returns {*}
 */
function setLayerFieldInfo(layerPath = '', fieldInfo = {}, index = -1) {
  try {
    return LayerManager.setLayerFieldInfo(layerPath, fieldInfo, index)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 移除所有图层
 * @param params
 * @param value
 * @returns {*}
 */
function removeAllLayer() {
  try {
    return LayerManager.removeAllLayer()
  } catch (e) {
    console.error(e)
  }
}


/**
 * 移除指定图层
 * @param params
 * @param value    图层 index
 * @returns {*}
 */
function removeLayer(value = -1) {
  try {
    if (value < 0 || value === '' || (typeof value !=='number' && typeof value !== 'string')) return
    if (typeof value === 'number') {
      return LayerManager.removeLayerWithIndex(value)
    } else {
      return LayerManager.removeLayerWithName(value)
    }
  } catch (e) {
    console.error(e)
  }
}

/**
 * 移除指定图层
 * @param params
 * @param value    图层 index
 * @returns {*}
 */
function renameLayer(layerName,relayerName) {
  try {
     return LayerManager.renameLayer(layerName,relayerName)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 向上移动图层
 * @param params
 * @param value    图层 index
 * @returns {*}
 */
function moveUpLayer(layerName) {
  try {
    return LayerManager.moveUpLayer(layerName)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 向下移动图层
 * @param params
 * @param value    图层 index
 * @returns {*}
 */
function moveDownLayer(layerName) {
  try {
    return LayerManager.moveDownLayer(layerName)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 置顶图层
 * @param params
 * @param value    图层 index
 * @returns {*}
 */
function moveToTop(layerName) {
  try {
    return LayerManager.moveToTop(layerName)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 置底图层
 * @param params
 * @param value    图层 index
 * @returns {*}
 */
function moveToBottom(layerName) {
  try {
    return LayerManager.moveToBottom(layerName)
  } catch (e) {
    console.error(e)
  }
}


export {
  getLayersByType,
  getLayersByGroupPath,
  setLayerVisible,
  setLayerEditable,
  getLayerIndexByName,
  getLayerAttribute,
  getSelectionAttributeByLayer,
  addLayer,
  setLayerFieldInfo,
  removeAllLayer,
  removeLayer,
  renameLayer,
  moveUpLayer,
  moveDownLayer,
  moveToTop,
  moveToBottom,
}