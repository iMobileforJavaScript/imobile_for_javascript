/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Yang Shanglong
 E-mail: yangshanglong@supermap.com
 **********************************************************************************/
import { NativeModules } from 'react-native';
let CSTP = NativeModules.JSCoordSysTransParameter;

/**
 * 投影坐标系转换参数。通常包括平移、旋转和比例因子。
 */
export default class CoordSysTransParameter {
  async createObj() {
    try {
      let coordSysTransParameterId = await CSTP.createObj();
      let coordSysTransParameter = new CoordSysTransParameter();
      coordSysTransParameter._SMCoordSysTransParameterId = coordSysTransParameterId;
      return coordSysTransParameter;
    } catch (e) {
      console.error(e);
    }
  }
  
  // TODO 添加方法
  
}
