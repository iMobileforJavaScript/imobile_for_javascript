import {
    NativeModules,
    DeviceEventEmitter,
    NativeEventEmitter,
    Platform
} from 'react-native'
import {
    EventConst
} from '../../constains/index'
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

    function getTerrainLayerList() {
        try {
            return SScene.getTerrainLayerList()
        } catch (error) {
            console.log(error)
        }
    }

    function setTerrainLayerListVisible(name, value) {
        try {
            return SScene.setTerrainLayerListVisible(name, value)
        } catch (error) {
            console.log(error)
        }
    }

    function setVisible(name, value) {
        try {
            return SScene.setVisible(name, value)
        } catch (error) {
            console.log(error)
        }
    }

    function setSelectable(name, value) {
        try {
            return SScene.setSelectable(name, value)
        } catch (error) {
            console.log(error)
        }
    }

    function closeWorkspace() {
        try {
            return SScene.closeWorkspace()
        } catch (error) {
            console.log(error)
        }
    }

    function getFlyRouteNames() {
        try {
            return SScene.getFlyRouteNames()
        } catch (error) {
            console.log(error)
        }
    }

    function setPosition(index) {
        try {
            return SScene.setPosition(index)
        } catch (error) {
            console.log(error)
        }
    }

    function flyStart() {
        try {
            return SScene.flyStart()
        } catch (error) {
            console.log(error)
        }
    }

    function flyPause() {
        try {
            return SScene.flyPause()
        } catch (error) {
            console.log(error)
        }
    }

    function flyPauseOrStart() {
        try {
            return SScene.flyPauseOrStart()
        } catch (error) {
            console.log(error)
        }
    }

    function flyStop() {
        try {
            return SScene.flyStop()
        } catch (error) {
            console.log(error)
        }
    }

    function getFlyProgress(handlers) {
        try {
            if (Platform.OS === 'ios' && handlers) {
                if (typeof handlers.callback === 'function') {
                    nativeEvt.addListener(EventConst.SSCENE_FLY, function (e) {
                        handlers.callback(e)
                    })
                }
            } else if (Platform.OS === 'android' && handlers) {
                if (typeof handlers.callback === "function") {
                    DeviceEventEmitter.addListener(EventConst.SSCENE_FLY, function (e) {
                        handlers.callback(e);
                    });
                }
            }
            return SScene.getFlyProgress()
        } catch (error) {
            console.log(error)
        }
    }

    function zoom(scale) {
        try {
            return SScene.zoom(scale)
        } catch (error) {
            console.log(error)
        }
    }

    function setListener(){
        try {
            return SScene.setListener()
        } catch (error) {
            console.log(error)
        }
    }

    function getAttribute() {
        try {
            // if (Platform.OS === 'ios' && handlers) {
            //     if (typeof handlers.callback === 'function') {
            //         nativeEvt.addListener(EventConst.SSCENE_ATTRIBUTE, function (e) {
            //             handlers.callback(e)
            //         })
            //     }
            // } else if (Platform.OS === 'android' && handlers) {
            //     if (typeof handlers.callback === "function") {
            //         DeviceEventEmitter.addListener(EventConst.SSCENE_ATTRIBUTE, function (e) {
            //             handlers.callback(e)
            //         });
            //     }
            // }
            return SScene.getAttribute()
        } catch (error) {
            console.log(error)
        }
    }


    function addAttributeListener(handlers) {
        let listen
        if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
                listen = nativeEvt.addListener(EventConst.SSCENE_ATTRIBUTE, function (e) {
                    handlers.callback(e)
                })
            }
        } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
                listen = DeviceEventEmitter.addListener(EventConst.SSCENE_ATTRIBUTE, function (e) {
                    handlers.callback(e)
                });
            }
        }
        return listen
    }


    function setHeading() {
        try {
            return SScene.setHeading()
        } catch (error) {
            console.log(error)
        }
    }

    function changeBaseMap(oldLayer, Url, Layer3DType, layerName, imageFormatType, dpi, addToHead) {
        try {
            return SScene.changeBaseMap(oldLayer, Url, Layer3DType, layerName, imageFormatType, dpi, addToHead)
        } catch (error) {
            console.log(error)
        }

    }

    function clearSelection() {
        try {
            return SScene.clearSelection()
        } catch (error) {
            console.log(error)
        }
    }

    function initsymbol() {
        try {
            return SScene.initsymbol()
        } catch (error) {
            console.log(error)
        }
    }

    function startDrawPoint() {
        try {
            return SScene.startDrawPoint()
        } catch (error) {
            console.log(error)
        }
    }

    function startDrawLine() {
        try {
            return SScene.startDrawLine()
        } catch (error) {
            console.log(error)
        }
    }

    function startDrawArea() {
        try {
            return SScene.startDrawArea()
        } catch (error) {
            console.log(error)
        }
    }

    function startDrawText(handlers) {
        try {
            if (Platform.OS === 'ios' && handlers) {
                if (typeof handlers.callback === 'function') {
                    nativeEvt.addListener(EventConst.SSCENE_SYMBOL, function (e) {
                        handlers.callback(e)
                    })
                }
            } else if (Platform.OS === 'android' && handlers) {
                if (typeof handlers.callback === "function") {
                    DeviceEventEmitter.addListener(EventConst.SSCENE_SYMBOL, function (e) {
                        handlers.callback(e);
                    });
                }
            }
            return SScene.startDrawText()
        } catch (error) {
            console.log(error)
        }
    }

    function addGeoText(x,y,z,text) {
        try {
            return SScene.addGeoText(x, y,z,text)
        } catch (error) {
            console.log(error)
        }
    }

    function symbolback() {
        try {
            return SScene.symbolback()
        } catch (error) {
            console.log(error)
        }
    }

    function closeAllLabel() {
        try {
            return SScene.closeAllLabel()
        } catch (error) {
            console.log(error)
        }
    }

    function clearAllLabel() {
        try {
            return SScene.clearAllLabel()
        } catch (error) {
            console.log(error)
        }
    }

    function clearcurrentLabel() {
        try {
            return SScene.clearcurrentLabel()
        } catch (error) {
            console.log(error)
        }
    }

    function save() {
        try {
            return SScene.save()
        } catch (error) {
            console.log(error)
        }
    }

    function setAllLayersSelection(value) {
        try {
            return SScene.setAllLayersSelection(value)
        } catch (error) {
            console.log(error)
        }
    }

    function addTerrainLayer(url, name) {
        try {
            return SScene.addTerrainLayer(url, name)
        } catch (error) {
            console.log(error)
        }
    }

    function addLayer3D(Url, Layer3DType, layerName, imageFormatType, dpi, addToHead,token) {
        try {
            // console.log(SScene.addLayer3D)
            return SScene.addLayer3D( Url, Layer3DType, layerName, imageFormatType, dpi, addToHead,token)
        } catch (error) {
            console.log(error)
        }
    }

    function startDrawFavorite(handlers) {
        try {
            if (Platform.OS === 'ios' && handlers) {
                if (typeof handlers.callback === 'function') {
                    nativeEvt.addListener(EventConst.SSCENE_FAVORITE, function (e) {
                        handlers.callback(e)
                    })
                }
            } else if (Platform.OS === 'android' && handlers) {
                if (typeof handlers.callback === "function") {
                    DeviceEventEmitter.addListener(EventConst.SSCENE_FAVORITE, function (e) {
                        handlers.callback(e);
                    });
                }
            }
            return SScene.startDrawFavorite()
        } catch (error) {
            console.log(error)
        }
    }

    function setFavoriteText(content) {
        try {
            return SScene.setFavoriteText(content)
        } catch (error) {
            console.log(error)
        }
    }
    
    function getcompass(){
        try {
            return SScene.getcompass()
        } catch (error) {
            console.log(error)
        }
    }

    function checkoutListener(event){
        try {
            return SScene.checkoutListener(event)
        } catch (error) {
            console.log(error)
        }
    }
    
    function setCircleFly(){
        try {
            return SScene.getFlyPoint()
        } catch (error) {
            console.log(error)
        }
    }

    function addCircleFlyListen(handlers){
        let listen
        if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
                listen=nativeEvt.addListener(EventConst.SSCENE_CIRCLEFLY, function (e) {
                    handlers.callback(e)
                })
            }
        } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
                listen= DeviceEventEmitter.addListener(EventConst.SSCENE_CIRCLEFLY, function (e) {
                    handlers.callback(e);
                });
            }
        }
        return listen
    }
    
    function startCircleFly(){
        try {
            return SScene.setCircleFly()
        } catch (error) {
            console.log(error)
        }
    }

    function stopCircleFly(){
        try {
            return SScene.stopCircleFly()
        } catch (error) {
            console.log(error)
        }
    }

    function clearCirclePoint(){
        try {
            return SScene.clearCirclePoint()
        } catch (error) {
            console.log(error)
        }
    }

     function clearLineAnalyst(){
        return SScene.setMeasureLineAnalyst()
      }
      
       function clearSquareAnalyst(){
        return SScene.setMeasureSquareAnalyst()
      }
      
       function setMeasureLineAnalyst(handlers) {
        try {
          if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
               nativeEvt.addListener(EventConst.ANALYST_MEASURELINE, function (e) {
                handlers.callback(e)
              })
            }
          } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
                DeviceEventEmitter.addListener(EventConst.ANALYST_MEASURELINE, function (e) {
                handlers.callback(e);
              });
            }
          }
          return SScene.setMeasureLineAnalyst()
        } catch (e) {
          console.error(e);
        }
      }
      
      
       function setMeasureSquareAnalyst(handlers) {
        try {
          if (Platform.OS === 'ios' && handlers) {
            if (typeof handlers.callback === 'function') {
              nativeEvt.addListener(EventConst.ANALYST_MEASURESQUARE, function (e) {
                handlers.callback(e)
              })
            }
          } else if (Platform.OS === 'android' && handlers) {
            if (typeof handlers.callback === "function") {
               DeviceEventEmitter.addListener(EventConst.ANALYST_MEASURESQUARE, function (e) {
                handlers.callback(e);
              });
            }
          }
          return SScene.setMeasureSquareAnalyst()
        } catch (e) {
          console.error(e);
        }
      }
      
      
       function closeAnalysis() {
        try {
            return SScene.closeAnalysis()
        } catch (e) {
          console.error(e);
        }
      }

      function removeKMLOfWorkcspace(){
           try {
               return SScene.removeKMLOfWorkcspace()
           } catch (e) {
            console.error(e);
           }
      }

      function doZipFiles(fileList,toPath){
          try {
              return SScene.doZipFiles(fileList,toPath)
          } catch (error) {
            console.error(error);
          }
      }

      function getWorkspacePath(){
          try {
              return SScene.getWorkspacePath()
          } catch (error) {
            console.error(error);
          }
      }

      function getLableAttributeList(){
          try {
              return SScene.getLableAttributeList()
          } catch (error) {
            console.error(error);
          }
      }
      
      function flyToFeatureById(){
          try {
              return SScene.flyToFeatureById()
          } catch (error) {
            console.error(error);
          }
      }

      function getSetting(){
          try {
              return SScene.getSetting()
          } catch (error) {
            console.error(error);
          }
      }

    function import3DWorkspace(infoDic){
        try {
          const type = infoDic.server.split('.').pop()
          Object.assign(infoDic, {
              type: getWorkspaceType(type)
          })
            return SScene.import3DWorkspace(infoDic)
        } catch (error) {
          console.error(error);
        }
    }

    function openScence(name){
        try {
            return SScene.openScence(name)
        } catch (error) {
          console.error(error); 
        }
    }
    
    function is3DWorkspace(infoDic){
        try {
            // console.warn("is3DWorkspace")
            // console.log(SScene)
            // return
          const type = infoDic.server.split('.').pop()
          Object.assign(infoDic, {
              type: getWorkspaceType(type)
          })
            return SScene.is3DWorkspace(infoDic)
        } catch (error) {
          console.error(error); 
        }
    }

    function setCustomerDirectory(path){
        try {
            return SScene.setCustomerDirectory(path)
        } catch (error) {
          console.error(error);  
        }
    }
    
    function export3DScenceName(strScenceName,strDesFolder){
        try {
            return SScene.export3DScenceName(strScenceName,strDesFolder)
        } catch (error) {
            console.error(error);
        }
    }

    function resetCamera(){
        try {
            return SScene.resetCamera()
        } catch (error) {
            console.error(error);
        }
    }
