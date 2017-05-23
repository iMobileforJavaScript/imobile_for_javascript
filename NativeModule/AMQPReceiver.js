/**
 * Created by will on 2016/7/5.
 */
import {NativeModules,DeviceEventEmitter,NativeEventEmitter,Platform} from 'react-native';
let APR = NativeModules.JSAMQPReceiver;

const nativeEvt = new NativeEventEmitter(APR);
/**
 * @class Layer
 */
export default class AMQPReceiver{
    /**
     * 创建一个AMQPManager对象
     * @memberOf AMQPManager
     * @returns {Promise.<AMQPManager>}
     */
    /*
    async createObj(){
        try{
            var {_AMQPReceiverId} = await APR.createObj();
            var AMQPReceiverObj = new AMQPReceiver();
            AMQPReceiverObj.AMQPReceiverId = _AMQPReceiverId;
            return AMQPReceiverObj;
        }catch(e){
            console.error(e);
        }
    }
     */

    /**
     * 接收信息
     * @memberOf AMQPReceiver
     * @param {string}label - 条目标签
     * @returns {Promise.<void>}
     */
    async receiveMessage(queueNum,loadingMessage){
        try{
            switch(queueNum){
                case 1 : var str = "com.supermap.RN.JSAMQPReceiver.receive_message1";
                    break;
                case 2 : var str = "com.supermap.RN.JSAMQPReceiver.receive_message2";
                    break;
                case 3 : var str = "com.supermap.RN.JSAMQPReceiver.receive_message3";
                    break;
                case 4 : var str = "com.supermap.RN.JSAMQPReceiver.receive_message4";
                    break;
                case 5 : var str = "com.supermap.RN.JSAMQPReceiver.receive_message5";
                    break;
                default : var str = "com.supermap.RN.JSAMQPReceiver.receive_message1";
            }
            //差异化处理
            if(Platform.OS === 'ios'){
                nativeEvt.addListener(str,function (e) {
                                      if(typeof loadingMessage === 'function'){
                                      loadingMessage(e.clientId,e.message);
                                      }else{
                                      console.error("Please set a callback function to the first argument.");
                                      }
                                      });
                await APR.receiveMessage(this.AMQPReceiverId,str);
            }
        }catch(e){
            console.error(e);
        }
    }
}
