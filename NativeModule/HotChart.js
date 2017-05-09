/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let HC = NativeModules.JSHotChart;
import ChartView from './ChartView.js';
/**
 * @class PieChart
 */
export default class HotChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"hotChartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function(hotChartId){
                              this.chartviewId = hotChartId;
                              }
                              })
    }
    /**
     * 构造方法
     * @memberOf HotChart
     * @param {MapControl} mapControl
     * @returns {Promise.<void>}
     */
    async createObj(mapControl){
        try{
            var {hotChartId} = await HC.createObj(mapControl.mapControlId);
            var hotchart = new HotChart();
            hotchart.hotChartId = hotChartId;
            return hotchart;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置色带
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async setColorScheme(colorScheme){
        try{
            await HC.setColorScheme(this.hotChartId,colorScheme.colorSchemeId);
        }catch(e){
            console.error(e);
        }
    }
}
