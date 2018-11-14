/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/

import {NativeModules} from 'react-native';
let APS = NativeModules.JSAMQPSender;

/**
 * @class AMQPSender
 * @description AMQP 消息发送类。(该类不能创建实例，需通过AMQPManager.newSender()创建实例)。（暂不支持android设备）
 */
export default class AMQPSender{

    /**
     * 发送消息。
     * @memberOf AMQPSender
     * @param {string} exchange - 交换器
     * @param {string} routingKey - 路由关键字
     * @param {string} message - 消息
     * @returns {Promise.<void>}
     */
    async sendMessage(exchange,routingKey,message){
        try{
            await APS.sendMessage(this._SMAMQPSenderId,exchange,routingKey,message);
        }catch(e){
            console.error(e);
        }
    }

}
