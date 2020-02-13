import {NativeModules, Platform, NativeEventEmitter, DeviceEventEmitter} from 'react-native'
import {EventConst} from '../../constains/index'

let SNavigationManager = NativeModules.SNavigationManager

const nativeEvt = new NativeEventEmitter(SNavigationManager)

/**
 * 导航结束监听
 * @param handlers
 */
function setIndustryNavigationListener(handlers) {
    try {
        if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
                nativeEvt.addListener(EventConst.INDUSTRYNAVIAGTION, function (e) {
                    handlers.callback(e);
                });
            }
        } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
                DeviceEventEmitter.addListener(EventConst.INDUSTRYNAVIAGTION, function (e) {
                    handlers.callback(e);
                });
            }
        }
    } catch (error) {
        console.error(error);
    }
}

/**
 * 主动停止导航监听
 * @param handlers
 */
function setStopNavigationListener(handlers) {
    try {
        if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
                nativeEvt.addListener(EventConst.STOPNAVIAGTION, function (e) {
                    handlers.callback(e);
                });
            }
        } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
                DeviceEventEmitter.addListener(EventConst.STOPNAVIAGTION, function (e) {
                    handlers.callback(e);
                });
            }
        }
    } catch (error) {
        console.error(error);
    }
}

/**
 * 绘制在线路径分析的路径
 * @param pathPoints
 * @returns {*}
 */
function drawOnlinePath(pathPoints) {
    try {
        return SNavigationManager.drawOnlinePath(pathPoints)
    } catch (e) {
        console.error(e)
    }
}

// /**
//  * 判断在线搜索的起始点是否在地图导航范围内
//  * @param startPoint
//  * @param endPoint
//  * @returns {*}
//  */
// function isPointsInMapBounds(startPoint, endPoint) {
//     try {
//         return SNavigationManager.isPointsInMapBounds(startPoint, endPoint)
//     } catch (e) {
//         console.error(e)
//     }
// }

/**
 * 清除导航路线
 * @returns {*|void|Promise<void>}
 */
