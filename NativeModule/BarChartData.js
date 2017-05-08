/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let BCD = NativeModules.JSBarChartData;
import ChartData from './ChartData.js';
/**
 * @class Layer
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
    async createObj(itemName,values,label,color,geoId){
        try{
            var {_barchartdataId} = await BCD.createObj(itemName,values,label,color,geoId);
            var barChartData = new BarChartData();
            barChartData.barChartDataId = _barchartdataId;
            return barChartData;
        }catch(e){
            console.error(e);
        }
    }
    /**
     *  设置图饼子项的值
     * @memberOf BarChartData
     * @param {int}value - 图饼子项的值
     * @returns {Promise.<void>}
     */
    async setValues(values){
        try{
            await BCD.setValues(this.barChartDataId,values);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取图饼子项的值
     * @memberOf BarChartData
     * @returns {Promise.<number>}
     */
    async getValues(){
        try{
            var {values} = await BCD.getValues(this.barChartDataId);
            return values;
        }catch(e){
            console.error(e);
        }
    }
}
