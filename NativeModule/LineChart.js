/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let LC = NativeModules.JSLineChart;
import ChartView from './ChartView.js';

/**
 * @class LineChart
 */
export default class LineChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"linechartId",{
                              get:function (){
                                return this.chartviewId
                              },
                              set:function(linechartId){
                              this.chartviewId = linechartId;
                              }
                              })
    }
    /**
     * 设置/获取数值是否按照X轴分布
     * @memberOf BarChart
     * @param {boolean} b
     * @returns {Promise.<void>}
     */
    async setAllowInteraction(b){
        try{
            await LC.setAllowInteraction(this.linechartId,b);
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 判断图层是否处于可编辑状态。
     * @memberOf ChartView
     * @returns {Promise.<boolean>}
     */
    async isAllowInteraction(){
        try{
            var{isAllow} = await LC.isAllowInteraction(this.linechartId);
            return isAllow;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置X坐标轴显示标签
     * @memberOf ChartView
     * @param {object} xAxisLables - 数据数组
     * @returns {Promise.<ChartLegend>}
     */
    async setXAxisLables(xAxisLables){
        try{
            await LC.setXAxisLables(this.linechartId,xAxisLables);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取X坐标轴显示标签
     * @memberOf ChartView
     * @returns {Promise.<object>}
     */
    async getXAxisLables(){
        try{
            var {xAxisLables} = await LC.getXAxisLables(this.linechartId);
            return xAxisLables;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置X坐标轴标题。
     * @memberOf ChartView
     * @param {string} title - 标题
     * @returns {Promise.<void>}
     */
    async setXAxisTitle(title){
        try{
            await LC.setXAxisTitle(this.linechartId,title);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取X坐标轴标题。
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async getXAxisTitle(){
        try{
            var {title} = await LC.getXAxisTitle(this.linechartId);
            return title;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置Y坐标轴标题。
     * @memberOf ChartView
     * @param {string} title - 标题
     * @returns {Promise.<void>}
     */
    async setYAxisTitle(title){
        try{
            await LC.setYAxisTitle(this.linechartId,title);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取Y坐标轴标题。
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async getYAxisTitle(){
        try{
            var {title} = await LC.getYAxisTitle(this.linechartId);
            return title;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置图表选中回调
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async setChartOnSelected(){
        try{
            await LC.setChartOnSelected(this.linechartId);
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
            await LC.setSelectedGeometryID(this.linechartId,geoId);
        }catch(e){
            console.error(e);
        }
    }
}
