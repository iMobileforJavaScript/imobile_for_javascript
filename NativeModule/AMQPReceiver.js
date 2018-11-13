/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/

import {NativeModules,DeviceEventEmitter,NativeEventEmitter,Platform} from 'react-native';
let APR = NativeModules.JSAMQPReceiver;

const nativeEvt = new NativeEventEmitter(APR);
/**
 * @class AMQPReceiver
 * @description AMQP消息接收类(该类不能创建实例，需通过AMQPManager.newReceiver()创建实例)。（暂不支持安卓设备）
 */
export default class AMQPReceiver{

    /**
     * 接收信息
     * @memberOf AMQPReceiver
     * @param {string} queueNum - 消息队列序号（1-5，默认为1）。
     * @param {function} loadingMessage - 回调方法，用于处理接收到信息。
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
                await APR.receiveMessage(this._SMAMQPReceiverId,str);
            }
        }catch(e){
            console.error(e);
        }
    }
}
