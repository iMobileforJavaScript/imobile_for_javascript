/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
import ChartView from './ChartView.js';
let PC = NativeModules.JSPieChart;

/**
 * @class PieChart
 */
export default class PieChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"piechartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function(piechartId){
                              this.chartviewId = piechartId;
                              }
                              })
    }
    /**
     * 设置图表选中回调
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async setChartOnSelected(){
        try{
            await PC.setChartOnSelected(this.piechartId);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置选中的对象ID
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async setSelectedGeometryID(geoId){
        try{
            await PC.setSelectedGeometryID(this.piechartId,geoId);
        }catch(e){
            console.error(e);
        }
    }
}
