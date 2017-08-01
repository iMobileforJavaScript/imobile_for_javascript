/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
var {NativeModules}=require('react-native');
let WCI=NativeModules.JSWorkspaceConnectionInfo;

/**
 * @class WorkspaceConnectionInfo
 * @description 工作空间连接信息类。
 */
export default class WorkspaceConnectionInfo{
    /**
     * 创建一个WorkspaceConnectionInfo对象
     * @memberOf WorkspaceConnectionInfo
     * @returns {Promise.<WorkspaceConnectionInfo>}
     */
    async createJSObj(){
        try{
            var {ID}=await WCI.createJSObj();
            var workspaceConnectionInfo = new WorkspaceConnectionInfo();
            workspaceConnectionInfo._SMWorkspaceConnectionInfoId = ID;
            return workspaceConnectionInfo;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置工作空间类型
     * @memberOf WorkspaceConnectionInfo
     * @param {number} type - {@link Workspace}
     * @returns {Promise.<void>}
     */
    async setType(type){
        try{
            await WCI.setType(this._SMWorkspaceConnectionInfoId,type);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置数据源路径
     * @memberOf WorkspaceConnectionInfo
     * @param path
     * @returns {Promise.<void>}
     */
    async setServer(path){
        try{
            await WCI.setServer(this._SMWorkspaceConnectionInfoId,path);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置数据源密码
     * @memberOf WorkspaceConnectionInfo
     * @param path
     * @returns {Promise.<void>}
     */
    async setPassWord(passWord){
        try{
            await WCI.setPassWord(this._SMWorkspaceConnectionInfoId,passWord);
        }catch(e){
            console.error(e);
        }
    }

}
