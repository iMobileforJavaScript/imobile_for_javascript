/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let IC = NativeModules.JSInstrumentChart;
import ChartView from './ChartView.js';
/**
 * @class PieChart
 */
export default class InstrumentChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"instrumentChartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function(instrumentChartId){
                              this.chartviewId = instrumentChartId;
                              }
                              })
    }
    /**
     * 构造方法
     * @memberOf GridHotChart
     * @param {MapControl} mapControl
     * @returns {Promise.<void>}
     */
    async createObj(){
        try{
            var {instrumentChartId} = await IC.createObj();
            var instrumentChart = new InstrumentChart();
            instrumentChart.instrumentChartId = instrumentChartId;
            return instrumentChart;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置仪表最小值
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async setMinValue(minValue){
        try{
            await IC.setMinValue(this.instrumentChartId,minValue);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取仪表最小值
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async getMinValue(){
        try{
            var {minValue} = await IC.getMinValue(this.instrumentChartId);
            return minValue;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置仪表最大值
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async setMaxValue(maxValue){
        try{
            await IC.setMaxValue(this.instrumentChartId,maxValue);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取仪表最大值
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async getMaxValue(){
        try{
            var {maxValue} = await IC.getMaxValue(this.instrumentChartId);
            return maxValue;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置仪表分段数
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async setSegmentCount(count){
        try{
            await IC.setSegmentCount(this.instrumentChartId,count);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取仪表分段数
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async getSegmentCount(){
        try{
            var {count} = await IC.getSegmentCount(this.instrumentChartId);
            return count;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置刻度调色板
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async setColorScheme(scheme){
        try{
            await IC.setColorScheme(this.instrumentChartId,scheme.colorSchemeId);
        }catch(e){
            console.error(e);
        }
    }
}
