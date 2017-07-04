import {NativeModules} from 'react-native';
let TL = NativeModules.JSTrackingLayer;

/**
 * @class TrackingLayer
 */
export default class TrackingLayer {
    /**
     * 向当前跟踪图层中添加一个几何对象，并给出该几何对象的标签信息。
     * @memberOf TrackingLayer
     * @param {object} geometry - 矢量对象
     * @param {string} tag - 矢量对象的标签名称
     * @returns {Promise.<void>}
     */
    async add(geometry,tag){
        try{
            var id = geometry.geometryId;
            await TL.add(this.trackingLayerId,id,tag);
        }catch (e){
            console.error(e);
        }
    }

    /**
     * 清空此跟踪图层中的所有几何对象。
     * @returns {Promise.<void>}
     */
    async clear(){
        try{
            await TL.clear(this.trackingLayerId);
        }catch (e){
            console.error(e);
        }
    }
}
