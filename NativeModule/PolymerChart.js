/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let PC = NativeModules.JSPolymerChart;
import ChartView from './ChartView.js';
/**
 * @class PieChart
 */
export default class PolymerChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"polymerChartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function(polymerChartId){
                              this.chartviewId = polymerChartId;
                              }
                              })
    }
    /**
     * 构造方法
     * @memberOf PolymerChart
     * @param {MapControl} mapControl
     * @returns {Promise.<void>}
     */
    async createObj(mapControl){
        try{
            var {polymerChartId} = await PC.createObj(mapControl.mapControlId);
            var polymerChart = new PolymerChart();
            instrumentChart.polymerChartId = polymerChartId;
            return polymerChart;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置聚合算法类型 1:聚类(默认) 2:网格
     * @memberOf PolymerChart
     * @returns {Promise.<void>}
     */
    async setPolymerizationType(type){
        try{
            await PC.setPolymerizationType(this.polymerChartId,type);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取聚合算法类型 1:聚类(默认) 2:网格
     * @memberOf PolymerChart
     * @returns {Promise.<void>}
     */
    async getPolymerizationType(){
        try{
            var {type} = await PC.getPolymerizationType(this.polymerChartId);
            return type;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置未展开聚合点暗色
     * @memberOf PolymerChart
     * @returns {Promise.<void>}
     */
    async setUnfoldColor(colorObj){
        try{
            await PC.setUnfoldColor(this.polymerChartId,colorObj);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取未展开聚合点暗色(该方法只支持iOS)
     * @memberOf PolymerChart
     * @returns {Promise.<void>}
     */
    async getUnfoldColor(){
        try{
            var {colorObj} = await PC.getUnfoldColor(this.polymerChartId);
            return colorObj;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置展开聚合点亮色
     * @memberOf PolymerChart
     * @returns {Promise.<void>}
     */
    async setFoldColor(colorObj){
        try{
            await PC.setFoldColor(this.polymerChartId,colorObj);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取展开聚合点亮色(该方法只支持iOS)
     * @memberOf PolymerChart
     * @returns {Promise.<void>}
     */
    async getFoldColor(){
        try{
            var {colorObj} = await PC.getFoldColor(this.polymerChartId);
            return colorObj;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置刻度调色板
     * @memberOf PolymerChart
     * @returns {Promise.<void>}
     */
    async setColorScheme(scheme){
        try{
            await PC.setColorScheme(this.polymerChartId,scheme.colorSchemeId);
        }catch(e){
            console.error(e);
        }
    }
}
