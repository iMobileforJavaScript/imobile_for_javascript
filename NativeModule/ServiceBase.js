/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let SB = NativeModules.JSServiceBase;

/**
 * @class ServiceBase
 * @description iServer 所有服务的基类。
 */
export default class ServiceBase {

    static REQUESTFAILED = "com.supermap.services.ServiceBase.requestFailed";
    static REQUESTSUCCESS = "com.supermap.services.ServiceBase.requestSuccess";
    static RECEIVERESPONSE = "com.supermap.services.ServiceBase.receiveResponse";
    static DATASERVICEFINISHED = "com.supermap.services.ServiceBase.dataServiceFinished";

    /**
     * 获得URL远程路径
     * @memberOf ServiceBase
     * @returns {Promise}
     */
    async getUrl(){
        try{
            var url = await SB.getUrl(this._SMServiceBaseId);
            return url;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置URL远程路径
     * @memberOf ServiceBase
     * @param url - URL路径
     * @returns {Promise.<void>}
     */
    async setUrl(url){
        try{
            await SB.setUrl(this._SMServiceBaseId,url);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置服务器名称
     * @memberOf ServiceBase
     * @param serverName - 服务器名称
     * @returns {Promise.<void>}
     */
    async setServerName(serverName){
        try{
            await SB.setServerName(this._SMServiceBaseId,serverName);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置相应回调
     * @memberOf ServiceBase
     * @param {function} requestFailed - 请求失败处理函数
     * @param {function} requestSuccess - 请求成功处理函数
     * @param {function} receiveResponse - 接受响应处理函数
     * @param {function} dataServiceFinished - 数据服务完成处理函数
     * @returns {Promise.<void>} -
     */
    async setResponseCallback(requestFailed,requestSuccess,receiveResponse,dataServiceFinished){
        try {
            DeviceEventEmitter.addListener(this.REQUESTFAILED,function (e) {
                if(typeof requestFailed == 'function'){
                    requestFailed(e);
                }else{
                    console.error("Could not find the first argument.");
                }
            });
            DeviceEventEmitter.addListener(this.REQUESTSUCCESS,function (e) {
                if(typeof requestSuccess == 'function'){
                    requestSuccess(e);
                }else{
                    console.error("Could not find the second argument.");
                }
            });
            DeviceEventEmitter.addListener(this.RECEIVERESPONSE,function (e) {
                if(typeof receiveResponse == 'function'){
                    receiveResponse(e);
                }else{
                    console.error("Could not find the second argument.");
                }
            });
            DeviceEventEmitter.addListener(this.DATASERVICEFINISHED,function (e) {
                if(typeof dataServiceFinished == 'function'){
                    dataServiceFinished(e);
                }else{
                    console.error("Could not find the second argument.");
                }
            });
        }catch(e){
            console.error(e);
        }

    }
}
