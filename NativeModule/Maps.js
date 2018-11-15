/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import { NativeModules } from 'react-native';
let M = NativeModules.JSMaps;

/**
 * @class Maps
 * @deprecated
 */
export default class　Maps{
    /**
     * 根据序号返回地图名称
     * @memberOf Maps
     * @param {number} index - 地图序号
     * @returns {Promise.<*>}
     */
    async get(index){
        try{
            var {mapName} = await M.get(this._SMMapsId,index);
            return mapName;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取地图数目
     * @memberOf Maps
     * @returns {Promise.<number>}
     */
    async getCount(){
        try{
            var {count} = await M.getCount(this._SMMapsId);
            return count;
        }catch(e){
            console.error(e);
        }
    }
    
}
