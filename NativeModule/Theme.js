/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: will
 E-mail: pridehao@gmail.com
 
 **********************************************************************************/

import { NativeModules } from 'react-native';
let T = NativeModules.JSTheme;

// import ThemeUnique from './ThemeUnique'
// import ThemeRange from './ThemeRange'
// import ThemeLabel from './ThemeLabel'

/**
 * @class Theme
 * @description 专题图类，该类是所有专题图的基类。
 */
export default class Theme {
  
  /**
   * 创建标签专题图。
   * @memberOf Theme
   * @param {Object} themeParam
   * @description 参数对象:{datasetVector:<DatasetVector>,rangeExpression:<string>分段字段表达式,rangeMode:<number>分段模式,rangeParameter:<number>分段参数,colorGradientType:<number>颜色渐变模式}
   * @returns {Promise.<Theme>}
   */
  async makeThemeLabel(themeParam) {
    try {
      let { themeId } = await T.makeThemeLabel(themeParam.datasetVector._SMDatasetVectorId, themeParam.rangeExpression, themeParam.rangeMode, themeParam.rangeParameter, themeParam.colorGradientType);
      let theme = new Theme();
      theme._SMThemeId = themeId;
      return theme;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 生成默认的单值专题图。
   * @memberOf Theme
   * @param {Object} themeParam
   * @description 参数对象:{datasetVector:<DatasetVector>,uniqueExpression:<string>单值专题图字段表达式,colorGradientType:<number>颜色渐变模式}
   * @returns {Promise.<AMQPManager>}
   */
  async makeThemeUnique(themeParam) {
    try {
      let { themeId } = await T.makeThemeUnique(themeParam.datasetVector._SMDatasetVectorId, themeParam.uniqueExpression, themeParam.colorGradientType);
      let theme = new Theme();
      theme._SMThemeId = themeId;
      return theme;
    } catch (e) {
      console.error(e);
    }
  }
  
  /**
   * 生成默认的分段专题图。
   * @memberOf Theme
   * @param {Object} themeParam
   * @description 参数对象:{datasetVector:<DatasetVector>,rangeExpression:<string>分段字段表达式,rangeMode:<number>分段模式,rangeParameter:<number>分段参数,colorGradientType:<number>颜色渐变模式}
   * @returns {Promise.<Theme>}
   */
  async makeThemeRange(themeParam) {
    try {
      let { themeId } = await T.makeThemeRange(themeParam.datasetVector._SMDatasetVectorId, themeParam.rangeExpression, themeParam.rangeMode, themeParam.rangeParameter, themeParam.colorGradientType);
      let theme = new Theme();
      theme._SMThemeId = themeId;
      return theme;
    } catch (e) {
      console.error(e);
    }
  }
  
}

Theme.RangeMode = {
  NONE: 6,
  EQUALINTERVAL: 0,
  SQUAREROOT: 1,
  STDDEVIATION: 2,
  LOGARITHM: 3,
  QUANTILE: 4,
  CUSTOMINTERVAL: 5
};

Theme.ColorGradientType = {
  BLACKWHITE: 0,
  REDWHITE: 1,
  GREENWHITE: 2,
  BLUEWHITE: 3,
  YELLOWWHITE: 4,
  PINKWHITE: 5,
  CYANWHITE: 6,
  REDBLACK: 7,
  GREENBLACK: 8,
  BLUEBLACK: 9,
  YELLOWBLACK: 10,
  PINKBLACK: 11,
  CYANBLACK: 12,
  YELLOWRED: 13,
  YELLOWGREEN: 14,
  YELLOWBLUE: 15,
  GREENBLUE: 16,
  GREENRED: 17,
  BLUERED: 18,
  PINKRED: 19,
  PINKBLUE: 20,
  CYANBLUE: 21,
  CYANGREEN: 22,
  RAINBOW: 23,
  GREENORANGEVIOLET: 24,
  TERRAIN: 25,
  SPECTRUM: 26
}
