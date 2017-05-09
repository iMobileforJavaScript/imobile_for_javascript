/**
 * Created by will on 2016/7/5.
 */
import {NativeModules} from 'react-native';
let CS = NativeModules.JSColorScheme;
/**
 * @class PieChart
 */
export default class ColorScheme{
    /**
     * 构造方法
     * @memberOf ColorScheme
     * @returns {Promise.<void>}
     */
    async createObj(){
        try{
            var {colorSchemeId} = await CS.createObj();
            var colorscheme = new ColorScheme();
            colorscheme.colorSchemeId = colorSchemeId;
            return colorscheme;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置颜色
     * @memberOf ColorScheme
     * @returns {Promise.<void>}
     */
    async setColors(colorArr){
        try{
            await CS.setColors(this.colorSchemeId,colorArr);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取颜色
     * @memberOf ColorScheme
     * @returns {Promise.<void>}
     */
    async getColors(){
        try{
            var {colors} = await CS.getColors(this.colorSchemeId);
            return colors;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 设置分段值
     * @memberOf ColorScheme
     * @returns {Promise.<void>}
     */
    async setSegmentValue(value){
        try{
            await CS.setSegmentValue(this.colorSchemeId,value);
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     * 获取分段值
     * @memberOf ColorScheme
     * @returns {Promise.<void>}
     */
    async getSegmentValue(){
        try{
            var {segmentValue} = await CS.getSegmentValue(this.colorSchemeId);
            return segmentValue;
        }catch(e){
            console.error(e);
        }
    }
}
