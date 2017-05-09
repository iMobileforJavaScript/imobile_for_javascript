import {NativeModules,Platform} from 'react-native';
let SC = NativeModules.JSSceneControl;
import Scene from './Scene';

export default class SceneControl {
    async getScene(){
        try{
            var {sceneId} = await SC.getScene(this.sceneControlId);
            var scene = new Scene();
            scene.sceneId = sceneId;

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
                    nativeEvt.addListener("com.supermap.RN.JSMapcontrol.long_press_event",function (e) {
                        // longPressHandler && longPressHandler(e);
                        handlers.longPressHandler(e);
                    });
                }

                if(typeof handlers.scrollHandler === "function"){
                    nativeEvt.addListener('com.supermap.RN.JSMapcontrol.scroll_event',function (e) {
                        scrollHandler && scrollHandler(e);
                    });
                }
                 */
            }else{
                if(typeof handlers.longPressHandler === "function"){
                    DeviceEventEmitter.addListener("com.supermap.RN.JSMapcontrol.long_press_event",function (e) {
                        // longPressHandler && longPressHandler(e);
                        handlers.longPressHandler(e);
                    });
                }

                if(typeof handlers.scrollHandler === "function"){
                    DeviceEventEmitter.addListener('com.supermap.RN.JSMapcontrol.scroll_event',function (e) {
                        scrollHandler && scrollHandler(e);
                    });
                }
            }

        }catch (e){
            console.error(e);
        }
    }
}
