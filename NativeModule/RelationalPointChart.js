/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let RPC = NativeModules.JSRelationalPointChart;
import ChartView from './ChartView.js';
/**
 * @class PieChart
 */
export default class RelationalPointChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"relationalPointChartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function(relationalPointChartId){
                              this.chartviewId = relationalPointChartId;
                              }
                              });
    }
    /**
     * 构造方法
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async createObj(mapControl){
        try{
            var {relationalPointChartId} = await RPC.createObj(mapControl._SMMapControlId);
            var relationalPointChart = new RelationalPointChart();
            relationalPointChart.relationalPointChartId = relationalPointChartId;
            return relationalPointChart;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置是否开启动画效果
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async setAnimation(b){
        try{
            await RPC.setAnimation(this.relationalPointChartId,b);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取是否开启动画效果(该方法只适用于iOS端)
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async isAnimation(){
        try{
            var {isAnimation} = await RPC.isAnimation(this.relationalPointChartId);
            return isAnimation;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置动态效果Image
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async setAnimationImage(url){
        try{
            await RPC.setAnimationImage(this.relationalPointChartId,url);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置子关系点颜色
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async setChildRelationalPointColor(colorArr){
        try{
            await RPC.setChildRelationalPointColor(this.relationalPointChartId,colorArr);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置关系线终点颜色
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async setEndPointColor(colorArr){
        try{
            await RPC.setEndPointColor(this.relationalPointChartId,colorArr);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置子关系点大小
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async setChildPointSize(size){
        try{
            await RPC.setChildPointSize(this.relationalPointChartId,size);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置线宽
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async setLineWidth(width){
        try{
            await RPC.setLineWidth(this.relationalPointChartId,width);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置刻度调色板
     * @memberOf RelationalPointChart
     * @returns {Promise.<void>}
     */
    async setColorScheme(scheme){
        try{
            await RPC.setColorScheme(this.relationalPointChartId,scheme.colorSchemeId);
        }catch(e){
            console.error(e);
        }
    }
}
