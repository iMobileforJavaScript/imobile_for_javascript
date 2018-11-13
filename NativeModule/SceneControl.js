/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules,Platform} from 'react-native';
let SC = NativeModules.JSSceneControl;
import Scene from './Scene';

/**
 * @class SceneControl
 * @description 三维场景控件。
 */
export default class SceneControl {
    
    /**
     * 获取场景对象。
     * @memberOf SceneControl
     * @returns {Promise.<Scene>}
     */
    async getScene(){
        try{
            var {sceneId} = await SC.getScene(this.sceneControlId);
            var scene = new Scene();
            scene._SMSceneId = sceneId;

            return scene;
        }catch (e){
            
            console.error(e);
        }
    }
    
    async initWithViewCtrl(tag){
        try{
            if(Platform.OS === 'ios'){
            await SC.initWithViewCtrl(this.sceneControlId,tag);
            }
        }catch (e){
            console.error(e);
        }
    }

    async setGestureDetector(handlers){
        try{
            if(handlers){
                await SC.setGestureDetector(this.sceneControlId);
            }else{
                throw new Error("setGestureDetector need callback functions as first two argument!");
            }
            //差异化
            
            if(Platform.OS === 'ios'){
                /*
                if(typeof handlers.longPressHandler === "function"){
                    nativeEvt.addListener("com.supermap.RN.Mapcontrol.long_press_event",function (e) {
                        // longPressHandler && longPressHandler(e);
                        handlers.longPressHandler(e);
                    });
                }

                if(typeof handlers.scrollHandler === "function"){
                    nativeEvt.addListener('com.supermap.RN.Mapcontrol.scroll_event',function (e) {
                        scrollHandler && scrollHandler(e);
                    });
                }
                 */
            }else{
                if(typeof handlers.longPressHandler === "function"){
                    DeviceEventEmitter.addListener("com.supermap.RN.Mapcontrol.long_press_event",function (e) {
                        // longPressHandler && longPressHandler(e);
                        handlers.longPressHandler(e);
                    });
                }

                if(typeof handlers.scrollHandler === "function"){
                    DeviceEventEmitter.addListener('com.supermap.RN.Mapcontrol.scroll_event',function (e) {
                        scrollHandler && scrollHandler(e);
                    });
                }
            }

        }catch (e){
            console.error(e);
        }
    }
}
