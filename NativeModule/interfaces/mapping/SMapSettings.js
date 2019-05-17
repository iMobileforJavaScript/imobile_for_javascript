/**
 * Copyright © SuperMap. All rights reserved.
 * Author: Asort
 * https://github.com/AsortKeven
 * 地图设置菜单类
 */
import { NativeModules, Platform } from 'react-native'
let SMap = NativeModules.SMap

/**
 * 获取当前地图比例尺是否显示
 * @returns {*}
 */
function getScaleViewEnable() {
  try{
    return SMap.getScaleViewEnable()
  }catch(e){
    console.error(e)
  }
}

/**
 * 设置当前地图比例尺是否显示
 * @param isEnable
 * @returns {*}
 */
function setScaleViewEnable(isEnable) {
  try{
    return SMap.setScaleViewEnable(isEnable)
  }catch(e){
    console.error(e)
  }
}

/**
 * 获取当前地图旋转角度
 * @returns {*}
 */
function getMapAngle() {
  try {
    return SMap.getMapAngle();
  }catch (e) {
    console.error(e)
  }
}

/**
 * 设置地图旋转角度
 * @param value
 * @returns {*}
 */
function setMapAngle(value) {
  try {
    return SMap.setMapAngle(value);
  }catch (e) {
    console.error(e)
  }
}
/**
 * 获取当前地图颜色模式
 * @returns {*}
 */
function getMapColorMode() {
  try {
    return SMap.getMapColorMode();
  }catch (e) {
    console.error(e)
  }
}

/**
 * 获取地图背景色
 * @returns {*}
 */
function getMapBackgroundColor() {
  try {
    return SMap.getMapBackgroundColor();
  }catch (e) {
    console.error(e)
  }
}

/**
 * 设置地图背景色
 * @param value 十六进制颜色 转换成rgb '#FFDE4D'
 * @returns {*}
 */
function setMapBackgroundColor(value) {
  try {
    let r = parseInt(`0x${value.substring(1,3)}`)
    let g = parseInt(`0x${value.substring(3,5)}`)
    let b = parseInt(`0x${value.substring(5,7)}`)
    return SMap.setMapBackgroundColor(r,g,b);
  }catch (e) {
    console.error(e)
  }
}
/**
 * 设置是否固定文本角度
 * @param value
 * @returns {*}
 */
function setTextFixedAngle(value) {
  try {
    return SMap.setTextFixedAngle(value);
  }catch (e) {
    console.error(e)
  }
}

/**
 * 获取是否固定文本角度
 * @returns {*}
 */
function getTextFixedAngle() {
  try {
    return SMap.getTextFixedAngle();
  }catch (e) {
    console.error(e)
  }
}

/**
 * 设置是否固定符号角度
 * @param value
 * @returns {*}
 */
function setMarkerFixedAngle(value) {
  try {
    return SMap.setMarkerFixedAngle(value);
  }catch (e) {
    console.error(e)
  }
}

/**
 * 获取是否固定符号角度
 * @param value
 * @returns {*}
 */
function getMarkerFixedAngle() {
  try {
    return SMap.getMarkerFixedAngle();
  }catch (e) {
    console.error(e)
  }
}

/**
 * 获取是否固定文本方向
 * @returns {*}
 */
function getFixedTextOrientation() {
  try {
    return SMap.getFixedTextOrientation();
  }catch (e) {
    console.error(e)
  }
}

/**
 * 设置是否固定文本方向
 * @param value
 * @returns {*}
 */
function setFixedTextOrientation(value) {
  try {
    return SMap.setFixedTextOrientation(value);
  }catch (e) {
    console.error(e)
  }
}

/**
 *  获取当前地图中心点
 * @returns {*}
 */
function getMapCenter() {
  try {
    return SMap.getMapCenter();
  }catch (e) {
    console.error(e)
  }
}


 /**
 * 设置当前地图中心点
 * @param x
 * @param y
 * @returns {*}
 */
function setMapCenter(x,y) {
  try {
    return SMap.setMapCenter(x,y);
  }catch (e) {
    console.error(e)
  }
}

/**
 * 获取地图比例尺
 * @returns {*}
 */
function getMapScale() {
  try {
    return SMap.getMapScale();
  }catch (e) {
    console.error(e)
  }
}

/**
 * 设置地图比例尺
 * @param value double 第二个数字 如 1:10.11 value为10.11
 * @returns {*}
 */
function setMapScale(value) {
  try {
    return SMap.setMapScale(value);
  }catch (e) {
    console.error(e)
  }
}

/**
 *  获取当前地图坐标系
 * @returns {Promise<PrjCoordSys>}
 */
function getPrjCoordSys() {
  try {
    return SMap.getPrjCoordSys();
  }catch (e) {
    console.error(e)
  }
}

export {
  getScaleViewEnable,
  setScaleViewEnable,
  getMapAngle,
  setMapAngle,
  setMapBackgroundColor,
  getMapBackgroundColor,
  getMapColorMode,
  getMarkerFixedAngle,
  setMarkerFixedAngle,
  getTextFixedAngle,
  setTextFixedAngle,
  getFixedTextOrientation,
  setFixedTextOrientation,
  getMapCenter,
  setMapCenter,
  getMapScale,
  setMapScale,
  getPrjCoordSys,
}