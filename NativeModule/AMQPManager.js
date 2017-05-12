/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let APM = NativeModules.JSAMQPManager;
import AMQPSender from './AMQPSender.js';
import AMQPReceiver from './AMQPReceiver.js';
/**
 * @class Layer
 */
export default class AMQPManager{
    /**
     * 创建一个AMQPManager对象
     * @memberOf AMQPManager
     * @returns {Promise.<AMQPManager>}
     */
    async createObj(){
        try{
            var {_AMQPManagerId} = await APM.createObj();
            var AMQPManagerObj = new AMQPManager();
            AMQPManagerObj.AMQPManagerId = _AMQPManagerId;
            return AMQPManagerObj;
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 创建一个接收端。
     * @memberOf AMQPManager
     * @returns {Promise.<AMQPReceiver>}
     */
    async newReceiver(queueName){
        try{
            var {AMQPReceiverId} = await APM.newReceiver(this.AMQPManagerId,queueName);
            var newAPR = new AMQPReceiver();
            newAPR.AMQPReceiverId = AMQPReceiverId;
            return newAPR;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 创建一个发送端
     * @memberOf AMQPManager
     * @returns {Promise.<AMQPSender>}
     */
    async newSender(){
        try{
            var {AMQPSenderId} = await APM.newSender(this.AMQPManagerId);
            var newAPS = new AMQPSender();
            newAPS.AMQPSenderId = AMQPSenderId;
            return newAPS;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 建立链接
     * @memberOf AMQPManager
     * @returns {Promise.<bool>}
     */
    async connection(paramObj){
        try{
            var {isConnection} = await APM.connection(this.AMQPManagerId,paramObj);
            return isConnection;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 断开链接
     * @memberOf AMQPManager
     * @returns {Promise.<bool>}
     */
    async disconnection(){
        try{
            await APM.disconnection(this.AMQPManagerId);
        }catch(e){
            console.error(e);
        }
    }
}
