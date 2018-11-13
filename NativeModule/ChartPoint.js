/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let CP = NativeModules.JSChartPoint;

/**
 * @class Layer
 */
export default class ChartPoint{
    /**
     * 创建一个ChartPoint对象
     * @memberOf ChartData
     * @param {object}para - para {}
     * @returns {Promise.<ChartPoint>}
     */
    async createObj(weight,x,y){
        try{
            if(arguments.length==3){
                var {_chartpointId} = await CP.createObj(weight,x,y);
            }else if(arguments.length==2){
                var {_chartpointId} = await CP.createObjByPoint(weight,x.point2DId);
            }else{
                console('arguments number should be 3 or 2');
                return;
            }
            var chartPoint = new ChartPoint();
            chartPoint.chartPointId = _chartpointId;
            return chartPoint;
        }catch(e){
            console.error(e);
        }
    }
}
