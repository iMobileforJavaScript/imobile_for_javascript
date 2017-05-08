/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let CD = NativeModules.JSChartData;

/**
 * @class Layer
 */
export default class ChartData{
    /**
     * 创建一个ChartData对象
     * @memberOf ChartData
     * @param {string}label - 图表标题
     * @param {int}color - 图表颜色
     * @param {int}geoId - ID
     * @returns {Promise.<void>}
     */
    async createObj(label,color,geoId){
        try{
            var {_chartdataId} = await CD.createObj(label,color,geoId);
            var chartData = new ChartData();
            chartData.chartDataId = _chartdataId;
            return chartData;
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 关联地图对应几何对象。
     * @memberOf ChartData
     * @param {int}geoId - 地图对应几何对象Id
     * @returns {Promise.<void>}
     */
    async setGeometryID(geoId){
        try{
            await CD.setGeometryID(this.chartDataId,geoId);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置每个条目的标签
     * @memberOf ChartView
     * @param {string}label - 条目标签
     * @returns {Promise.<void>}
     */
    async setLabel(label){
        try{
            await CD.setLabel(this.chartDataId,label);
        }catch(e){
            console.error(e);
        }
    }
}
