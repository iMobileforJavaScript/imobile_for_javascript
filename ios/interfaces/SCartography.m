//
//  SMCartography.m
//  Supermap
//
//  Created by xianglong li on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SCartography.h"
#import "SuperMap/SuperMap.h"
#import "SMCartography.h"
#import "STranslate.h"
#import "SMap.h"


@implementation SCartography
RCT_EXPORT_MODULE();

/*点风格
 * ********************************************************************************************/

#pragma mark 设置点符号的ID, layerIndex:图层索引
RCT_REMAP_METHOD(setMakerSymbolID, setMakerSymbolIDWithResolver:(int) makerSymbolID layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            [style setMarkerSymbolID:makerSymbolID];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置点符号的大小：1-100mm
RCT_REMAP_METHOD(setMarkerSize, setMarkerSizeWithResolver:(int) mm layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            Size2D  *size = [[Size2D alloc] initWithWidth:mm Height:mm];
            [style setMarkerSize:size];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置点符号的颜色，color: 十六进制颜色码
RCT_REMAP_METHOD(setMarkerColor, setMarkerColorWithResolver:(NSString*) strcolor layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            Color *color = [STranslate colorFromHexString:strcolor];
            GeoStyle *style = layerSettingVector.geoStyle;
            [style setLineColor:color];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置点符号的旋转角度：0-360°
RCT_REMAP_METHOD(setMarkerAngle, setMarkerAngleWithResolver:(int) angle layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            [style setMarkerAngle:angle];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置点符号的透明度：0-100%
RCT_REMAP_METHOD(setMarkerAlpha, setMarkerAlphaWithResolver:(int) alpha layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            [style setFillOpaqueRate:100-alpha];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/*线风格
 * ********************************************************************************************/
#pragma 设置线符号的ID(设置边框符号的ID)
RCT_REMAP_METHOD(setLineSymbolID, setLineSymbolIDWithResolver:(int) lineSymbolID layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            [style setLineSymbolID:lineSymbolID];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置线宽：1-10mm(边框符号宽度)
RCT_REMAP_METHOD(setLineWidth, setLineWidthWithResolver:(int) mm layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            double width = (double) mm / 10;
            [style setMarkerAngle:width];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置线宽：1-10mm(边框符号宽度)
RCT_REMAP_METHOD(setLineWidthByIndex, setLineWidthByIndexWithResolver:(int) mm layerIndex:(int)layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVectorByIndex:layerIndex];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            double width = (double) mm / 10;
            [style setMarkerAngle:width];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置线颜色(边框符号颜色)
RCT_REMAP_METHOD(setLineColor, setLineColorWithResolver:(NSString *) lineColor layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            Color *color = [STranslate colorFromHexString:lineColor];
            [style setLineColor:color];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/*面风格
 * ********************************************************************************************/
#pragma 设置面符号的ID
RCT_REMAP_METHOD(setFillSymbolID, setFillSymbolIDWithResolver:(int) FillSymbolID layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            [style setFillSymbolID:FillSymbolID];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置前景色
RCT_REMAP_METHOD(setFillForeColor, setFillForeColorWithResolver:(NSString *) fillForeColor layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            Color *color = [STranslate colorFromHexString:fillForeColor];
            [style setFillForeColor:color];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置背景色
RCT_REMAP_METHOD(setFillBackColor, setFillBackColorWithResolver:(NSString *) fillBackColor layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            Color *color = [STranslate colorFromHexString:fillBackColor];
            [style setFillBackColor:color];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置透明度（0-100）
RCT_REMAP_METHOD(setFillOpaqueRate, setFillOpaqueRateWithResolver:(int) fillOpaqueRate layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            [style setFillOpaqueRate:100-fillOpaqueRate];
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置线性渐变
RCT_REMAP_METHOD(setFillLinearGradient, setFillLinearGradientWithResolver:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
            if (layerSettingVector != nil) {
                GeoStyle *style = layerSettingVector.geoStyle;
                [style setFillGradientMode:FGM_LINEAR];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            } else {
                resolve([NSNumber numberWithBool:NO]);
            }
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置辐射渐变
RCT_REMAP_METHOD(setFillRadialGradient, setFillRadialGradientWithResolver:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
            if (layerSettingVector != nil) {
                GeoStyle *style = layerSettingVector.geoStyle;
                [style setFillGradientMode:FGM_RADIAL];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            } else {
                resolve([NSNumber numberWithBool:NO]);
            }
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置方形渐变
RCT_REMAP_METHOD(setFillSquareGradient, setFillSquareGradientWithResolver:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
            if (layerSettingVector != nil) {
                GeoStyle *style = layerSettingVector.geoStyle;
                [style setFillGradientMode:FGM_SQUARE];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            } else {
                resolve([NSNumber numberWithBool:NO]);
            }
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置无渐变
RCT_REMAP_METHOD(setFillNoneGradient, setFillNoneGradientWithResolver:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [SMCartography getLayerSettingVector:layername];
            if (layerSettingVector != nil) {
                GeoStyle *style = layerSettingVector.geoStyle;
                [style setFillGradientMode:FGM_NONE];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            } else {
                resolve([NSNumber numberWithBool:NO]);
            }
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/*栅格风格
 * ********************************************************************************************/
#pragma 设置点符号的透明度：0-100%
RCT_REMAP_METHOD(setGridOpaqueRate, setGridOpaqueRateWithResolver:(int) gridOpaqueRate layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingGrid *layerSettingVector = [SMCartography getLayerSettingGrid:layername];
        if (layerSettingVector != nil) {
//            layerSettingGrid.setOpaqueRate(100 - gridOpaqueRate); //新增接口，待打开
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置亮度(-100%-100%)
RCT_REMAP_METHOD(setGridContrast, setGridContrastWithResolver:(int) gridContrast layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingGrid *layerSettingVector = [SMCartography getLayerSettingGrid:layername];
        if (layerSettingVector != nil) {
            //           layerSettingGrid.setContrast(gridContrast); //新增接口，待打开
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置对比度(-100%-100%)
RCT_REMAP_METHOD(setGridBrightness, setGridBrightnessWithResolver:(int) gridBrightness layerName:(NSString *)layername resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingGrid *layerSettingVector = [SMCartography getLayerSettingGrid:layername];
        if (layerSettingVector != nil) {
            //             layerSettingGrid.setBrightness(gridBrightness); //新增接口，待打开
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/*文本风格
 * ********************************************************************************************/
- (BOOL ) saveGeoText: (Recordset *)recordset geometry:(Geometry* ) geometry
{
    [recordset edit];
    [recordset setGeometry:geometry];
    bool bUpdate = [recordset update];
    [[SMap singletonInstance].smMapWC.mapControl.map refresh];
    [recordset close];
    [recordset dispose];
    return bUpdate;
}

#pragma 设置字号
RCT_REMAP_METHOD(setTextFontSize, setTextFontSizeWithResolver:(int) size geometryID:(int)geometryID layerName:(NSString*) layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Recordset* recordset = [SMCartography getRecordset:geometryID layerName:layerName];
        Geometry* geometry = [SMCartography getGeoText:recordset];
        if (recordset != nil && geometry != nil) {
            GeoText* geotext = (GeoText* )geometry;
            TextStyle* textStyle = [geotext getTextStyle];
            [textStyle setFontHeight:(double)size];
            [geotext setTextStyle:textStyle];
            bool bUpdate = [self saveGeoText:recordset geometry:geometry];
            resolve([NSNumber numberWithBool:bUpdate]);
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置字体颜色
RCT_REMAP_METHOD(setTextFontColor, setTextFontColorWithResolver:(NSString*) color geometryID:(int)geometryID layerName:(NSString*) layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Recordset* recordset = [SMCartography getRecordset:geometryID layerName:layerName];
        Geometry* geometry = [SMCartography getGeoText:recordset];
        if (recordset != nil && geometry != nil) {
            Color *co = [STranslate colorFromHexString:color];
            GeoText* geotext = (GeoText* )geometry;
            TextStyle* textStyle = [geotext getTextStyle];
            [textStyle setForeColor:co];
            [geotext setTextStyle:textStyle];
            bool bUpdate = [self saveGeoText:recordset geometry:geometry];
            resolve([NSNumber numberWithBool:bUpdate]);
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置旋转角度
RCT_REMAP_METHOD(setTextFontRotation, setTextFontRotationWithResolver:(int) angle geometryID:(int)geometryID layerName:(NSString*) layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Recordset* recordset = [SMCartography getRecordset:geometryID layerName:layerName];
        Geometry* geometry = [SMCartography getGeoText:recordset];
        if (recordset != nil && geometry != nil) {
            GeoText* geotext = (GeoText* )geometry;
            TextStyle* textStyle = [geotext getTextStyle];
            [textStyle setRotation:angle];
            [geotext setTextStyle:textStyle];
            bool bUpdate = [self saveGeoText:recordset geometry:geometry];
            resolve([NSNumber numberWithBool:bUpdate]);
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置位置
RCT_REMAP_METHOD(setTextFontPosition, setTextFontPositionSizeWithResolver:(NSString*) textAlignment geometryID:(int)geometryID layerName:(NSString*) layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Recordset* recordset = [SMCartography getRecordset:geometryID layerName:layerName];
        Geometry* geometry = [SMCartography getGeoText:recordset];
        if (recordset != nil && geometry != nil) {
            GeoText* geotext = (GeoText* )geometry;
            TextStyle* textStyle = [geotext getTextStyle];
            TextAlignment alignment = [SMCartography getTextAlignment:textAlignment];
            [textStyle setAlignment:alignment];
            [geotext setTextStyle:textStyle];
            bool bUpdate = [self saveGeoText:recordset geometry:geometry];
            resolve([NSNumber numberWithBool:bUpdate]);
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma 设置字体风格(加粗BOLD、斜体ITALIC、下划线UNDERLINE、删除线STRIKEOUT、轮廓OUTLINE、阴影SHADOW)
RCT_REMAP_METHOD(setTextStyle, setTextStyleWithResolver:(NSString*) style whether:(bool)whether geometryID:(int)geometryID layerName:(NSString*) layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Recordset* recordset = [SMCartography getRecordset:geometryID layerName:layerName];
        Geometry* geometry = [SMCartography getGeoText:recordset];
        if (recordset != nil && geometry != nil) {
            GeoText* geotext = (GeoText* )geometry;
            TextStyle* textStyle = [geotext getTextStyle];
            if ([style isEqualToString:@"BOLD"]) {
                [textStyle setBold:whether];
            }
            if ([style isEqualToString:@"ITALIC"]) {
                [textStyle setItalic:whether];
            }
            if ([style isEqualToString:@"UNDERLINE"]) {
                [textStyle setUnderline:whether];
            }
            if ([style isEqualToString:@"STRIKEOUT"]) {
                [textStyle setStrikeout:whether];
            }
            if ([style isEqualToString:@"OUTLINE"]) {
                [textStyle setOutline:whether];
            }
            if ([style isEqualToString:@"SHADOW"]) {
                [textStyle setShadow:whether];
            }
            [geotext setTextStyle:textStyle];
            bool bUpdate = [self saveGeoText:recordset geometry:geometry];
            resolve([NSNumber numberWithBool:bUpdate]);
        }
        else
        {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

@end


