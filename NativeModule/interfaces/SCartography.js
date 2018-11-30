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
 * @param layerName 图层名称
 */
setMakerSymbolID = (makerSymbolID, layerName) => {
    try {
        return SCartography.setMakerSymbolID(makerSymbolID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置点符号的大小： 1 - 100 mm
 * 
 * @param mm
 * @param layerName
 */
setMarkerSize = (mm, layerName) => {
  try {
    return SCartography.setMarkerSize(mm, layerName)
  } catch (e) {
    console.error(e)
  }
}

/**
 * 设置点符号的颜色
 * 
 * @param color 十六进制颜色码
 * @param layerName
 */
setMarkerColor = (color, layerName) => {
    try {
        return SCartography.setMarkerColor(color, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置点符号的旋转角度： 0 - 360°
 * 
 * @param angle
 * @param layerName
 */
setMarkerAngle = (angle, layerName) => {
    try {
        return SCartography.setMarkerAngle(angle, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置点符号的透明度： 0 - 100 %
 * 
 * @param alpha
 * @param layerName
 */
setMarkerAlpha = (alpha, layerName) => {
    try {
        return SCartography.setMarkerAlpha(alpha, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线符号的ID(设置边框符号的ID)
 * 
 * @param lineSymbolID
 * @param layerName
 */
setLineSymbolID = (lineSymbolID, layerName) => {
    try {
        return SCartography.setLineSymbolID(lineSymbolID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线宽：1 - 10mm(边框符号宽度)
 * 
 * @param mm
 * @param layerName
 */
setLineWidth = (mm, layerName) => {
    try {
        return SCartography.setLineWidth(mm, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线颜色(边框符号颜色)
 * 
 * @param lineColor
 * @param layerName
 */
setLineColor = (lineColor, layerName) => {
    try {
        return SCartography.setLineColor(lineColor, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置面符号的ID
 * 
 * @param FillSymbolID
 * @param layerName
 */
setFillSymbolID = (FillSymbolID, layerName) => {
    try {
        return SCartography.setFillSymbolID(FillSymbolID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置前景色
 * 
 * @param fillForeColor
 * @param layerName
 */
setFillForeColor = (fillForeColor, layerName) => {
    try {
        return SCartography.setFillForeColor(fillForeColor, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置背景色
 * 
 * @param fillBackColor
 * @param layerName
 */
setFillBackColor = (fillBackColor, layerName) => {
    try {
        return SCartography.setFillBackColor(fillBackColor, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置透明度（0 - 100）
 * 
 * @param fillOpaqueRate
 * @param layerName
 */
setFillOpaqueRate = (fillOpaqueRate, layerName) => {
    try {
        return SCartography.setFillOpaqueRate(fillOpaqueRate, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置线性渐变
 * 
 * @param layerName
 */
setFillLinearGradient = (layerName) => {
    try {
        return SCartography.setFillLinearGradient(layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置辐射渐变
 * 
 * @param layerName
 */
setFillRadialGradient = (layerName) => {
    try {
        return SCartography.setFillRadialGradient(layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置方形渐变
 * 
 * @param layerName
 */
setFillSquareGradient = (layerName) => {
    try {
        return SCartography.setFillSquareGradient(layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置无渐变
 * 
 * @param layerName
 */
setFillNoneGradient = (layerName) => {
    try {
        return SCartography.setFillNoneGradient(layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置透明度(0 - 100 % )
 * 
 * @param gridOpaqueRate
 * @param layerName
 */
setGridOpaqueRate = (gridOpaqueRate, layerName) => {
    try {
        return SCartography.setGridOpaqueRate(gridOpaqueRate, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置亮度(-100 % -100 % )
 * 
 * @param gridContrast
 * @param layerName
 */
setGridContrast = (gridContrast, layerName) => {
    try {
        return SCartography.setGridContrast(gridContrast, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置对比度(-100 % -100 % )
 * 
 * @param gridBrightness
 * @param layerName
 */
setGridBrightness = (gridBrightness, layerName) => {
    try {
        return SCartography.setGridBrightness(gridBrightness, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置文本字体的名称
 * 
 * @param fontName  字体名称,例如：“ 宋体”
 * @param geometryID 
 * @param layerName
 */
setTextFont = (fontName, geometryID, layerName) => {
    try {
        return SCartography.setTextFont(fontName, geometryID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置字号
 * 
 * @param size
 * @param geometryID 
 * @param layerName
 */
setTextFontSize = (size, geometryID, layerName) => {
    try {
        return SCartography.setTextFontSize(size, geometryID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置字体颜色
 * 
 * @param color
 * @param geometryID 
 * @param layerName
 */
setTextFontColor = (color, geometryID, layerName) => {
    try {
        return SCartography.setTextFontColor(color, geometryID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置旋转角度
 * 
 * @param angle
 * @param geometryID 
 * @param layerName
 */
setTextFontRotation = (angle, geometryID, layerName) => {
    try {
        return SCartography.setTextFontRotation(angle, geometryID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置位置
 * 
 * @param textAlignment 文本的对齐方式,例如: “TOPLEFT”,“ TOPCENTER”...
 * @param geometryID 
 * @param layerName
 */
setTextFontPosition = (textAlignment, geometryID, layerName) => {
    try {
        return SCartography.setTextFontPosition(textAlignment, geometryID, layerName)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置字体风格
 * 
 * @param style (加粗:BOLD、 斜体:ITALIC、 下划线:UNDERLINE、 删除线:STRIKEOUT、 轮廓:OUTLINE、 阴影:SHADOW)
 * @param geometryID 
 * @param layerName
 */
setTextStyle = (style, whether, geometryID, layerName) => {
    try {
        return SCartography.setTextStyle(style, whether, geometryID, layerName)
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