/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 Description:时间轴类
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let TL = NativeModules.JSTimeLine;
import ChartView from './ChartView.js';

/**
 * @class TimeLine
 * @description 时间轴类，根据时间对数据进行展示的地图可视化图表
 */
export default class TimeLine {
    
    /**
     * 创建TimeLine对象
     * @memberOf TimeLine
     * @param {number} reactTag - 视图对应的reactTag值
     * @returns {Promise.<TimeLine>}
     */
    async createObj(reactTag){
        var{_SMTimeLine} = TL.createObj(reactTag);
        var timeLine = new TimeLine();
        timeLine._SMTimeLine = _SMTimeLine;
        return timeLine;
    }
    
    /**
     * 设置滑块大小
     * @memberOf TimeLine
     * @param {number} size
     * @returns {Promise.<void>}
     */
    async setSliderSize(size){
        try{
            await TL.setSliderSize(this._SMTimeLine,size);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取滑块大小
     * @memberOf TimeLine
     * @returns {Promise.<number>}
     */
    async getSliderSize(){
        try{
            var{size} = await TL.getSliderSize(this._SMTimeLine);
            return size;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置滑块风格
     * @memberOf TimeLine
     * @param {string} url - 图片资源路径
     * @returns {Promise.<void>}
     */
    async setSliderImage(url){
        try{
            await TL.setSliderImage(this._SMTimeLine,url);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取滑块风格
     * @memberOf TimeLine
     * @returns {Promise.<object>}
     */
    async getSliderImage(){
        try{
            var {image} = await TL.getSliderImage(this._SMTimeLine);
            return image;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置滑块选中风格
     * @memberOf TimeLine
     * @param {string} url - 图片资源路径
     * @returns {Promise.<void>}
     */
    async setSliderSelectedImage(url){
        try{
            await TL.setSliderSelectedImage(this._SMTimeLine,url);
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 获取滑块选中风格
     * @memberOf TimeLine
     * @returns {Promise.<object>}
     */
    async getSliderSelectedImage(){
        try{
            var {image} = await TL.getSliderSelectedImage(this._SMTimeLine);
            return image;
        }catch(e){
            console.error(e);
        }
    }

    /**
     * 设置滑块标签字体大小
     * @memberOf TimeLine
     * @param {number} size - 字体大小
     * @returns {Promise.<void>}
     */
    async setSliderLabelSize(size){
        try{
            await TL.setSliderLabelSize(this._SMTimeLine,size);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取滑块标签字体大小
     * @memberOf TimeLine
     * @returns {Promise.<number>}
     */
    async getSliderLabelSize(){
        try{
            var {size} = await TL.getSliderLabelSize(this._SMTimeLine);
            return size;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置滑块标签字体颜色
     * @memberOf TimeLine
     * @param {Arr} color - 字体颜色数组
     * @returns {Promise.<void>}
     */
    async setSliderLabelColor(color){
        try{
            await TL.setSliderLabelColor(this._SMTimeLine,color);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取滑块标签字体颜色
     * @memberOf TimeLine
     * @returns {Promise.<Arr>}
     */
    async getSliderLabelColor(){
        try{
            var {color} = await TL.getSliderLabelColor(this._SMTimeLine);
            return color;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置时间轴风格
     * @memberOf TimeLine
     * @param {Arr} color - 字体颜色数组
     * @returns {Promise.<void>}
     */
    async setTimeLineColor(color){
        try{
            await TL.setTimeLineColor(this._SMTimeLine,color);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取时间轴风格
     * @memberOf TimeLine
     * @returns {Promise.<Arr>}
     */
    async getTimeLineColor(){
        try{
            var {color} = await TL.getTimeLineColor(this._SMTimeLine);
            return color;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置播放按钮风格
     * @memberOf TimeLine
     * @param {string} url - 图片资源路径
     * @returns {Promise.<void>}
     */
    async setPlayImage(url){
        try{
            await TL.setPlayImage(this._SMTimeLine,url);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取播放按钮风格
     * @memberOf TimeLine
     * @returns {Promise.<object>}
     */
    async getPlayImage(){
        try{
            var {image} = await TL.getPlayImage(this._SMTimeLine);
            return image;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置停止按钮风格
     * @memberOf TimeLine
     * @param {string} url - 图片资源路径
     * @returns {Promise.<void>}
     */
    async setStopPlayImage(url){
        try{
            await TL.setStopPlayImage(this._SMTimeLine,url);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取停止按钮风格
     * @memberOf TimeLine
     * @returns {Promise.<object>}
     */
    async getStopPlayImage(){
        try{
            var {image} = await TL.getStopPlayImage(this._SMTimeLine);
            return image;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置时间轴是否水平放置
     * @memberOf TimeLine
     * @param {boolean} b
     * @returns {Promise.<void>}
     */
    async setHorizontal(b){
        try{
            await TL.setHorizontal(this._SMTimeLine,b);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取时间轴是否水平放置
     * @memberOf TimeLine
     * @returns {Promise.<object>}
     */
    async isHorizontal(){
        try{
            var {bool} = await TL.isHorizontal(this._SMTimeLine);
            return bool;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 添加关联图表
     * @memberOf TimeLine
     * @param {ChartView} chart - 关联图表
     * @returns {Promise.<void>}
     */
    async addChart(chart){
        try{
            await TL.addChart(this._SMTimeLine,chart.chartviewId);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 移除关联图表
     * @memberOf TimeLine
     * @returns {Promise.<object>}
     */
    async removeChart(chart){
        try{
            await TL.removeChart(this._SMTimeLine,chart.chartviewId);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 清空所有关联图表
     * @memberOf TimeLine
     * @returns {Promise.<void>}
     */
    async clearChart(){
        try{
            await TL.clearChart(this._SMTimeLine);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 加载时间轴
     * @memberOf TimeLine
     * @returns {Promise.<object>}
     */
    async load(){
        try{
            await TL.load(this._SMTimeLine);
        }catch(e){
            console.error(e);
        }
    }

}
