/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let CV = NativeModules.JSChartView;
import ChartLegend from './ChartLegend.js';

/**
 * @class Layer
 */
export default class ChartView{
    /**
     * 设置标题
     * @memberOf ChartView
     * @param {string}Title - 图表标题
     * @returns {Promise.<void>}
     */
    async setTitle(Title){
        try{
            await CV.setTitle(this.chartviewId,Title);
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 获取标题
     * @memberOf ChartView
     * @returns {Promise.<boolean>}
     */
    async getTitle(){
        try{
            var{title} = await CV.getTitle(this.chartviewId);
            return title;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取统计图图例
     * @memberOf ChartView
     * @returns {Promise.<ChartLegend>}
     */
    async getLegend(){
        try{
            var {chartLegendId} = await CV.getLegend(this.chartviewId);
            var chartLegend = new ChartLegend();
            chartLegend.chartLegendId = chartLegendId;
            return chartLegend;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 接入统计数据
     * @memberOf ChartView
     * @param {object}data - 统计数据
     * @returns {Promise.<void>}
     */
    async addChartData(data,timeTag){
        try{
            if(arguments.length==2){
            await CV.addChartDataWithTime(this.chartviewId,data,timeTag);
            }else{
            await CV.addChartData(this.chartviewId,data);
            }
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 移除统计数据。
     * @memberOf ChartView
     * @param {object} data - 统计数据
     * @returns {Promise.<void>}
     */
    async removeChartData(timeTag){
        try{
            if(arguments.length ==1){
            await CV.removeChartDataWithTimeTag(this.chartviewId,timeTag);
            }else{
            await CV.removeAllData(this.chartviewId);
            }
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 销毁图表
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async dispose(){
        try{
            await CV.dispose(this.chartviewId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 更新图表
     * @memberOf ChartView
     * @returns {Promise.<void>}
     */
    async update(){
        try{
            await CV.update(this.chartviewId);
        }catch(e){
            console.error(e);
        }
    }
}
