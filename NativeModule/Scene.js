import {NativeModules} from 'react-native';
let S = NativeModules.JSScene;
import Workspace from './Workspace';
/**
 * @class Scene
 */
export default class Scene {
    /**
     * 设置工作空间
     * @memberOf Scene
     * @param {object} workspace - 工作空间对象
     * @returns {Promise.<void>}
     */
    async setWorkspace(workspace){
        try{
            await S.setWorkspace(this.sceneId,workspace.workspaceId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 返回三维场景所关联的工作空间。
     * @memberOf Scene
     * @returns {Promise.<Workspace>}
     */
    async getWorkspace(){
        try{
            var {workspaceId} = await S.setWorkspace(this.sceneId);
            var workspace = new Workspace();
            workspace.workspaceId = workspaceId;

            return workspace;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 根据提供的场景名称打开三维地图
     * @memberOf Scene
     * @param {string} [iserverUrl,] sceneName [,password] - 只有一个参数时： 场景名称。
     * 两个参数时：(iserverUrl,sceneName) iserverUrl - 三维服务URL地址；sceneName - 场景名称。
     * 三个参数时：(iserverUrl,sceneName,passWord ) iserverUrl - 三维服务URL地址；sceneName - 场景名称; passWord - 场景密码，默认密码是“supermap”。
     * @returns {Promise.<boolean>}
     */
    async open(){
        try{
            if(arguments.length == 1){
                var {opened} = await S.open(this.sceneId,arguments[0]);
                return opened;
            }else if(arguments.length == 2){
                var {opened} = await S.open2(this.sceneId,arguments[0],arguments[1]);
                return opened;
            }else if(arguments.length == 3){
                var {opened} = await S.open3(this.sceneId,arguments[0],arguments[1],arguments[2]);
                return opened;
            }else{
                throw new Error("Scene opened Error: Please input 1-3 arguments.read the specification please")
            }
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 根据经纬度范围显示场景。
     * @memberOf Scene
     * @param {object} visibleBounds - rectangle2D对象,包含如下属性：{top:--,left:--,right:--,bottom:--}
     * @returns {Promise.<void>}
     */
    async ensureVisible(visibleBounds){
        try{
            await S.ensureVisible(this.sceneId,visibleBounds);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 刷新三维场景
     * @memberOf Scene
     * @returns {Promise.<void>}
     */
    async refresh(){
        try{
            await S.refresh(this.sceneId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 平移三维场景。
     * @memberOf Scene
     * @param offsetLongitude - 指定的经向平移距离。
     * @param offsetLatitude - 指定的纬向平移距离。
     * @returns {Promise.<void>}
     */
    async pan(offsetLongitude,offsetLatitude){
        try{
            await S.pan(this.sceneId,offsetLongitude,offsetLatitude);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 全幅显示此场景。
     * @memberOf Scene
     * @returns {Promise.<void>}
     */
    async viewEntire(){
        try{
            await S.viewEntire(this.sceneId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 根据给定的缩放比例，对三维地图场景进行缩放操作
     * @memberOf Scene
     * @param {double} ratio - 指定的缩放比例数值。
     * @returns {Promise.<void>}
     */
    async zoom(ratio){
        try{
            await S.zoom(this.sceneId,ratio);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 关闭当前场景
     * @memberOf Scene
     * @returns {Promise.<void>}
     */
    async close(){
        try{
            await S.close(this.sceneId);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 释放该对象所占用的资源
     * @memberOf Scene
     * @returns {Promise.<void>}
     */
    async dispose(){
        try{
            await S.dispose(this.sceneId);
        }catch (e){
            console.error(e);
        }
    }
}
