/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: 地图制图类
 **********************************************************************************/
import {
    NativeModules
} from 'react-native'

let SMCartography = NativeModules.SMCartography

/**
 * 设置点符号的ID
 * 
 * @param makerSymbolID 点符号ID
 * @param layerIndex 图层索引
 */
setMakerSymbolID = (makerSymbolID, layerIndex) => {
    try {
        return SMCartography.setMakerSymbolID(makerSymbolID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置点符号的大小： 1 - 100 mm
 * 
 * @param mm
 * @param layerIndex
 */
setMarkerSize = (mm, layerIndex) => {
  try {
    return SMCartography.setMarkerSize(mm, layerIndex)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 设置点符号的颜色
 * 
 * @param color 十六进制颜色码
 * @param layerIndex
 */
setMarkerColor = (color, layerIndex) => {
    try {
        return SMCartography.setMarkerColor(color, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置点符号的旋转角度： 0 - 360°
 * 
 * @param angle
 * @param layerIndex
 */
setMarkerAngle = (angle, layerIndex) => {
    try {
        return SMCartography.setMarkerAngle(angle, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置点符号的透明度： 0 - 100 %
 * 
 * @param alpha
 * @param layerIndex
 */
setMarkerAlpha = (alpha, layerIndex) => {
    try {
        return SMCartography.setMarkerAlpha(alpha, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线符号的ID(设置边框符号的ID)
 * 
 * @param lineSymbolID
 * @param layerIndex
 */
setLineSymbolID = (lineSymbolID, layerIndex) => {
    try {
        return SMCartography.setLineSymbolID(lineSymbolID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线宽：1 - 10mm(边框符号宽度)
 * 
 * @param mm
 * @param layerIndex
 */
setLineWidth = (mm, layerIndex) => {
    try {
        return SMCartography.setLineWidth(mm, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线颜色(边框符号颜色)
 * 
 * @param lineColor
 * @param layerIndex
 */
setLineColor = (lineColor, layerIndex) => {
    try {
        return SMCartography.setLineColor(lineColor, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置面符号的ID
 * 
 * @param FillSymbolID
 * @param layerIndex
 */
setFillSymbolID = (FillSymbolID, layerIndex) => {
    try {
        return SMCartography.setFillSymbolID(FillSymbolID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置前景色
 * 
 * @param fillForeColor
 * @param layerIndex
 */
setFillForeColor = (fillForeColor, layerIndex) => {
    try {
        return SMCartography.setFillForeColor(fillForeColor, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置背景色
 * 
 * @param fillBackColor
 * @param layerIndex
 */
setFillBackColor = (fillBackColor, layerIndex) => {
    try {
        return SMCartography.setFillBackColor(fillBackColor, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置透明度（0 - 100）
 * 
 * @param fillOpaqueRate
 * @param layerIndex
 */
setFillOpaqueRate = (fillOpaqueRate, layerIndex) => {
    try {
        return SMCartography.setFillOpaqueRate(fillOpaqueRate, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线性渐变
 * 
 * @param layerIndex
 */
setFillLinearGradient = (layerIndex) => {
    try {
        return SMCartography.setFillLinearGradient(layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置辐射渐变
 * 
 * @param layerIndex
 */
setFillRadialGradient = (layerIndex) => {
    try {
        return SMCartography.setFillRadialGradient(layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置方形渐变
 * 
 * @param layerIndex
 */
setFillSquareGradient = (layerIndex) => {
    try {
        return SMCartography.setFillSquareGradient(layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置无渐变
 * 
 * @param layerIndex
 */
setFillNoneGradient = (layerIndex) => {
    try {
        return SMCartography.setFillNoneGradient(layerIndex)
    } catch (e) {
        console.error(e)
    }
}

export default {
    //点风格
    setMakerSymbolID,
    setMarkerSize,
    setMarkerColor,
    setMarkerAngle,
    setMarkerAlpha,
    //线风格
    setLineSymbolID,
    setLineWidth,
    setLineColor,
    //面风格
    setFillSymbolID,
    setFillForeColor,
    setFillBackColor,
    setFillOpaqueRate,
    setFillLinearGradient,
    setFillRadialGradient,
    setFillSquareGradient,
    setFillNoneGradient,
}