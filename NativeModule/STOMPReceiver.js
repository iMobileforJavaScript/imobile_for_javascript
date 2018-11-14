/**
 * Created by will on 2016/7/5.
 */
import {NativeModules,DeviceEventEmitter,NativeEventEmitter,Platform} from 'react-native';
let SPR = NativeModules.JSSTOMPReceiver;

const nativeEvt = new NativeEventEmitter(SPR);
/**
 * @class STOMPReceiver
 */
export default class STOMPReceiver{
    /**
     * 创建一个STOMPReceiver对象
     * @memberOf STOMPReceiver
     * @returns {Promise.<AMQPManager>}
     */
/*    async createObj(){
        try{
            var {_STOMPReceiverId} = await SPR.createObj();
            var STOMPReceiverObj = new STOMPReceiver();
            STOMPReceiverObj.STOMPReceiverId = _STOMPReceiverId;
            return STOMPReceiverObj;
        }catch(e){
            console.error(e);
        }
    }
*/
    /**
     * 接收信息
     * @memberOf STOMPReceiver
     * @returns {Promise.<void>}
     */
    async receiveMessage(queueNum,loadingMessage){
        try{
            switch(queueNum){
                case 1 : var str = "com.supermap.RN.JSSTOMPReceiver.receive_message1";
                    break;
                case 2 : var str = "com.supermap.RN.JSSTOMPReceiver.receive_message2";
                    break;
                case 3 : var str = "com.supermap.RN.JSSTOMPReceiver.receive_message3";
                    break;
                case 4 : var str = "com.supermap.RN.JSSTOMPReceiver.receive_message4";
                    break;
                case 5 : var str = "com.supermap.RN.JSSTOMPReceiver.receive_message5";
                    break;
                default : var str = "com.supermap.RN.JSSTOMPReceiver.receive_message1";
            }
            
            //差异化处理
            if(Platform.OS === 'ios'){
                nativeEvt.addListener(str,function (e) {
                                      if(typeof loadingMessage === 'function'){
                                      loadingMessage(e.message);
                                      }else{
                                      console.error("Please set a callback function to the first argument.");
                                      }
                                      });
                await SPR.receiveMessage(this.STOMPReceiverId,str);
            }
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 释放对象
     * @memberOf STOMPReceiver
     * @returns {Promise.<void>}
     */
    async dispose(){
        try{
            var {isDispose} = await SPR.dispose(this.STOMPReceiverId);
            return isDispose;
        }catch(e){
            console.error(e);
        }
    }
}
