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
export {
  getScaleViewEnable,
  setScaleViewEnable,
  getMapAngle,
  getMapColorMode,
}