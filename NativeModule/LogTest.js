/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let Log = NativeModules.Log;

/**
 * @class Layer
 */
export default class LogTest{
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
    async d(tag,message){
        try{
            await Log.d(tag,message);
        }catch(e){
            console.error(e);
        }
    }
}
