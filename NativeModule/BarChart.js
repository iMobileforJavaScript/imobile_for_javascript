/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/

import {NativeModules} from 'react-native';
import ChartView from './ChartView.js';
let BC = NativeModules.JSBarChart;
/**
 * @class BarChart
 * @description 柱状图类
 */
export default class BarChart extends ChartView{
    constructor(){
        super();
        Object.defineProperty(this,"barchartId",{
                              get:function(){
                                return this.chartviewId
                              },
                              set:function (barchartId){
                              this.chartviewId = barchartId;
                              }
                              })
    }
    /**
     * 设置数值是否按照X轴分布
     * @memberOf BarChart
     * @param {boolean} b
     * @returns {Promise.<void>}
     */
    async setValueAlongXAxis(b){
        try{
            await BC.setValueAlongXAxis(this.barchartId,b);
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 判断数值是否按照X轴分布
     * @memberOf BarChart
     * @returns {Promise.<boolean>}
     */
    async isValueAlongXAxis(){
        try{
            var{isAlong} = await BC.isValueAlongXAxis(this.barchartId);
            return isAlong;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置X坐标轴显示标签
     * @memberOf BarChart
     * @param {object} xAxisLables - 数据数组
     * @returns {Promise.<void>}
     */
    async setXAxisLables(xAxisLables){
        try{
            await BC.setXAxisLables(this.barchartId,xAxisLables);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取X坐标轴显示标签
     * @memberOf ChartView
     * @returns {Promise.<Arr>}
     */
    async getXAxisLables(){
        try{
            var {xAxisLables} = await BC.getXAxisLables(this.barchartId);
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
            await BC.setXAxisTitle(this.barchartId,title);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取X坐标轴标题。
     * @memberOf ChartView
     * @returns {Promise.<string>}
     */
    async getXAxisTitle(){
        try{
            var {title} = await BC.getXAxisTitle(this.barchartId);
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
            await BC.setYAxisTitle(this.barchartId,title);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取Y坐标轴标题。
     * @memberOf ChartView
     * @returns {Promise.<string>}
     */
    async getYAxisTitle(){
        try{
            var {title} = await BC.getYAxisTitle(this.barchartId);
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
            await BC.setChartOnSelected(this.barchartId);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置选中的对象ID
     * @memberOf ChartView
     * @param {number} geoId
     * @returns {Promise.<void>}
     */
    async setSelectedGeometryID(geoId){
        try{
            await BC.setSelectedGeometryID(this.chartviewId,geoId);
        }catch(e){
            console.error(e);
        }
    }
}
