/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let BCDI = NativeModules.JSBarChartDataItem;
/**
 * @class BarChartDataItem
 */
export default class BarChartDataItem {
    /**
     * 创建一个BarChartDataItem对象
     * @memberOf BarChartDataItem
     * @param {number}value - 数据值
     * @param {array}colorArr - [red,green,blue,alpha]颜色分量数组，alpha为可选参数，默认1.0f。
     * @param {string}labelString - 标题
     * @param {number}geoId - 关联polygon的编号
     * @returns {Promise.<BarChartDataItem>}
     */
    async createObj(value,colorArr,labelString,geoId){
        try{
            var {_SMBarChartDataItemId} = await BCDI.createObj(value,colorArr,labelString,geoId);
            var barChartDataItem = new BarChartDataItem();
            barChartDataItem._SMBarChartDataItemId = _SMBarChartDataItemId;
            return barChartDataItem;
        }catch(e){
            console.error(e);
        }
    }
    /**
     *  设置图柱子项的值
     * @memberOf BarChartDataItem
     * @param {number}value - 图柱子项的值
     * @returns {Promise.<void>}
     */
    async setValue(value){
        try{
            await BCDI.setValue(this._SMBarChartDataItemId,value);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取图柱子项的值
     * @memberOf BarChartDataItem
     * @returns {Promise.<number>}
     */
    async getValues(){
        try{
            var {value} = await BCDI.getValues(this._SMBarChartDataItemId);
            return value;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     *  设置关联polygon的id
     * @memberOf BarChartDataItem
     * @param {number}geoId - 关联polygon的id
     * @returns {Promise.<void>}
     */
    async setGeometryID(geoId){
        try{
            await BCDI.setGeometryID(this._SMBarChartDataItemId,geoId);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     *  设置图柱子项的标题
     * @memberOf BarChartDataItem
     * @param {string}labelString - 图柱子项的标题
     * @returns {Promise.<void>}
     */
    async setLabel(labelString){
        try{
            await BCDI.setLabel(this._SMBarChartDataItemId,labelString);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取图柱子项的标题
     * @memberOf BarChartDataItem
     * @returns {Promise.<string>}
     */
    async getLabel(){
        try{
            var {label} = await BCDI.getLabel(this._SMBarChartDataItemId);
            return label;
        }catch(e){
            console.error(e);
        }
    }
}
