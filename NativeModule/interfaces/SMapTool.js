/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 Description: 地图工具类
 **********************************************************************************/
import { NativeModules, Platform } from 'react-native'
import { EventConst } from '../constains'
let SMap = NativeModules.SMap
const Action = NativeModules.Action

/** 选择 **/
function select() {
  try {
    SMap.setAction(Action.SELECT)
  } catch (e) {
    console.error(e)
  }
}

/** 添加节点 **/
function addNode() {
  try {
    SMap.setAction(Action.VERTEXADD)
  } catch (e) {
    console.error(e)
  }
}

/** 编辑节点 **/
function editNode() {
  try {
    SMap.setAction(Action.VERTEXEDIT)
  } catch (e) {
    console.error(e)
  }
}

/** 删除节点 **/
function deleteNode() {
  try {
    SMap.setAction(Action.VERTEXDELETE)
  } catch (e) {
    console.error(e)
  }
}

/** 撤销 **/
function undo() {
  try {
    SMap.undo()
  } catch (e) {
    console.error(e)
  }
}

/** 重做 **/
function redo() {
  try {
    SMap.redo()
  } catch (e) {
    console.error(e)
  }
}

/** 绘制直线 **/
function createPolyline() {
  try {
    SMap.setAction(Action.CREATEPOLYLINE)
  } catch (e) {
    console.error(e)
  }
}

/** 绘制多边形 **/
function createPolygon() {
  try {
    SMap.setAction(Action.CREATEPOLYGON)
  } catch (e) {
    console.error(e)
  }
}

/** 删除 **/
function remove(id) {
  try {
    SMap.remove(id)
  } catch (e) {
    console.error(e)
  }
}

/** 平移 **/
function move() {
  try {
    SMap.setAction(Action.MOVE_GEOMETRY)
  } catch (e) {
    console.error(e)
  }
}

/** 切割面 **/
function splitRegion() {
  try {
    SMap.setAction(Action.SPLIT_BY_LINE)
  } catch (e) {
    console.error(e)
  }
}

/** 合并面 **/
function unionRegion() {
  try {
    SMap.setAction(Action.UNION_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 擦除面 **/
function eraseRegion() {
  try {
    SMap.setAction(Action.ERASE_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 手绘擦除面 **/
function drawRegionEraseRegion() {
  try {
    SMap.setAction(Action.DRAWREGION_ERASE_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 生成岛洞 **/
function drawHollowRegion() {
  try {
    SMap.setAction(Action.DRAW_HOLLOW_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 手绘岛洞 **/
function drawRegionHollowRegion() {
  try {
    SMap.setAction(Action.DRAWREGION_HOLLOW_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 填充岛洞 **/
function fillHollowRegion() {
  try {
    SMap.setAction(Action.FILL_HOLLOW_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 补充岛洞 **/
function patchHollowRegion() {
  try {
    SMap.setAction(Action.PATCH_HOLLOW_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 补充岛洞 **/
function submit() {
  try {
    SMap.setAction(Action.PATCH_HOLLOW_REGION)
  } catch (e) {
    console.error(e)
  }
}

/** 距离量算 **/
function measureLength(callBack = () => {}) {
  try {
    SMap.setAction(Action.MEASURELENGTH)
    addMeasureListener({
      lengthMeasured: callBack,
    })

  } catch (e) {
    console.error(e)
  }
}

/**  面积量算  **/
function measureArea(callBack = () => {}) {
  try {
    SMap.setAction(Action.MEASUREAREA)
    addMeasureListener({
      lengthMeasured: callBack,
    })
  } catch (e) {
    console.error(e)
  }
}

/**  面积量算  **/
function measureAngle(callBack = () => {}) {
  try {
    SMap.setAction(Action.MEASUREAREA)
    addMeasureListener({
      angleMeasured: callBack,
    })
  } catch (e) {
    console.error(e)
  }
}

/**  量算监听  **/
function addMeasureListener(events) {
  try {
    SMap.addMeasureListener(Action.MEASUREAREA).then(result => {
      if (!result) return
      let emitter = Platform.OS === 'ios' ? nativeEvt : DeviceEventEmitter
      if (typeof events.lengthMeasured === 'function') {
        emitter.addListener(EventConst.MEASURE_LENGTH, function (e) {
          events.lengthMeasured(e)
        })
      }
      if (typeof events.areaMeasured === 'function') {
        emitter.addListener(EventConst.MEASURE_AREA, function (e) {
          events.areaMeasured(e)
        })
      }
      if (typeof events.angleMeasured === 'function') {
        emitter.addListener(EventConst.MEASURE_ANGLE, function (e) {
          events.angleMeasured(e)
        })
      }
    })
  } catch (e) {
    console.error(e)
  }
}

/**  停止量算监听  **/
function removeMeasureListener(events) {
  try {
    SMap.addMeasureListener(Action.MEASUREAREA)
  } catch (e) {
    console.error(e)
  }
}

/**  无操作  **/
function pan(isResetAction = true) {
  try {
    SMap.setAction(Action.PAN)
  } catch (e) {
    console.error(e)
  }
}

export {
  select,
  addNode,
  editNode,
  deleteNode,
  undo,
  redo,
  createPolyline,
  createPolygon,
  remove,
  move,
  splitRegion,
  unionRegion,
  eraseRegion,
  drawRegionEraseRegion,
  drawHollowRegion,
  drawRegionHollowRegion,
  fillHollowRegion,
  patchHollowRegion,
  submit,
  measureLength,
  measureArea,
  measureAngle,
  pan,
  addMeasureListener,
  removeMeasureListener,
}