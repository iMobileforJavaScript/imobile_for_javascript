/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let SPR = NativeModules.JSSTOMPReceiver;

/**
 * @class STOMPReceiver
 */
export default class STOMPReceiver{
    /**
     * 创建一个STOMPReceiver对象
     * @memberOf STOMPReceiver
     * @returns {Promise.<AMQPManager>}
     */
    async createObj(){
        try{
            var {_STOMPReceiverId} = await SPR.createObj();
            var STOMPReceiverObj = new STOMPReceiver();
            STOMPReceiverObj.STOMPReceiverId = _STOMPReceiverId;
            return STOMPReceiverObj;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 接收信息
     * @memberOf STOMPReceiver
     * @returns {Promise.<void>}
     */
    async receive(){
        try{
            var {message} = await SPR.receive(this.STOMPReceiverId);
            return message;
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
