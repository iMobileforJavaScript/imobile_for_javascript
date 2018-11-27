/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: tronzzb
 Description: 地图制图类
 **********************************************************************************/
import {
    NativeModules
} from 'react-native'

let SCartography = NativeModules.SCartography

/**
 * 设置点符号的ID
 * 
 * @param makerSymbolID 点符号ID
 * @param layerIndex 图层索引
 */
setMakerSymbolID = (makerSymbolID, layerIndex) => {
    try {
        return SCartography.setMakerSymbolID(makerSymbolID, layerIndex)
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
    return SCartography.setMarkerSize(mm, layerIndex)
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
        return SCartography.setMarkerColor(color, layerIndex)
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
        return SCartography.setMarkerAngle(angle, layerIndex)
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
        return SCartography.setMarkerAlpha(alpha, layerIndex)
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
        return SCartography.setLineSymbolID(lineSymbolID, layerIndex)
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
        return SCartography.setLineWidth(mm, layerIndex)
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
        return SCartography.setLineColor(lineColor, layerIndex)
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
        return SCartography.setFillSymbolID(FillSymbolID, layerIndex)
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
        return SCartography.setFillForeColor(fillForeColor, layerIndex)
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
        return SCartography.setFillBackColor(fillBackColor, layerIndex)
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
        return SCartography.setFillOpaqueRate(fillOpaqueRate, layerIndex)
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
        return SCartography.setFillLinearGradient(layerIndex)
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
        return SCartography.setFillRadialGradient(layerIndex)
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
        return SCartography.setFillSquareGradient(layerIndex)
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
        return SCartography.setFillNoneGradient(layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置透明度(0 - 100 % )
 * 
 * @param gridOpaqueRate
 * @param layerIndex
 */
setGridOpaqueRate = (gridOpaqueRate, layerIndex) => {
    try {
        return SCartography.setGridOpaqueRate(gridOpaqueRate, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置亮度(-100 % -100 % )
 * 
 * @param gridContrast
 * @param layerIndex
 */
setGridContrast = (gridContrast, layerIndex) => {
    try {
        return SCartography.setGridContrast(gridContrast, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置对比度(-100 % -100 % )
 * 
 * @param gridBrightness
 * @param layerIndex
 */
setGridBrightness = (gridBrightness, layerIndex) => {
    try {
        return SCartography.setGridBrightness(gridBrightness, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置文本字体的名称
 * 
 * @param fontName  字体名称,例如：“ 宋体”
 * @param geometryID 
 * @param layerIndex
 */
setTextFont = (fontName, geometryID, layerIndex) => {
    try {
        return SCartography.setTextFont(fontName, geometryID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置字号
 * 
 * @param size
 * @param geometryID 
 * @param layerIndex
 */
setTextFontSize = (size, geometryID, layerIndex) => {
    try {
        return SCartography.setTextFontSize(size, geometryID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置字体颜色
 * 
 * @param color
 * @param geometryID 
 * @param layerIndex
 */
setTextFontColor = (color, geometryID, layerIndex) => {
    try {
        return SCartography.setTextFontColor(color, geometryID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置旋转角度
 * 
 * @param angle
 * @param geometryID 
 * @param layerIndex
 */
setTextFontRotation = (angle, geometryID, layerIndex) => {
    try {
        return SCartography.setTextFontRotation(angle, geometryID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置位置
 * 
 * @param textAlignment 文本的对齐方式,例如: “TOPLEFT”,“ TOPCENTER”...
 * @param geometryID 
 * @param layerIndex
 */
setTextFontPosition = (textAlignment, geometryID, layerIndex) => {
    try {
        return SCartography.setTextFontPosition(textAlignment, geometryID, layerIndex)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置字体风格
 * 
 * @param style (加粗:BOLD、 斜体:ITALIC、 下划线:UNDERLINE、 删除线:STRIKEOUT、 轮廓:OUTLINE、 阴影:SHADOW)
 * @param geometryID 
 * @param layerIndex
 */
setTextStyle = (style, whether, geometryID, layerIndex) => {
    try {
        return SCartography.setTextStyle(style, whether, geometryID, layerIndex)
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
    //栅格风格
    setGridOpaqueRate,
    setGridContrast,
    setGridBrightness,
    //文本风格
    setTextFont,
    setTextFontSize,
    setTextFontColor,
    setTextFontRotation,
    setTextFontPosition,
    setTextStyle,
}