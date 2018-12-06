/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: 专题制图类
 **********************************************************************************/
import {
  NativeModules
} from 'react-native'
let SThemeCartography = NativeModules.SThemeCartography

/**
 * 新建单值专题图层
 * 
 * @param params (数据源的索引/数据源的别名、 数据集名称、 单值专题图字段表达式、 颜色表样式)
 */
createThemeUniqueMap = (params) => {
  try {
    return SThemeCartography.createThemeUniqueMap(params)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 新建单值专题图层
 * 
 */
createAndRemoveThemeUniqueMap = (params) => {
  try {
    return SThemeCartography.createAndRemoveThemeUniqueMap(params)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 设置单值专题图的默认风格
 * 
 * @param params 显示风格
 * @param layerName 图层名称
 */
setThemeUniqueDefaultStyle = (params, layerName) => {
  try {
    return SThemeCartography.setThemeUniqueDefaultStyle(params, layerName)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 设置单值专题图子项的显示风格
 * 
 * @param params 显示风格
 * @param layerName 图层名称
 * @param itemIndex 单值专题图子项索引
 */
setThemeUniqueItemStyle = (params, layerName, itemIndex) => {
  try {
    return SThemeCartography.setThemeUniqueItemStyle(params, layerName, itemIndex)
  } catch (error) {
    console.error(e);
  }
}

/**
 * 设置单值专题图字段表达式
 *
 * @param params 单值专题图字段表达式UniqueExpression / 图层名称LayerName / 图层索引LayerIndex
 */
setUniqueExpression = (params) => {
  try {
    return SThemeCartography.setUniqueExpression(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取单值专题图的默认风格
 *
 * @param layerName 专题图层名称
 */
getThemeUniqueDefaultStyle = (layerName) => {
  try {
    return SThemeCartography.getThemeUniqueDefaultStyle(layerName)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取单值专题图的字段表达式
 *
 * @param layerName 专题图层名称
 */
getUniqueExpression = (layerName) => {
  try {
    return SThemeCartography.getUniqueExpression(layerName)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取数据集中的字段
 * @param udbPath UDB在内存中路径
 * @param datasetName 数据集名称
 * @param promise
 */
getThemeExpressByUdb = (udbPath, datasetName) => {
  try {
    return SThemeCartography.getThemeExpressByUdb(udbPath, datasetName)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取数据集中的字段
 * @param layerName 图层名称
 * @param promise
 */
getThemeExpressByLayerName = (layerName) => {
  try {
    return SThemeCartography.getThemeExpressByLayerName(layerName)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取数据集中的字段
 * @param layerIndex 图层索引
 * @param promise
 */
getThemeExpressByLayerIndex = (layerIndex) => {
  try {
    return SThemeCartography.getThemeExpressByLayerIndex(layerIndex)
  } catch (error) {
    console.error(error)
  }
}

export default {
  createThemeUniqueMap,
  setThemeUniqueDefaultStyle,
  setThemeUniqueItemStyle,
  setUniqueExpression,
  getThemeUniqueDefaultStyle,
  getUniqueExpression,
  getThemeExpressByUdb,
  getThemeExpressByLayerName,
  getThemeExpressByLayerIndex,
  createAndRemoveThemeUniqueMap,
}