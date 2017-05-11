/**
 * Created by will on 2016/5/17.
 */
var {NativeModules}=require('react-native');
let WCI=NativeModules.JSWorkspaceConnectionInfo;

/**
 * @class WorkspaceConnectionInfo
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
            workspaceConnectionInfo.workspaceConnectionInfoId = ID;
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
            await WCI.setType(this.workspaceConnectionInfoId,type);
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
            await WCI.setServer(this.workspaceConnectionInfoId,path);
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
            await WCI.setPassWord(this.workspaceConnectionInfoId,passWord);
        }catch(e){
            console.error(e);
        }
    }

}
