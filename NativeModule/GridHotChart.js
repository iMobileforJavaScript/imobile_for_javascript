/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let GHC = NativeModules.JSGridHotChart;
import ChartView from './ChartView.js';
/**
 * @class PieChart
 */
export default class GridHotChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"gridHotChartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function(gridHotChartId){
                              this.chartviewId = gridHotChartId;
                              }
                              })
    }
    /**
     * 构造方法
     * @memberOf GridHotChart
     * @param {MapControl} mapControl
     * @returns {Promise.<void>}
     */
    async createObj(mapControl){
        try{
            var {gridHotChartId} = await GHC.createObj(mapControl.mapControlId);
            var gridHotchart = new GridHotChart();
            gridHotchart.gridHotChartId = gridHotChartId;
            return gridHotchart;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置色带
     * @memberOf GridHotChart
     * @returns {Promise.<void>}
     */
    async setColorScheme(colorScheme){
        try{
            await GHC.setColorScheme(this.gridHotChartId,colorScheme.colorSchemeId);
        }catch(e){
            console.error(e);
        }
    }
}
