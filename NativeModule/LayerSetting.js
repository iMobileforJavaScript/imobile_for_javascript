/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Wang zihao
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/
import {NativeModules} from 'react-native';
let LS = NativeModules.JSLayerSetting;

/**
 * @class LayerSetting
 * @description 图层设置基类。(虚类)
 */
export default class LayerSetting {

    /**
     *  返回此图层的类型。
     *  @memberOf LayerSetting
     * @returns {Promise.<Promise|*|Dataset.Type>}
     */
    async getType(){
        try{
            var layerSettingType = await LS.getType(this._SMLayerSettingId);
            return layerSettingType;
        }catch(e){
            console.error(e);
        }
    }
}