function clearTrackingLayer() {
    try {
        return SNavigationManager.clearTrackingLayer()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置行业导航
 * @param selectedObj { "name":string,
 *                      "modelFileName":string,
 *                      "datrasourceName":string
 *                      }
 * @returns {*}
 */
function startNavigation(selectedObj) {
    try {
        return SNavigationManager.startNavigation(selectedObj)
    } catch (e) {
        console.error(e)
    }
}


/**
 * 设置室内导航
 * @returns {*|void|Promise<void>}
 */
function startIndoorNavigation() {
    try {
        return SNavigationManager.startIndoorNavigation()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 室外导航路径分析
 * @returns {*|void|Promise<void>}
 */
function beginNavigation(x1, y1, x2, y2) {
    try {
        return SNavigationManager.beginNavigation(x1, y1, x2, y2)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 室内导航路径分析
 * @returns {*|void|Promise<void>}
 */
function beginIndoorNavigation() {
    try {
        return SNavigationManager.beginIndoorNavigation()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 开启室内导航
 * @returns {*|void|Promise<void>}
 */
function indoorNavigation(firstP) {
    try {
        return SNavigationManager.indoorNavigation(firstP)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 是否在导航过程中（处理是否退出fullMap）
 * @returns {Promise<Promise.yes>|Promise<boolean>}
 */
function isGuiding() {
    try {
        return SNavigationManager.isGuiding()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 开启室外导航
 * @returns {*|void|Promise<void>}
 */
function outdoorNavigation(firstP) {
    try {
        return SNavigationManager.outdoorNavigation(firstP)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 设置当前楼层ID
 * @param floorID
 * @returns {*}
 */
function setCurrentFloorID(floorID) {
    try {
        return SNavigationManager.setCurrentFloorID(floorID)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取当前楼层ID
 * @returns {*}
 */
function getCurrentFloorID() {
    try {
        return SNavigationManager.getCurrentFloorID()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取当前楼层信息表中的楼层信息 并且初始化了楼层控件
 * @returns {*}
 */
function getFloorData() {
    try {
        return SNavigationManager.getFloorData()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取起始点
 * @param x
 * @param y
 * @param isindoor
 * @param floorID
 * @returns {undefined}
 */
function getStartPoint(x, y, isindoor, floorID = null) {
    try {
        return SNavigationManager.getStartPoint(x, y, isindoor, floorID)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取终点
 * @param x
 * @param y
 * @param isindoor
 * @param floorID
 * @returns {undefined}
 */
function getEndPoint(x, y, isindoor, floorID = null) {
    try {
        return SNavigationManager.getEndPoint(x, y, isindoor, floorID)
    } catch (e) {
        console.error(e)
    }
}


/**
 * 清除起终点
 * @returns {*|void|Promise<void>}
 */
function clearPoint() {
    try {
        if (SNavigationManager.clearPoint) {
            return SNavigationManager.clearPoint()
        } else {
            return true
        }
    } catch (e) {
        console.error(e)
    }
}

/**
 * 清除起终点
 * @returns {*|void|Promise<void>}
 */
function stopGuide() {
    try {
        if (SNavigationManager.stopGuide) {
            return SNavigationManager.stopGuide()
        } else {
            return true
        }
    } catch (e) {
        console.error(e)
    }
}


/**
 * 判断是否是室内点
 * @returns {*|void|Promise<void>}
 */
function isIndoorPoint(x, y) {
    try {
        return SNavigationManager.isIndoorPoint(x, y)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 打开实时路况信息
 * @returns {*|void|Promise<void>}
 */
function openTrafficMap(params) {
    try {
        return SNavigationManager.openTrafficMap(params)
    } catch (e) {
        console.error(e)
    }
}


/**
 * 判断是否打开实时路况
 * @returns {*|void|Promise<void>}
 */
function isOpenTrafficMap() {
    try {
        return SNavigationManager.isOpenTrafficMap()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 移除实时路况
 * @returns {*|void|Promise<void>}
 */
function removeTrafficMap(name) {
    try {
        return SNavigationManager.removeTrafficMap(name)
    } catch (e) {
        console.error(e)
    }
}

// /**
//  * 判断当前工作空间是否存在网络数据集
//  * @returns {*}
//  */
// function hasNetworkDataset() {
//     try {
//         return SNavigationManager.hasNetworkDataset()
//     } catch (e) {
//         console.error(e)
//     }
// }

/**
 * 判断当前工作空间是否存在线数据集
 * @returns {*}
 */
function hasLineDataset() {
    try {
        return SNavigationManager.hasLineDataset()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 将路网数据集添加到地图上
 * @returns {*|void|Promise<void>}
 */
function addNetWorkDataset() {
    try {
        return SNavigationManager.addNetWorkDataset()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 将路网数据集和线数据集从地图移除
 * @returns {undefined}
 */
function removeNetworkDataset() {
    try {
        return SNavigationManager.removeNetworkDataset()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 生成路网
 * @returns {undefined}
 */
function buildNetwork() {
    try {
        return SNavigationManager.buildNetwork()
    } catch (e) {
        console.error(e)
    }
}


/**
 * GPS开始
 * @returns {*|void|Promise<void>}
 */
function gpsBegin() {
    try {
        return SNavigationManager.gpsBegin()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 添加GPS轨迹
 * @returns {undefined}
 */
function addGPSRecordset() {
    try {
        return SNavigationManager.addGPSRecordset()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 拷贝室外地图网络模型snm文件
 * @returns {*|void|Promise<void>}
 */
function copyNaviSnmFile(path) {
    try {
        if (SNavigationManager.copyNaviSnmFile) {
            return SNavigationManager.copyNaviSnmFile(path)
        } else {
            return true
        }
    } catch (e) {
        console.error(e)
    }
}


/**
 * 地图选点起点地理名称监听
 * @param handlers
 */
let setStartPointNameListener = handlers => {
    try {
        //if(this.startPointSelectListener) return
        if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
                this.startPointSelectListener = nativeEvt.addListener(EventConst.MAPSELECTPOINTNAMESTART, function (e) {
                    handlers.callback(e);
                });
            }
        } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
                this.startPointSelectListener = DeviceEventEmitter.addListener(EventConst.MAPSELECTPOINTNAMESTART, function (e) {
                    handlers.callback(e);
                });
            }
        }
    } catch (error) {
        console.error(error);
    }
}

/**
 * 地图选点终点地理名称监听
 * @param handlers
 */
let setEndPointNameListener = handlers => {
    try {
        //if(this.endPointSelectListener) return
        if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
                this.endPointSelectListener = nativeEvt.addListener(EventConst.MAPSELECTPOINTNAMEEND, function (e) {
                    handlers.callback(e);
                });
            }
        } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
                this.endPointSelectListener = DeviceEventEmitter.addListener(EventConst.MAPSELECTPOINTNAMEEND, function (e) {
                    handlers.callback(e);
                });
            }
        }
    } catch (error) {
        console.error(error);
    }
}


/**
 * 初始化导航语音播报
 * @returns {boolean|Promise<void>}
 */
function initSpeakPlugin() {
    try {
        if (Platform.OS === 'android') {
            return SNavigationManager.initSpeakPlugin();
        } else {
            return true;
        }
    } catch (error) {
        console.warn(error)
    }
}

/**
 * 销毁语音播报
 * @returns {boolean|*}
 */
function destroySpeakPlugin() {
    try {
        if (Platform.OS === 'android') {
            return SNavigationManager.destroySpeakPlugin();
        } else {
            return true;
        }
    } catch (error) {
        console.warn(error)
    }
}

/**
 * 获取导航路径长度
 * @param isIndoor 是否室内
 * @returns {*}
 */
function getNavPathLength(isIndoor) {
    try {
        return SNavigationManager.getNavPathLength(isIndoor)
    } catch (e) {
        console.error(e)
    }
}

// /**
//  * 判断当前地图是否是室内地图
//  * @returns {*}
//  */
// function isIndoorMap() {
//     try {
//         return SNavigationManager.isIndoorMap()
//     } catch (e) {
//         console.error(e)
//     }
// }

/**
 * 判断当前点是否在数据集的bounds范围内
 * @param point
 * @param networkDataset
 * @returns {*}
 */
function isInBounds(point, networkDataset = null) {
    try {
        return SNavigationManager.isInBounds(point, networkDataset)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取当前地理位置信息 返回地理坐标
 * @returns {*}
 */
function getCurrentMapPosition() {
    try {
        return SNavigationManager.getCurrentMapPosition()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取导航路径详情
 * @param isIndoor 是否室内
 * @returns {*}
 */
function getPathInfos(isIndoor) {
    try {
        return SNavigationManager.getPathInfos(isIndoor)
    } catch (e) {
        console.error(e)
    }
}


/**
 * 打开数据源，用于室外导航
 * @param params
 * @returns {*}
 */
function openNavDatasource(params) {
    try {
        return SNavigationManager.openNavDatasource(params)
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取数据源中含有的所有网络数据集
 * @param udb
 * @returns {*}
 */
function getNetworkDataset() {
    try {
        return SNavigationManager.getNetworkDataset()
    } catch (e) {
        console.error(e)
    }
}

/**
 * 获取点所在的所有导航数据源（室内）数据集（室外）
 * @param x
 * @param y
 * @returns {*}
 */
function getPointBelongs(x,y) {
    try{
        return SNavigationManager.getPointBelongs(x,y)
    }catch (e) {
        console.error(e)
    }
}

/**
 * 获取到起始点距离最近的门的位置
 * @param params
 * @returns {*}
 */
function getDoorPoint(params) {
    try {
        return SNavigationManager.getDoorPoint(params)
    }catch (e) {
        console.error(e)
    }
}

/**
 * 添加引导线（分段导航）
 * @param startPoint
 * @param endPoint
 * @returns {*}
 */
function addLineOnTrackingLayer(startPoint, endPoint) {
    try {
        return SNavigationManager.addLineOnTrackingLayer(startPoint, endPoint)
    }catch (e) {
        console.error(e)
    }
}

/**
 * 清除导航路线和跟踪层，不清除callout点
 * @returns {*}
 */
function clearPath() {
    try {
        return SNavigationManager.clearPath()
    }catch (e) {
        console.error(e)
    }
}
export {
    setIndustryNavigationListener,
    setStopNavigationListener,
    drawOnlinePath,
    // isPointsInMapBounds,
    clearTrackingLayer,
    startNavigation,
    startIndoorNavigation,
    beginNavigation,
    beginIndoorNavigation,
    outdoorNavigation,
    indoorNavigation,
    getCurrentFloorID,
    setCurrentFloorID,
    getFloorData,
    getStartPoint,
    getEndPoint,
    clearPoint,
    stopGuide,
    isIndoorPoint,
    openTrafficMap,
    isOpenTrafficMap,
    removeTrafficMap,
    addNetWorkDataset,
    removeNetworkDataset,
    buildNetwork,
    // hasNetworkDataset,
    hasLineDataset,
    gpsBegin,
    addGPSRecordset,
    copyNaviSnmFile,
    isGuiding,
    setStartPointNameListener,
    setEndPointNameListener,
    // isIndoorMap,
    getCurrentMapPosition,
    isInBounds,
    openNavDatasource,
    getNetworkDataset,
    getPathInfos,
    getNavPathLength,
    initSpeakPlugin,
    destroySpeakPlugin,
    getPointBelongs,
    getDoorPoint,
    addLineOnTrackingLayer,
    clearPath,
}