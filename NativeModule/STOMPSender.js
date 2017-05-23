/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let SPS = NativeModules.JSSTOMPSender;

/**
 * @class STOMPSender
 */
export default class STOMPSender{
    /**
     * 创建一个STOMPSender对象
     * @memberOf STOMPSender
     * @returns {Promise.<AMQPManager>}
     */
/*    async createObj(){
        try{
            var {_STOMPSenderId} = await SPS.createObj();
            var STOMPSenderObj = new STOMPSender();
            STOMPSenderObj.STOMPSenderId = _STOMPSenderId;
            return STOMPSenderObj;
        }catch(e){
            console.error(e);
        }
    }
 */
    /**
     * 发送消息。
     * @memberOf STOMPSender
     * @param {string}message - 待发送消息
     * @returns {Promise.<void>}
     */
    async sendMessage(message){
        try{
            await SPS.sendMessage(this.STOMPSenderId,message);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 释放对象。
     * @memberOf STOMPSender
     * @returns {Promise.<void>}
     */
    async dispose(){
        try{
            await SPS.dispose(this.STOMPSenderId);
        }catch(e){
            console.error(e);
        }
    }

}
