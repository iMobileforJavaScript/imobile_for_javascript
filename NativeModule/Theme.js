import {NativeModules} from 'react-native';
let T = NativeModules.JSTheme;

export default class Theme {

    async makeThemeLabel(themeParam) {
        try {
            var {themeId} = await T.makeThemeLabel(themeParam.datasetVector.datasetVectorId, themeParam.rangeExpression, themeParam.rangeMode, themeParam.rangeParameter, themeParam.colorGradientType);
            var theme = new Theme();
            theme.themeId = themeId;
            return theme;
        } catch (e) {
            console.error(e);
        }
    }

    async makeThemeUnique(themeParam) {
        try {
            var {themeId} = await T.makeThemeUnique(themeParam.datasetVector.datasetVectorId, themeParam.uniqueExpression, themeParam.colorGradientType);
            var theme = new Theme();
            theme.themeId = themeId;
            return theme;
        } catch (e) {
            console.error(e);
        }
    }
    
    async makeThemeRange(themeParam) {
        try {
            var {themeId} = await T.makeThemeRange(themeParam.datasetVector.datasetVectorId, themeParam.rangeExpression, themeParam.rangeMode, themeParam.rangeParameter, themeParam.colorGradientType);
            var theme = new Theme();
            theme.themeId = themeId;
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
