import {NativeModules} from 'react-native';
let LS = NativeModules.JSLayerSetting;
//import LSV from './LayerSettingVector.js';

/**
 * @class LayerSetting
 */
export default class LayerSetting {

    /**
     *  返回此图层的类型。
     *  @memberOf LayerSetting
     * @returns {Promise.<Promise|*|Dataset.Type>}
     */
    async getType(){
        try{
            var layerSettingType = await LS.getType(this._layerSettingId_);
            return layerSettingType;
        }catch(e){
            console.error(e);
        }
    }
    
    /**
     *  类型装换layerSetting 转layerSettingVector。
     *  @memberOf LayerSetting
     * @returns {Promise.<Promise|*|Dataset.Type>}
     */
/*    async toSubClass(){
        try{
            var layerSettingType = await LS.getType(this._layerSettingId_);
            switch (layerSettingType){
                case 0 :
                    var {_layerSettingVectorId_} = await LS.toLayerSettingVector(this._layerSettingId_);
                    var lsv = new LSV();
                    lsv._layerSettingVectorId_ = _layerSettingVectorId_;
                    return lsv
                    break;
                case 1 :
//                    var {_layerSettingImageId_} = await LS.toLayerSettingImage(this._layerSettingId_);
//                    var lsi = new LSI();
//                    lsi._layerSettingImageId_ = _layerSettingImageId_;
//                    return lsi
//                    break;
                case 2 :
//                    var {_layerSettingGridId_} = await LS.toLayerSettingGrid(this._layerSettingId_);
//                    var lsg = new LSG();
//                    lsg._layerSettingGridId_ = _layerSettingGridId_;
//                    return lsg
//                    break;
                default :
                    return 'plsase input lsv';
            }
        }catch(e){
            console.error(e);
        }
    }*/
}
