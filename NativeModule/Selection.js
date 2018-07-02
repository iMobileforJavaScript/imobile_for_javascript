/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let S = NativeModules.JSSelection;
import Recordset from './Recordset.js';

/**
 * @class Selection
 * @description 选择集类。该类用于处理地图上被选中的对象。
 */
export default class Selection {
    /**
     * 将记录集转换成Selection
     * @deprecated
     * @memberOf Selection
     * @param {object} recordset - 记录集
     * @returns {Promise.<Promise.fromRecordset>}
     */
    async fromRecordset(recordset){
        try{
            let {fromRecordset} = await S.fromRecordset(this._SMSelectionId,recordset._SMRecordsetId);
            return fromRecordset;
        }catch(e){
            console.log(e);
        }
    }

    /**
     * 设置样式风格
     * @memberOf Selection
     * @param {object} geoStyle - 样式风格
     * @returns {Promise.<void>}
     */
    async setStyle(geoStyle){
        try{
            await S.setStyle(this._SMSelectionId,geoStyle._SMGeoStyleId);
        }catch(e){
            console.log(e);
        }
    }

    /**
     * 清空选择对象
     * @memberOf Selection
     * @returns {Promise.<void>}
     */
    async clear(){
        try{
            await S.clear(this._SMSelectionId);
        }catch(e){
            console.log(e);
        }
    }

    /**
     * 转成recordset数据集
     * @deprecated
     * @memberOf Selection
     * @returns {Promise.<Recordset>}
     */
    async toRecordset(){
        try{
            var {recordsetId} = await S.toRecordset(this._SMSelectionId);
            var recordset = new Recordset();
            recordset._SMRecordsetId = recordsetId;
            return recordset;
        }catch(e){
            console.log(e);
        }
    }

    /**
     * 从查询结果获取地图被选要素
     * @deprecated
     * @memberOf Selection
     * @param {object} result - 经DataVector的query方法查询出的结果
     * @returns {Promise.<Promise.fromRecordset>}
     */
    async fromQueryResult(result){
        try{
            let {fromRecordset} = await S.fromRecordset(this._SMSelectionId,result._SMRecordsetId);
            return fromRecordset;
        }catch(e){
            console.log(e);
        }
    }
}
