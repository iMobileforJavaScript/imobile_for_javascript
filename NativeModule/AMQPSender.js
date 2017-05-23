/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let APS = NativeModules.JSAMQPSender;

/**
 * @class Layer
 */
export default class AMQPSender{
    /**
     * 创建一个AMQPManager对象
     * @memberOf AMQPManager
     * @returns {Promise.<AMQPManager>}
     */
/*    async createObj(){
        try{
            var {_AMQPSenderId} = await APS.createObj();
            var AMQPSenderObj = new AMQPSender();
            AMQPSenderObj.AMQPSenderId = _AMQPSenderId;
            return AMQPSenderObj;
        }catch(e){
            console.error(e);
        }
    }
 */
    /**
     * 创建一个接收端。
     * @memberOf AMQPManager
     * @param {string}queueName - 地图对应几何对象Id
     * @returns {Promise.<void>}
     */
    async sendMessage(exchange,routingKey,message){
        try{
            await APS.sendMessage(this.AMQPSenderId,exchange,routingKey,message);
        }catch(e){
            console.error(e);
        }
    }

}
