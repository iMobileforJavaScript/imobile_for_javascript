/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let SS = NativeModules.JSQueryService;
import ServiceBase from './ServiceBase.js';
/**
 * @class QueryService
 * @param QueryMode.SqlQuery -  查询模式：SQL查询
 * @param QueryMode.FindNearest -  查询模式：最近地物查询
 * @param QueryMode.DistanceQuery - 查询模式：距离查询
 * @param QueryMode.SpatialQuery - 查询模式：空间查询
 * @param QueryMode.BoundsQuery - 范围查询：范围查询
 *
 */
export default class QueryService extends ServiceBase{
    constructor(){
        super();
        //同步子类Id和父类Id
        Object.defineProperty(this,"_SMQueryServiceId",{
                              get:function () {
                              return this._SMServiceBaseId
                              },
                              set:function (_SMQueryServiceId) {
                              this._SMServiceBaseId = _SMQueryServiceId;
                              }
                              })
    }
    /**
     * 根据查询路径创建一个QueryService对象
     * @param url
     * @returns {Promise.<QueryService>}
     */
    async createObj(url) {
        try {
            var {_queryServiceId_} = await SS.createObj(url);
            var queryService = new QueryService();
            queryService._SMQueryServiceId = _queryServiceId_;
            return queryService;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 对Rest地图服务进行查询。 -- deprecated
     * @param serviceQueryParameter - 查询参数{@ling QueryParameter}。
     * @param mode - 查询模式QueryMode
     * @returns {Promise.<*>}
     */
    async query(serviceQueryParameter, mode) {
        try {
            await SS.query(this._SMQueryServiceId,
                serviceQueryParameter._SMServiceQueryParameterId, mode);
            return queryService;
        } catch (e) {
            console.error(e);
        }
    }

    /**
     * 对Rest地图服务进行查询。 -- deprecated
     * @param url - 地图服务的全地址 ：如：http://192.168.120.1:8090/iserver/services/map-world/rest/maps/World。
     * @param serviceQueryParameter - 查询参数。
     * @param mode - 查询模式。
     * @returns {Promise.<*>}
     */
    async queryByUrl(url, serviceQueryParameter, mode) {
        try {
            await SS.queryByUrl(this._SMQueryServiceId, url,
                serviceQueryParameter._SMServiceQueryParameterId, mode);
            return queryService;
        } catch (e) {
            console.error(e);
        }
    }
}

QueryService.QueryMode = {
    SqlQuery: 0,
    FindNearest: 1,
    DistanceQuery: 2,
    SpatialQuery: 3,
    BoundsQuery: 4,
}
