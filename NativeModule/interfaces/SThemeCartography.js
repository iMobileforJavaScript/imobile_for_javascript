/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: 专题制图类
 **********************************************************************************/
import {
  NativeModules,
  Platform,
} from "react-native"
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
 * 新建单值风格标签专题图
 *
 * @param params (数据源的索引/数据源的别名、 数据集名称、 单值专题图字段表达式、 颜色表样式)
 */
createUniqueThemeLabelMap = (params) => {
  try {
    return SThemeCartography.createUniqueThemeLabelMap(params)
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
    console.error(e)
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

//修改单值专题图
modifyThemeUniqueMap = (params) => {
  try {
    return SThemeCartography.modifyThemeUniqueMap(params)
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
 */
getUniqueExpression = (params) => {
  try {
    return SThemeCartography.getUniqueExpression(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取数据集中的字段
 * @param layerName 图层名称
 */
getThemeExpressionByLayerName = (layerName) => {
  try {
    return SThemeCartography.getThemeExpressionByLayerName(layerName)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取数据集中的字段
 * @param layerIndex 图层索引
 */
getThemeExpressionByLayerIndex = (layerIndex) => {
  try {
    return SThemeCartography.getThemeExpressionByLayerIndex(layerIndex)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 新建分段专题图层
 *
 * @param params(数据源的索引 / 数据源的别名 / 打开本地数据源、 数据集名称、 分段字段表达式、 分段模式、 分段参数、 颜色渐变模式)
 */
createThemeRangeMap = (params) => {
  try {
    return SThemeCartography.createThemeRangeMap(params)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 新建分段标签图层
 *
 * @param params(数据源的索引 / 数据源的别名 / 打开本地数据源、 数据集名称、 分段字段表达式、 分段模式、 分段参数、 颜色渐变模式)
 */
createRangeThemeLabelMap = (params) => {
  try {
    return SThemeCartography.createRangeThemeLabelMap(params)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 设置分段专题图的分段字段表达式
 *
 * @param params 分段字段表达式 图层名称 图层索引
 */
setRangeExpression = (params) => {
  try {
    return SThemeCartography.setRangeExpression(params)
  } catch (error) {
    console.error(error)
  }
}

//修改分段专题图
modifyThemeRangeMap = (params) => {
  try {
    return SThemeCartography.modifyThemeRangeMap(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 新建统一标签专题图
 *
 * @param params
 */
createUniformThemeLabelMap = (params) => {
  try {
    return SThemeCartography.createUniformThemeLabelMap(params)
  } catch (error) {
    console.error(error)
  }
}


/**
 * 设置统一标签专题图的表达式
 *
 * @param params
 */
setUniformLabelExpression = (params) => {
  try {
    return SThemeCartography.setUniformLabelExpression(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统一标签专题图的背景形状
 *
 * @param params
 */
setUniformLabelBackShape = (params) => {
  try {
    return SThemeCartography.setUniformLabelBackShape(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统一标签专题图的字体
 *
 * @param params
 */
setUniformLabelFontName = (params) => {
  try {
    return SThemeCartography.setUniformLabelFontName(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统一标签专题图的字号
 *
 * @param params
 */
setUniformLabelFontSize = (params) => {
  try {
    return SThemeCartography.setUniformLabelFontSize(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统一标签专题图的旋转角度
 *
 * @param params
 */
setUniformLabelRotaion = (params) => {
  try {
    return SThemeCartography.setUniformLabelRotaion(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统一标签专题图的颜色
 *
 * @param params
 */
setUniformLabelColor = (params) => {
  try {
    return SThemeCartography.setUniformLabelColor(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * @param params
 */
getUniformLabelExpression = (params) => {
  try {
    return SThemeCartography.getUniformLabelExpression(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * @param params
 */
getUniformLabelBackShape = (params) => {
  try {
    return SThemeCartography.getUniformLabelBackShape(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * @param params
 */
getUniformLabelFontName = (params) => {
  try {
    return SThemeCartography.getUniformLabelFontName(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * @param params
 */
getUniformLabelFontSize = (params) => {
  try {
    return SThemeCartography.getUniformLabelFontSize(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * @param params
 */
getUniformLabelRotaion = (params) => {
  try {
    return SThemeCartography.getUniformLabelRotaion(params)
  } catch (error) {
    console.error(error)
  }
}

/**
 * @param params
 */
getUniformLabelColor = (params) => {
  try {
    return SThemeCartography.getUniformLabelColor(params)
  } catch (error) {
    console.error(error)
  }
}

/**获取所有数据源中的所有数据集名称 */
getAllDatasetNames = () => {
  try {
    return SThemeCartography.getAllDatasetNames()
  } catch (error) {
    console.error(error)
  }
}

getThemeExpressionByDatasetName = (datasourceName, datasetName) => {
  try {
    return SThemeCartography.getThemeExpressionByDatasetName(datasourceName, datasetName)
  } catch (error) {
    console.error(error)
  }
}

/**设置单值专题图的颜色方案 */
setUniqueColorScheme = (params) => {
  try {
    return SThemeCartography.setUniqueColorScheme(params)
  } catch (error) {
    console.error(error)
  }
}

/**设置分段专题图的颜色方案 */
setRangeColorScheme = (params) => {
  try {
    return SThemeCartography.setRangeColorScheme(params)
  } catch (error) {
    console.error(error)
  }
}

getRangeExpression = (params) => {
  try {
    return SThemeCartography.getRangeExpression(params)
  } catch (error) {
    console.error(error)
  }
}

getRangeMode = (params) => {
  try {
    return SThemeCartography.getRangeMode(params)
  } catch (error) {
    console.error(error)
  }
}

getRangeCount = (params) => {
  try {
    return SThemeCartography.getRangeCount(params)
  } catch (error) {
    console.error(error)
  }
}

/** 获取专题图的颜色方案(String) */
getThemeColorSchemeName = (params) => {
  try {
    return SThemeCartography.getThemeColorSchemeName(params)
  } catch (error) {
    console.error(error)
  }
}

saveMap = () => {
  try {
    return SThemeCartography.saveMap()
  } catch (error) {
    console.error(error)
  }
}

/**设置统一标签背景颜色 */
setUniformLabelBackColor = (params) => {
  try {
    return SThemeCartography.setUniformLabelBackColor(params)
  } catch (error) {
    console.error(error)
  }
}

/**获取指定数据源中的数据集 */
getDatasetsByDatasource = (params) => {
  try {
    return SThemeCartography.getDatasetsByDatasource(params)
  } catch (error) {
    console.error(error)
  }
}

/**获取UDB中数据集名称 */
getUDBName = (path) => {
  try {
    return SThemeCartography.getUDBName(path)
  } catch (error) {
    console.error(error)
  }
}

isAnyOpenedDS = () => {
  try {
    return SThemeCartography.isAnyOpenedDS()
  } catch (error) {
    console.error(error)
  }
}

/**
 * 数据集->新建统计专题图
 *
 * @param params
 */
createThemeGraphMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createThemeGraphMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 图层->新建统计专题图
 *
 * @param params
 */
createThemeGraphMapByLayer = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createThemeGraphMapByLayer(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统计专题图的表达式
 *
 * @param params
 */
setThemeGraphExpressions = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.setThemeGraphExpressions(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统计专题图的颜色方案
 *
 * @param params
 */
setThemeGraphColorScheme = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.setThemeGraphColorScheme(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统计专题图的类型
 *
 * @param params
 */
setThemeGraphType = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.setThemeGraphType(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统计专题图的统计值的计算方法
 *
 * @param params
 */
setThemeGraphGraduatedMode = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.setThemeGraphGraduatedMode(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取统计专题图的表达式
 *
 * @param params
 */
getGraphExpressions = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getGraphExpressions(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取统计专题图的最大显示值
 *
 * @param params
 */
getGraphMaxValue = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getGraphMaxValue(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 设置统计专题图的最大显示值
 *
 * @param params
 */
setGraphMaxValue = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.setGraphMaxValue(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 新建点密度专题图
 *
 * @param params
 */
createDotDensityThemeMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createDotDensityThemeMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 修改点密度专题图：设置点密度图的表达式，单点代表的值，点风格（大小和颜色）。
 *
 * @param params
 */
modifyDotDensityThemeMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.modifyDotDensityThemeMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 新建等级符号专题图
 *
 * @param params
 */
createGraduatedSymbolThemeMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createGraduatedSymbolThemeMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 修改等级符号专题图：设置表达式，分级方式，基准值，正值基准值风格（大小和颜色）。
 *
 * @param params
 */
modifyGraduatedSymbolThemeMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.modifyGraduatedSymbolThemeMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取点密度专题图表达式
 * @param params
 */
getDotDensityExpression = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getDotDensityExpression(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取点密度专题图单点代表值
 * @param params
 * @returns {*}
 */
getDotDensityValue = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getDotDensityValue(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取点密度专题图的点大小
 * @param params
 * @returns {Promise<void>}
 */
getDotDensityDotSize= (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getDotDensityDotSize(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取等级符号专题图的表达式
 * @param params
 * @returns {*}
 */
getGraduatedSymbolExpress= (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getGraduatedSymbolExpress(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取等级符号专题图的基准值
 * @param params
 * @returns {*}
 */
getGraduatedSymbolValue= (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getGraduatedSymbolValue(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取等级符号专题图的符号大小
 * @param params
 * @returns {*}
 */
getGraduatedSymbolSize= (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getGraduatedSymbolSize(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 数据集->创建栅格分段专题图
 *
 * @param params
 */
createThemeGridRangeMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createThemeGridRangeMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 图层->创建栅格分段专题图
 *
 * @param params
 */
createThemeGridRangeMapByLayer = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createThemeGridRangeMapByLayer(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 修改栅格分段专题图(分段方法，分段参数，颜色方案)
 *
 * @param params
 */
modifyThemeGridRangeMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.modifyThemeGridRangeMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 数据集->创建栅格单值专题图
 *
 * @param params
 */
createThemeGridUniqueMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createThemeGridUniqueMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 图层->创建栅格单值专题图
 *
 * @param params
 */
createThemeGridUniqueMapByLayer = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.createThemeGridUniqueMapByLayer(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 修改栅格单值专题图
 *
 * @param params
 */
modifyThemeGridUniqueMap = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.modifyThemeGridUniqueMap(params)
    }
  } catch (error) {
    console.error(error)
  }
}

/**
 * 获取分段栅格专题图分段个数
 *
 * @param params
 */
getGridRangeCount = (params) => {
  try {
    if (Platform.OS === 'android') {
      return SThemeCartography.getGridRangeCount(params)
    }
  } catch (error) {
    console.error(error)
  }
}

export default {
  //单值
  createThemeUniqueMap,
  setThemeUniqueDefaultStyle,
  setThemeUniqueItemStyle,
  setUniqueExpression,
  modifyThemeUniqueMap,
  getThemeUniqueDefaultStyle,
  getUniqueExpression,
  setUniqueColorScheme,
  createUniqueThemeLabelMap,
  //分段
  createThemeRangeMap,
  setRangeExpression,
  modifyThemeRangeMap,
  setRangeColorScheme,
  getRangeExpression,
  getRangeMode,
  getRangeCount,
  createRangeThemeLabelMap,
  //统一标签
  createUniformThemeLabelMap,
  setUniformLabelExpression,
  setUniformLabelBackShape,
  setUniformLabelFontName,
  setUniformLabelFontSize,
  setUniformLabelRotaion,
  setUniformLabelColor,
  getUniformLabelExpression,
  getUniformLabelBackShape,
  getUniformLabelFontName,
  getUniformLabelFontSize,
  getUniformLabelRotaion,
  getUniformLabelColor,
  setUniformLabelBackColor,
  //统计专题图
  createThemeGraphMap,
  createThemeGraphMapByLayer,
  setThemeGraphExpressions,
  setThemeGraphColorScheme,
  setThemeGraphType,
  setThemeGraphGraduatedMode,
  getGraphExpressions,
  getGraphMaxValue,
  setGraphMaxValue,
  //点密度专题图
  createDotDensityThemeMap,
  modifyDotDensityThemeMap,
  getDotDensityExpression,
  getDotDensityValue,
  getDotDensityDotSize,
  //等级符号专题图
  createGraduatedSymbolThemeMap,
  modifyGraduatedSymbolThemeMap,
  getGraduatedSymbolExpress,
  getGraduatedSymbolValue,
  getGraduatedSymbolSize,
  //栅格专题图
  createThemeGridRangeMap,
  createThemeGridRangeMapByLayer,
  modifyThemeGridRangeMap,
  createThemeGridUniqueMap,
  createThemeGridUniqueMapByLayer,
  modifyThemeGridUniqueMap,
  getGridRangeCount,
  //其他
  getThemeExpressionByLayerName,
  getThemeExpressionByLayerIndex,
  getThemeExpressionByDatasetName,
  getAllDatasetNames,
  getThemeColorSchemeName,
  saveMap,
  getDatasetsByDatasource,
  getUDBName,
  isAnyOpenedDS,
}