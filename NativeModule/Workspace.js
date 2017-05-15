/**
 * Created by will on 2016/6/17.
 */
import { NativeModules } from 'react-native';
let W = NativeModules.JSWorkspace;
import DS from './Datasources.js';
import Ds from './Datasource.js';
import Maps from './Maps.js';
import Map from './Map.js';
import WorkspaceConnectionInfo from './WorkspaceConnectionInfo';
import Datasource from './Datasource';

/**
 * @class Workspace
 * @property {number} DEFAULT - 默认SMWU类型。
 * @property {number} SMWU - SMWU工作空间，文件型工作空间。
 * @property {number} SXWU - SXWU工作空间。
 * @property {number} UDB - 数据库类型。
 */
export default class Workspace{
    /**
     * 创建一个原生层workspace实例
     * @memberOf Workspace
     * @returns {Promise.<Workspace>}
     */
    async createObj(){
        try{
            var {workspaceId} = await W.createObj();
            var workspace = new Workspace();
            workspace.workspaceId = workspaceId;
            return workspace;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获得数据源集合
     * @memberOf Workspace
     * @deprecated Workspace.js:getDatasources() function has been deprecated. If you want to get datasource , please call the getDatasource() function
     * @returns {Promise.<Datasources>}
     */
    async getDatasources(){
        try {
            var {datasourcesId} = await W.getDatasources(this.workspaceId);
            console.debug("datasourcesId:"+datasourcesId);
            var ds = new DS();
            ds.datasourcesId = datasourcesId;
            return ds;
        }catch (e){
            console.error(e);
        }
    }
    
    /**
     * 通过数据源链接信息打开数据源
     * @memberOf Workspace
     * @deprecated 可直接通过{@link Workspace.openDatasource}方法传参数，不在需要构建datasourceConnectionInfo对象。
     * @param {object} datasourceConnectionInfo 数据源链接信息
     * @returns {Promise.<Datasource>}
     */
 /*   async openDatasourceConnectionInfo(datasourceConnectionInfo){
        try {
            var {datasourceId} = await W.openDatasourceConnectionInfo(this.workspaceId,datasourceConnectionInfo.datasourceConnectionInfoId);
            var ds = new Ds();
            ds.datasourceId = datasourceId;
            return ds;
        }catch (e){
            console.error(e);
        }
    } */

    /**
     * 通过序号或者名字（别名）获取数据源
     * @memberOf Worksapce
     * @param {number | string} index|name - 既可以是序号，也可以是数据源名称
     * @returns {Promise.<Datasource>}
     */
    async getDatasource(index){
        try{
            var datasource = new Ds();
            if(typeof index != 'string'){
                //get datasource through index.
                var {datasourceId} = await W.getDatasource(this.workspaceId,index);
            }else{
                //get datasource through datasource name(Alias).
                var {datasourceId} = await W.getDatasourceByName(this.workspaceId,index);
            }
            datasource.datasourceId = datasourceId;

            return datasource;
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 根据定义好的工作空间连接信息对象，打开工作空间。
     * @memberOf Workspace
     * @param {object} workspaceConnectionInfo
     * @param {string} passWord - 数据源密码（可选参数）
     * @returns {Promise.<void>}
     */
    async open(workspaceConnectionInfo,passWord){
        try{
            var WorkspaceConnectionInfoModule = new WorkspaceConnectionInfo();

            if(typeof workspaceConnectionInfo === 'string'){
                var wci = await WorkspaceConnectionInfoModule.createJSObj();
                var str = workspaceConnectionInfo.split('.').pop();
                console.log("工作空间类型字符串：" + str);
                var type = this.workspaceType(str);
                console.log("工作空间类型：" + type);
                await wci.setType(type);
                await wci.setServer(workspaceConnectionInfo);
                if(passWord){
                   await wci.setPassWord(passWord);
                }
                var {isOpen} = await W.open(this.workspaceId,wci.workspaceConnectionInfoId)
                return isOpen;
            }else{
                var {isOpen} = await W.open(this.workspaceId,workspaceConnectionInfo.workspaceConnectionInfoId);
                console.log('workspace open connectionInfo:'+isOpen);
                return isOpen;
            }
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取工作空间下的Maps对象
     * @memberOf Worksapce
     * @deprecated Maps类已不推荐使用
     * @memberOf Workspace
     * @returns {Promise.<Maps>}
     */
    async getMaps(){
        try{
            var {mapsId} = await W.getMaps(this.workspaceId);
            var maps = new Maps();
            maps.mapsId = mapsId;
            return maps;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 根据地图序号获得地图名称
     * @memberOf Workspace
     * @param {number} mapIndex
     * @returns {string}
     */
    async getMapName(mapIndex){
        try{
            var {mapName} = await W.getMapName(this.workspaceId,mapIndex);
            return mapName;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 打开数据源 jsonObject 获取网络数据源
     * @memberOf Workspace
     * @param {object} jsonObject {engineType:<int>引擎类型 ,server:<sring>文件／服务器路径 ,driver:<string>驱动名称（可选参数）}
     * @returns {Promise.<datasource>}
     */
    
    async openDatasource(jsonObject){
        try{
            if(jsonObject.webBBox){
                var rect = jsonObject.webBBox;
                if(typeof rect != 'string') jsonObject.webBBox = rect.rectangle2DId;
            }
            var {datasourceId} = await W.openDatasource(this.workspaceId,jsonObject);
            var datasource = new Datasource();
            datasource.datasourceId = datasourceId;
            return datasource;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 打开WMS协议类型数据源
     * @memberOf Workspace
     * @param {string} server
     * @param {number} engineType
     * @param {string} driver
     * @param {string} version
     * @param {string} visibleLayers
     * @param {object} webBox
     * @param {object} webCoordinate
     * @returns {Promise.<void>}
     */
    /*
    async openWMSDatasource(server,engineType,driver,version,visibleLayers,webBox,webCoordinate){
        try{
            await W.openWMSDatasource(this.workspaceId,server,engineType,driver,
                version,visibleLayers,webBox,webCoordinate);
        }catch(e){
            console.error(e);
        }
    } */

    /**
     * 保存工作空间
     * @memberOf Workspace
     * @param {string} server - 另存url（可选参数）
     * @returns {boolean}
     */
    async saveWorkspace(server){
        try{
            if(server){
                var {saved} = await W.saveWorkspaceWithServer(this.workspaceId,server);
            }else{
                var {saved} = await W.saveWorkspace(this.workspaceId);
            }
            return saved;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 关闭工作空间
     * @memberOf Workspace
     * @returns {boolean}
     */
    async closeWorkspace(){
        try{
            var {closed} = await W.closeWorkspace(this.workspaceId);
            return closed;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 创建数据集
     * @memberOf Workspace
     * @param filePath 指定创建数据集路径
     * @param engineType 数据集引擎类型
     * @returns {Promise.<Datasource>}
     */
    async createDatasource(filePath,engineType){
        try{
            var {datasourceId} = await W.createDatasource(this.workspaceId,filePath,engineType);
            var datasource = new Ds();
            datasource.datasourceId = datasourceId;
            return datasource;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 关闭指定名称的数据集
     * @memberOf Workspace
     * @param datasourceName 数据集名称
     * @returns {Promise.<boolean>}
     */
    async closeDatasource(datasourceName){
        try{
            var {closed} = await W.closeDatasource(this.workspaceId,datasourceName);

            return closed;
        }catch(e){
            console.error(e);
        }
    }


    /**
     * 关闭所有数据集
     * @memberOf Workspace
     */
    async closeAllDatasource(){
        try{
            await W.closeAllDatasource(this.workspaceId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 移除地图
     * @memberOf Workspace
     * @param mapName
     * @returns {boolean}
     */
    async removeMap(mapName){
        try{
            var {removed} = await W.removeMap(this.workspaceId,mapName);
            return removed;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 清空所有地图
     * @memberOf Workspace
     */
    async clearMap(){
        try{
            await W.clearMap(this.workspaceId);
        }catch(e){
            console.error(e);
        }
    }

    async getSceneName(index){
        try{
            var {name} = await W.getSceneName(this.workspaceId,index);
            return name;
        }catch(e){
            console.error(e);
        }
    }


    workspaceType = (type) => {
        var value;
        switch (type){
            case 'SMWU':
            case 'smwu':
                value = 9;
                break;
            case 'SXWU':
            case 'sxwu':
                value = 8;
                break;
            case 'SMW':
            case 'smw':
                value = 5;
                break;
            case 'SXW':
            case 'sxw':
                value = 4;
                break;
            case 'UDB':
            case 'udb':
                value = 219;
                break;
            default:
                value = 1;
                break;
        }
        return value;
    }
}

Workspace.SMWU = 9;
Workspace.SXWU = 8;
Workspace.SMW = 5;
Workspace.SXW = 4;
Workspace.UDB = 219;
Workspace.DEFAULT = 1;
