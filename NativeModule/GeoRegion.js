import {NativeModules} from 'react-native';
let X = NativeModules.JSGeoRegion;
import Geometry from './Geometry.js';

/**
 * @class GeoRegion
 * @description 面几何对象类。
 */
export default class GeoRegion extends Geometry{
    constructor(){
        super();
        Object.defineProperty(this,"_SMGeoRegionId",{
            get:function () {
                return this._SMGeometryId
            },
            set:function (_SMGeoRegionId) {
                this._SMGeometryId = _SMGeoRegionId;
            }
        });
    }
}
