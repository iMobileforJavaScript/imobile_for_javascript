import {
    NativeModules,
    DeviceEventEmitter, 
    NativeEventEmitter,
    Platform
} from 'react-native'
import { Map3DEventConst } from '../constains'
import SSceneTool from './SSceneTool'
let SScene = NativeModules.SScene
const nativeEvt = new NativeEventEmitter(SScene);
export default (function () {
    /**
     * 打开工作空间
     * @param infoDic
     * @returns {Promise}
     */
    function openWorkspace(infoDic) {
        try {
            const type = infoDic.server.split('.').pop()
            Object.assign(infoDic, {
                type: getWorkspaceType(type)
            })
            return SScene.openWorkspace(infoDic)
        } catch (e) {
            console.error(e)
        }
    }

    function openMap(name) {
        try {
            return SScene.openMap(name)
        } catch (error) {
            console.log(error)
        }
    }

    function getMapList() {
        try {
            return SScene.getMapList()
        } catch (error) {
            console.log(error)
        }
    }

    function getLayerList() {
        try {
            return SScene.getLayerList()
        } catch (error) {
            console.log(error)
        }
    }

    function setVisible(name,value) {
        try {
            return SScene.setVisible(name,value)
        } catch (error) {
            console.log(error)
        }
    }

    function setSelectable(name,value) {
        try {
            return SScene.setSelectable(name,value)
        } catch (error) {
            console.log(error)
        }
    }

    function closeWorkspace(){
        try {
            return SScene.closeWorkspace()
        } catch (error) {
            console.log(error)
        }
    }

    function getFlyRouteNames(){
        try {
            return SScene. getFlyRouteNames()
        } catch (error) {
            console.log(error)
        }
    }

    function setPosition(index){
        try {
            return SScene.setPosition(index)
        } catch (error) {
            console.log(error)
        }
    }
    
    function flyStart (){
        try {
            return SScene.flyStart()
        } catch (error) {
            console.log(error)
        }
    }

    function flyPause(){
        try {
            return SScene.flyPause()
        } catch (error) {
            console.log(error)
        }
    }
    function flyPauseOrStart(){
        try {
            return SScene.flyPauseOrStart()
        } catch (error) {
            console.log(error)
        }
    }

    function flyStop(){
        try {
            return SScene.flyStop()
        } catch (error) {
            console.log(error)
        }
    }

    function getFlyProgress(handlers){
        try {
            if (Platform.OS === 'ios' && handlers) {
                if (typeof handlers.callback === 'function') {
                  nativeEvt.addListener(Map3DEventConst.SSCENE_FLY, function (e) {
                    handlers.callback(e)
                  })
                }
              } else if (Platform.OS === 'android' && handlers) {
                if (typeof handlers.callback === "function") {
                  DeviceEventEmitter.addListener(Map3DEventConst.SSCENE_FLY, function (e) {
                     handlers.callback(e);
                  });
                }
              }
              return SScene.getFlyProgress()
        } catch (error) {
            console.log(error)
        }
    }

    function zoom(scale){
        try {
            return SScene.zoom(scale)
        } catch (error) {
            console.log(error)
        }
    }

    function getAttribute(handlers){
        try {
            if (Platform.OS === 'ios' && handlers) {
                if (typeof handlers.callback === 'function') {
                  nativeEvt.addListener(Map3DEventConst.SSCENE_ATTRIBUTE, function (e) {
                    handlers.callback(e)
                  })
                }
              } else if (Platform.OS === 'android' && handlers) {
                if (typeof handlers.callback === "function") {
                  DeviceEventEmitter.addListener(Map3DEventConst.SSCENE_ATTRIBUTE, function (e) {
                     handlers.callback(e);
                  });
                }
              }
            return SScene.getAttribute()
        } catch (error) {
            console.log(error)
        }
    }
    getWorkspaceType = (type) => {
        var value
        switch (type) {
          case 'SMWU':
          case 'smwu':
            value = 9
            break
          case 'SXWU':
          case 'sxwu':
            value = 8
            break
          case 'SMW':
          case 'smw':
            value = 5
            break
          case 'SXW':
          case 'sxw':
            value = 4
            break
          case 'UDB':
          case 'udb':
            value = 219
            break
          default:
            value = 1
            break
        }
        return value
      }
    let SSceneExp = {
        openWorkspace,
        closeWorkspace,
        setVisible,
        getLayerList,
        getMapList,
        openMap,
        setSelectable,
        getFlyRouteNames,
        setPosition,
        flyStart,
        flyPause,
        flyPauseOrStart,
        flyStop,
        getFlyProgress,
        zoom,
        getAttribute,
    }
    Object.assign(SSceneExp, SSceneTool)
    return SSceneExp
})()