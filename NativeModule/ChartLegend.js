/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let CL = NativeModules.JSChartLegend;

/**
 * @class Layer
 */
export default class ChartLegend{
    /**
     * 设置图例竖直或者水平显示。
     * @memberOf ChartLegend
     * @param {bool}b - 水平／竖直显示标识位
     * @returns {Promise.<void>}
     */
    async setOrient(b){
        try{
            await CL.setOrient(this.chartLegendId,b);
        }catch(e){
            console.error(e);
        }
    }
    /**
     * 获取图例竖直或者水平显示。（该方法只支持iOS端）
     * @memberOf ChartLegend
     * @returns {Promise.<bool>}
     */
    async isOrient(){
        try{
            var {orient} = await CL.isOrient(this.chartLegendId);
            return orient;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置图例位置。
     * @memberOf ChartLegend
     * @param {string}label - 条目标签
     * @returns {Promise.<void>}
     */
    async setAlignment(alignment){
        try{
            await CL.setAlignment(this.chartLegendId,alignment);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取图例位置。（该方法只支持iOS端）
     * @memberOf ChartLegend
     * @param {string}label - 条目标签
     * @returns {Promise.<void>}
     */
    async getAlignment(){
        try{
            var {alignment} = await CL.getAlignment(this.chartDataId);
            return alignment;
        }catch(e){
            console.error(e);
        }
    }
}
