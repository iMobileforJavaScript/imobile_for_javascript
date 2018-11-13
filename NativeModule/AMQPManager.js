/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/

import {NativeModules} from 'react-native';
import AMQPSender from './AMQPSender.js';
import AMQPReceiver from './AMQPReceiver.js';
let APM = NativeModules.JSAMQPManager;

/**
 * @class AMQPManager
 * @description AMQP 管理类。
   负责队列，交换机，接收端，发送端的创建，以及绑定。使用前需要连接服务器。（暂不支持android设备）
 */
export default class AMQPManager{
    
    /**
     * 创建一个AMQPManager对象。
     * @memberOf AMQPManager
     * @returns {Promise.<AMQPManager>}
     */
    async createObj(){
        try{
            var {_AMQPManagerId} = await APM.createObj();
            var AMQPManagerObj = new AMQPManager();
            AMQPManagerObj._SMAMQPManagerId = _AMQPManagerId;
            return AMQPManagerObj;
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 创建一个接收端。
     * @memberOf AMQPManager
     * @param {string} queueName - 消息队列名称
     * @returns {Promise.<AMQPReceiver>}
     */
    async newReceiver(queueName){
        try{
            var {AMQPReceiverId} = await APM.newReceiver(this._SMAMQPManagerId,queueName);
            var newAPR = new AMQPReceiver();
            newAPR._SMAMQPReceiverId = AMQPReceiverId;
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
            var {AMQPSenderId} = await APM.newSender(this._SMAMQPManagerId);
            var newAPS = new AMQPSender();
            newAPS._SMAMQPSenderId = AMQPSenderId;
            return newAPS;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 建立链接
     * @memberOf AMQPManager
     * @param {object} paramObj - 
       {IP:<string>ip地址,
        Port:<number>端口号,HostName:<string>虚拟机主机名称,
        UserName:<string>账户,PassWord:<string>密码,
        ClientId:<string>客户端ID}
     * @returns {Promise.<bool>}
     */
    async connection(paramObj){
        try{
            var {isConnection} = await APM.connection(this._SMAMQPManagerId,paramObj);
            return isConnection;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 断开链接
     * @memberOf AMQPManager
     * @returns {Promise.<void>}
     */
    async disconnection(){
        try{
            await APM.disconnection(this._SMAMQPManagerId);
        }catch(e){
            console.error(e);
        }
    }
}
