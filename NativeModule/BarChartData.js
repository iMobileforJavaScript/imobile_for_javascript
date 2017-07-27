/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let BCD = NativeModules.JSBarChartData;
import ChartData from './ChartData.js';
import BarChartDataItem from './BarChartDataItem.js'
/**
 * @class BarChartData
 */
export default class BarChartData extends ChartData{
    constructor(){
        super();
        Object.defineProperty(this,"barChartDataId",{
                              get:function(){
                                return this.chartDataId
                              },
                              set:function(barChartDataId){
                              this.chartDataId = barChartDataId;
                              }
                              })
    }
    /**
     * 创建一个BarChartData对象
     * @memberOf BarChartData
     * @param {string}itemName - 图表名称
     * @param {object}values - 图表数据
     * @param {string}label - 图表标题
     * @param {int}color - 图表颜色
     * @param {int}geoId - ID
     * @returns {Promise.<void>}
     */
    async createObj(itemName,values){
        try{
            var idArr = [];
            for(variable in values){
                var id = variable._SMBarChartDataItemId;
                idArr.push(id);
            }
            var {_barchartdataId} = await BCD.createObj(itemName,idArr);
            var barChartData = new BarChartData();
            barChartData.barChartDataId = _barchartdataId;
            return barChartData;
        }catch(e){
            console.error(e);
        }
    }
    /**
     *  设置图柱子项的值
     * @memberOf BarChartData
     * @param {array}values - 图饼子项值的集合
     * @returns {Promise.<void>}
     */
    async setValues(values){
        try{
            var idArr = [];
            for(variable in values){
                var id = variable._SMBarChartDataItemId;
                idArr.push(id);
            }
            await BCD.setValues(this.barChartDataId,idArr);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取图柱子项的值
     * @memberOf BarChartData
     * @returns {Promise.<array>}
     */
    async getValues(){
        try{
            var objArr = [];
            var {values} = await BCD.getValues(this.barChartDataId);
            for(variable in values){
                var barChartDataItem = new BarChartDataItem();
                barChartDataItem._SMBarChartDataItemId = variable;
                objArr.push(barChartDataItem);
            }
            return objArr;
        }catch(e){
            console.error(e);
        }
    }
}
