//
//  SMCartography.m
//  Supermap
//
//  Created by xianglong li on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SMCartography.h"
#import "SuperMap/SuperMap.h"


@implementation SMCartography
RCT_EXPORT_MODULE();

- (Layer *)getLayerByIndex:(int)layerIndex{
    @try{
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        Layers *layers = mapControl.map.layers;
        return [layers getLayerAtIndex:layerIndex];
    }
    @catch(NSException *exception){
        @throw exception;
    }
}

- (LayerSettingVector *)getLayerSettingVector:(int) layerIndex{
    @try{
        Layer *layer = [self getLayerByIndex:layerIndex];
        if(layer != nil && layer.theme == nil)
        {
            if(layer.layerSetting != nil && layer.layerSetting.layerType == VECTOR)
            {
                layer.editable = true;
                return layer.layerSetting;
            }
            else
            {
                return nil;
            }
        }
        else
        {
            return nil;
        }
    }
    @catch(NSException *exception){
        @throw exception;
    }
}

#pragma 16进制rgb字符串转rgb
- (Color *) colorWithHexString: (NSString *)strcolor
{
    NSString *cString = [[strcolor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return nil;
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return nil;
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    Color *color = [[Color alloc]initWithR:r G:g B:b];
    return color;
}

/*点风格
 * ********************************************************************************************/

#pragma mark 设置点符号的ID, layerIndex:图层索引
RCT_REMAP_METHOD(setMakerSymbolID, setMakerSymbolIDWithResolver:(int) makerSymbolID layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setMarkerSize, setMarkerSizeWithResolver:(int) mm layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setMarkerColor, setMarkerColorWithResolver:(NSString*) strcolor layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
        if (layerSettingVector != nil) {
            Color *color = [self colorWithHexString:strcolor];
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
RCT_REMAP_METHOD(setMarkerAngle, setMarkerAngleWithResolver:(int) angle layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setMarkerAlpha, setMarkerAlphaWithResolver:(int) alpha layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setLineSymbolID, setLineSymbolIDWithResolver:(int) lineSymbolID layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setLineWidth, setLineWidthWithResolver:(int) mm layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setLineColor, setLineColorWithResolver:(NSString *) lineColor layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            Color *color = [self colorWithHexString:lineColor];
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
RCT_REMAP_METHOD(setFillSymbolID, setFillSymbolIDWithResolver:(int) FillSymbolID layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setFillForeColor, setFillForeColorWithResolver:(NSString *) fillForeColor layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            Color *color = [self colorWithHexString:fillForeColor];
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
RCT_REMAP_METHOD(setFillBackColor, setFillBackColorWithResolver:(NSString *) fillBackColor layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
        if (layerSettingVector != nil) {
            GeoStyle *style = layerSettingVector.geoStyle;
            Color *color = [self colorWithHexString:fillBackColor];
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
RCT_REMAP_METHOD(setFillOpaqueRate, setFillOpaqueRateWithResolver:(int) fillOpaqueRate layerIndex:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setFillLinearGradient, setFillLinearGradientWithResolver:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setFillRadialGradient, setFillRadialGradientWithResolver:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setFillSquareGradient, setFillSquareGradientWithResolver:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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
RCT_REMAP_METHOD(setFillNoneGradient, setFillNoneGradientWithResolver:(int) layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        if (![Environment isOpenGLMode]) {
            LayerSettingVector *layerSettingVector = [self getLayerSettingVector:layerIndex];
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


/*文本风格
 * ********************************************************************************************/

@end


