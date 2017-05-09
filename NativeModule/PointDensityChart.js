/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let PDC = NativeModules.JSPointDensityChart;
import ChartView from './ChartView.js';
/**
 * @class PieChart
 */
export default class PointDensityChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"pointDensityChartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function(pointDensityChartId){
                              this.chartviewId = pointDensityChartId;
                              }
                              })
    }
    /**
     * 构造方法
     * @memberOf PointDensityChart
     * @param {MapControl} mapControl
     * @returns {Promise.<void>}
     */
    async createObj(mapControl){
        try{
            var {pointDensityChartId} = await PDC.createObj(mapControl.mapControlId);
            var pointDensityChart = new PointDensityChart();
            pointDensityChart.pointDensityChartId = pointDensityChartId;
            return pointDensityChart;
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
            await PDC.setColorScheme(this.pointDensityChartId,scheme.colorSchemeId);
        }catch(e){
            console.error(e);
        }
    }
}
