/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let LCD = NativeModules.JSLineChartData;
import ChartData from './ChartData.js';

/**
 * @class Layer
 */
export default class LineChartData extends ChartData{
    constructor(){
        super();
        Object.defineProperty(this,"lineChartDataId",{
                              get:function(){
                                return this.chartDataId
                              },
                              set:function(lineChartDataId){
                              this.chartDataId = lineChartDataId;
                              }
                              })
    }
    /**
     * 创建一个PieChartData对象
     * @memberOf LineChartData
     * @param {string}itemName - 图表名称
     * @param {object}values - 图表数据
     * @param {string}label - 图表标题
     * @param {int}color - 图表颜色
     * @param {int}geoId - ID
     * @returns {Promise.<void>}
     */
    async createObj(itemName,values,label,color,geoId){
        try{
            var {_linechartdataId} = await LCD.createObj(itemName,values,label,color,geoId);
            var lineChartData = new LineChartData();
            lineChartData.lineChartDataId = _linechartdataId;
            return lineChartData;
        }catch(e){
            console.error(e);
        }
    }
    /**
     *  设置图饼子项的值
     * @memberOf LineChartData
     * @param {int}value - 图饼子项的值
     * @returns {Promise.<void>}
     */
    async setValues(value){
        try{
            await LCD.setValues(this.pieChartDataId,value);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取图饼子项的值
     * @memberOf LineChartData
     * @returns {Promise.<number>}
     */
    async getValues(){
        try{
            var {values} = await LCD.getValues(this.pieChartDataId);
            return values;
        }catch(e){
            console.error(e);
        }
    }
}
