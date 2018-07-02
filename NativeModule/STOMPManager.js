/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let SPM = NativeModules.JSSTOMPManager;
import STOMPSender from './STOMPSender.js';
import STOMPReceiver from './STOMPReceiver.js';
/**
 * @class STOMPManager
 */
export default class STOMPManager{
    /**
     * 创建一个AMQPManager对象
     * @memberOf STOMPManager
     * @returns {Promise.<AMQPManager>}
     */
    async createObj(){
        try{
            var {_STOMPManagerId} = await SPM.createObj();
            var STOMPManagerObj = new STOMPManager();
            STOMPManagerObj.STOMPManagerId = _STOMPManagerId;
            return STOMPManagerObj;
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 初始化库。
     * @memberOf STOMPManager
     * @returns {Promise.<AMQPReceiver>}
     */
    async initializeLibrary(){
        try{
            await SPM.initializeLibrary();
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 释放环境。不可重复释放。
     * @memberOf STOMPManager
     * @returns {Promise.<AMQPReceiver>}
     */
    async shutdownLibrary(){
        try{
            await SPM.shutdownLibrary();
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 创建一个发送端
     * @memberOf STOMPManager
     * @returns {Promise.<AMQPSender>}
     */
    async newSender(useTopic,name){
        try{
            var {STOMPSenderId} = await SPM.newSender(this.STOMPManagerId,useTopic,name);
            var newSPS = new STOMPSender();
            newSPS.STOMPSenderId = STOMPSenderId;
            return newSPS;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 创建一个接收端
     * @memberOf STOMPManager
     * @returns {Promise.<AMQPSender>}
     */
    async newReceiver(useTopic,name,clientID){
        try{
            var {STOMPReceiverId} = await SPM.newReceiver(this.STOMPManagerId,useTopic,name,clientID);
            var newSPR = new STOMPReceiver();
            newSPR.STOMPReceiverId = STOMPReceiverId;
            return newSPS;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 建立链接
     * @memberOf STOMPManager
     * @returns {Promise.<bool>}
     */
    async connection(URI,userName,passWord){
        try{
            var {isConnection} = await SPM.connection(this.STOMPManagerId,URI,userName,passWord);
            return isConnection;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 断开链接
     * @memberOf STOMPManager
     * @returns {Promise.<bool>}
     */
    async disconnection(){
        try{
            await SPM.disconnection(this.STOMPManagerId);
        }catch(e){
            console.error(e);
        }
    }
}