<<<<<<< HEAD
=======
    
    function setNavigationControlVisible(value){
        try {
            return SScene.setNavigationControlVisible(value)
        } catch (error) {
            console.error(error);
        }
    }
>>>>>>> 3edb4023dd2e53f44ac5c6cd3201fa195b3b9267

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
        setListener,
        getAttribute,
        addAttributeListener,
        setTerrainLayerListVisible,
        getTerrainLayerList,
        setHeading,
        changeBaseMap,
        clearSelection,
        initsymbol,
        startDrawPoint,
        startDrawLine,
        startDrawArea,
        startDrawText,
        addGeoText,
        symbolback,
        closeAllLabel,
        clearAllLabel,
        clearcurrentLabel,
        save,
        setAllLayersSelection,
        addTerrainLayer,
        addLayer3D,
        startDrawFavorite,
        setFavoriteText,
        getcompass,
        checkoutListener,
        setCircleFly,
        startCircleFly,
        stopCircleFly,
        clearCirclePoint,
        addCircleFlyListen,
        setMeasureLineAnalyst,
        setMeasureSquareAnalyst,
        closeAnalysis,
        clearLineAnalyst,
        clearSquareAnalyst,
        removeKMLOfWorkcspace,
        doZipFiles,
        getWorkspacePath,
        getLableAttributeList,
        flyToFeatureById,
        getSetting,
        import3DWorkspace,
        openScence,
        is3DWorkspace,
        setCustomerDirectory,
        export3DScenceName,
        resetCamera,
<<<<<<< HEAD
=======
        setNavigationControlVisible,
>>>>>>> 3edb4023dd2e53f44ac5c6cd3201fa195b3b9267
    }
    Object.assign(SSceneExp, SSceneTool)
    return SSceneExp
})()