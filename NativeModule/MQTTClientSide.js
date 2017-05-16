/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let MTS = NativeModules.JSMQTTClientSide;
import AMQPSender from './AMQPSender.js';
import AMQPReceiver from './AMQPReceiver.js';
/**
 * @class Layer
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
     * @returns {Promise.<AMQPReceiver>}
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
     * 创建一个发送端
     * @memberOf MQTTClientSide
     * @returns {Promise.<AMQPSender>}
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
     * @returns {Promise.<bool>}
     */
    async receiveMessage(){
        try{
            var {message} = await MTS.receiveMessage(this.MQTTClientSideId);
            return message;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 订阅某一主题
     * @memberOf MQTTClientSide
     * @returns {Promise.<bool>}
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
     * @returns {Promise.<bool>}
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
     * @returns {Promise.<bool>}
     */
    async dispose(){
        try{
            await MTS.dispose(this.MQTTClientSideId);
        }catch(e){
            console.error(e);
        }
    }
}
