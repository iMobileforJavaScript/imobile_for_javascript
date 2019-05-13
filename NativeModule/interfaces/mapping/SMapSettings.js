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
 * 设置当前地图是否固定比例尺级别
 * @param value
 * @returns {*}
 */
function setFixedScale(value) {
  try {
    return SMap.setFixedScale(value);
  }catch (e) {
    console.error(e)
  }
}

/**
 *  获取当前地图是否固定比例尺级别
 * @returns {*}
 */
function getFixedScale() {
  try {
    return SMap.getFixedScale();
  }catch (e) {
    console.error(e)
  }
}

export {
  getScaleViewEnable,
  setScaleViewEnable,
  getMapAngle,
  getMapColorMode,
  getMapCenter,
  setMapCenter,
  getMapScale,
  setMapScale,
  getFixedScale,
  setFixedScale,
}