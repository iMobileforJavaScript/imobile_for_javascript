import {
    NativeModules,
    Platform
} from 'react-native'
import SSceneTool from './SSceneTool'
let SScene = NativeModules.SScene
export default (function () {
    /**
     * 打开工作空间
     * @param infoDic
     * @returns {Promise}
     */
    function openWorkspace(infoDic) {
        debugger
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
        debugger
        try {
            return SScene.openMap(name)
        } catch (error) {
            console.log(error)
        }
    }

    function getMapList() {
        debugger
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
    function closeWorkspace(){
        try {
            return SScene.closeWorkspace()
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
    }
    Object.assign(SSceneExp, SSceneTool)
    return SSceneExp
})()