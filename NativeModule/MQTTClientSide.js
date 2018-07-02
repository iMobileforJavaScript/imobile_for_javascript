/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules,DeviceEventEmitter,NativeEventEmitter,Platform} from 'react-native';
let MTS = NativeModules.JSMQTTClientSide;

const nativeEvt = new NativeEventEmitter(MTS);
/**
 * @class MQTTClientSide
 * @description MQTT连接客户端类。
 */
export default class MQTTClientSide{
    /**
     * 创建一个MQTTClientSide对象
     * @memberOf MQTTClientSide
     * @returns {Promise.<AMQPManager>}
     */
    async createObj(){
        try{
            var {_MQTTClientSideId} = await MTS.createObj();
            var MQTTClientSideObj = new MQTTClientSide();
            MQTTClientSideObj.MQTTClientSideId = _MQTTClientSideId;
            return MQTTClientSideObj;
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 创建连接。
     * @memberOf MQTTClientSide
     * @param {string} URI - 服务地址
     * @param {string} userName - 账户
     * @param {string} passWord - 密码
     * @param {string} clientId - 客户端ID
     * @returns {Promise.<boolean>}
     */
    async create(URI,userName,passWord,clientId){
        try{
            var {isConnection} = await MTS.create(this.MQTTClientSideId,URI,userName,passWord,clientId);
            return isConnection;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 向topic主题发送消息。
     * @memberOf MQTTClientSide
     * @param {string} topic - 主题名称
     * @param {string} message - 消息
     * @returns {Promise.<boolean>}
     */
    async sendMessage(topic,message){
        try{
            var {send} = await MTS.sendMessage(this.MQTTClientSideId,topic,message);
            return send;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 接收消息
     * @memberOf MQTTClientSide
     * @param {number} queueNum - 队列序号（1-5,默认为1）
     * @param {function} loadingMessage - loadingMessage (e){}(e.topic 订阅主题；e.messgae 收到的消息)
     * @returns {Promise.<bool>}
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
                                      loadingMessage(e.topic,e.message);
                                      }else{
                                      console.error("Please set a callback function to the first argument.");
                                      }
                                      });
                await MTS.receiveMessage(this.MQTTClientSideId,str);
            }
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 订阅某一主题
     * @memberOf MQTTClientSide
     * @param {string} topicName - 订阅主题
     * @param {number} qos - 传输质量
     * @returns {Promise.<void>}
     */
    async subscribe(topicName,qos){
        try{
            var {isSubscribe} = await MTS.subscribe(this.MQTTClientSideId,topicName,qos);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 取消某一主题的订阅
     * @memberOf MQTTClientSide
     * @param {string} topicName - 订阅主题
     * @returns {Promise.<bool>}
     */
    async unsubscribe(topic){
        try{
            var {unSubscribe} = await MTS.unsubscribe(this.MQTTClientSideId,topic);
            return unSubscribe;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 挂起
     * @memberOf MQTTClientSide
     * @returns {Promise.<void>}
     */
    async suspend(){
        try{
            await MTS.suspend(this.MQTTClientSideId);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 唤醒
     * @memberOf MQTTClientSide
     * @returns {Promise.<bool>}
     */
    async resume(){
        try{
            var{isResume} = await MTS.resume(this.MQTTClientSideId);
            return isResume;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 取消连接，并销毁对象
     * @memberOf MQTTClientSide
     * @returns {Promise.<void>}
     */
    async dispose(){
        try{
            await MTS.dispose(this.MQTTClientSideId);
        }catch(e){
            console.error(e);
        }
    }
}
