/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let PCD = NativeModules.JSPieChartData;
import ChartData from './ChartData.js';

/**
 * @class Layer
 */
export default class PieChartData extends ChartData{
    constructor(){
        super();
        Object.defineProperty(this,"pieChartDataId",{
                              get:function(){
                                return this.chartDataId
                              },
                              set:function(pieChartDataId){
                                this.chartDataId = pieChartDataId;
                              }
                              })
    }
    /**
     * 创建一个PieChartData对象
     * @memberOf PieChartData
     * @param {string}itemName - 图表名称
     * @param {object}values - 图表数据
     * @param {string}label - 图表标题
     * @param {int}color - 图表颜色
     * @param {int}geoId - ID
     * @returns {Promise.<void>}
     */
    async createObj(paraObj){
        try{
            var {_piechartdataId} = await PCD.createObj(paraObj);
            var pieChartData = new PieChartData();
            pieChartData.pieChartDataId = _piechartdataId;
            return pieChartData;
        }catch(e){
            console.error(e);
        }
    }
    /**
     *  设置图饼子项的值
     * @memberOf PieChartData
     * @param {int}value - 图饼子项的值
     * @returns {Promise.<void>}
     */
    async setValue(value){
        try{
            await PCD.setValue(this.pieChartDataId,value);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取图饼子项的值
     * @memberOf PieChartData
     * @returns {Promise.<number>}
     */
    async getValue(){
        try{
            var {value} = await PCD.getValue(this.pieChartDataId);
            return value;
        }catch(e){
            console.error(e);
        }
    }
}
