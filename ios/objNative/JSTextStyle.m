//
//  JSTextStyle.m
//  Supermap
//
//  Created by wnmng on 2018/8/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSTextStyle.h"
#import "SuperMap/TextStyle.h"
#import "JSObjManager.h"
#import "SuperMap/Color.h"

@implementation JSTextStyle
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [[TextStyle alloc] init];
        NSInteger nsKey = (NSInteger)textStyle;
        [JSObjManager addObj:textStyle];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"createObj expection",nil);
    }
}
/**
 * 返回当前 TextStyle 对象的一个拷贝
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(clone,clone:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        TextStyle* newStyle = [textStyle clone];
        NSInteger nsKey = (NSInteger)newStyle;
        [JSObjManager addObj:newStyle];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"clone expection",nil);
    }
}
/**
 * 释放该对象所占用的资源
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(dispose,dispose:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        //没有dispose方法
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"dispose expection",nil);
    }
}
/**
 * 将指定的几何对象绘制成图片
 * @param textStyleId
 * @param geometryId
 * @param resourcesId
 * @param fileName
 * @param promise
 */
RCT_REMAP_METHOD(drawToPNG,drawToPNG:(NSString*)textStyleId geometry:(NSString*)geometryId resources:(NSString*)resourcesId fileName:(NSString*)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        //没有drawToPNG方法
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"drawToPNG expection",nil);
    }
}
/**
 * 返回文本的对齐方式
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getAlignment,getAlignment:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        TextAlignment align = [textStyle getAlignment];
        resolve([NSNumber numberWithInt:align]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getAlignment expection",nil);
    }
}
/**
 * 返回文本的背景色
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getBackColor,getBackColor:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        Color* backColor = [textStyle getBackColor];
        int r = [backColor red];
        int g = [backColor green];
        int b = [backColor blue];
        int a = [backColor alpha];
        NSDictionary *dictionary = @{@"r":@(r),
                                     @"g":@(g),
                                     @"b":@(b),
                                     @"a":@(a)};
        resolve(dictionary);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getBackColor expection",nil);
    }
}

/**
 * 获取背景半透明度
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getBackTransparency,getBackTransparency:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        //接口缺失getBackTransparency
        
        resolve([NSNumber numberWithInt:100]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getBackTransparency expection",nil);
    }
}


/**
 * 返回文本字体的高度
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getFontHeight,getFontHeight:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        double fontHeight = [textStyle getFontHeight];
        resolve([NSNumber numberWithDouble:fontHeight]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getFontHeight expection",nil);
    }
}

/**
 * 返回文本字体的名称
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getFontName,getFontName:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        NSString *fontname = [textStyle getFontName];
        resolve(fontname);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getFontName expection",nil);
    }
}

/**
 * 获取注记字体的缩放比例
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getFontScale,getFontScale:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        double fontScale = [textStyle getFontScale];
        resolve([NSNumber numberWithDouble:fontScale]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getFontScale expection",nil);
    }
}

/**
 * 返回文本的宽度
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getFontWidth,getFontWidth:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        double fontWidth = [textStyle getFontWidth];
        resolve([NSNumber numberWithDouble:fontWidth]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getFontWidth expection",nil);
    }
}

/**
 * 返回文本的前景色
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getForeColor,getForeColor:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        Color* foreColor = [textStyle getForeColor];
        int r = [foreColor red];
        int g = [foreColor green];
        int b = [foreColor blue];
        int a = [foreColor alpha];
        NSDictionary *dictionary = @{@"r":@(r),
                                     @"g":@(g),
                                     @"b":@(b),
                                     @"a":@(a)};
        resolve(dictionary);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getForeColor expection",nil);
    }
}

/**
 * 返回文本是否采用斜体，true 表示采用斜体
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getItalic,getItalic:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bIta = [textStyle getItalic];
        resolve([NSNumber numberWithBool:bIta]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getItalic expection",nil);
    }
}

/**
 * 返回字体倾斜角度，正负度之间，以度为单位，精确到0.1度
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getItalicAngle,getItalicAngle:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        //接口缺失getItalicAngle
        
        resolve([NSNumber numberWithDouble:0.0]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getItalicAngle expection",nil);
    }
}

/**
 * 返回是否以轮廓的方式来显示文本的背景
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getOutline,getOutline:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bOutline = [textStyle getOutline];
        resolve([NSNumber numberWithBool:bOutline]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getOutline expection",nil);
    }
}

/**
 * 返回文本旋转的角度
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getRotation,getRotation:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        double angle = [textStyle getRotation];
        resolve([NSNumber numberWithDouble:angle]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getRotation expection",nil);
    }
}

/**
 * 返回文本是否有阴影
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getShadow,getShadow:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bShadow = [textStyle getShadow];
        resolve([NSNumber numberWithBool:bShadow]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getShadow expection",nil);
    }
}

/**
 * 返回文本字体是否加删除线
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getStrikeout,getStrikeout:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bStrikeout = [textStyle getStrikeout];
        resolve([NSNumber numberWithBool:bStrikeout]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getStrikeout expection",nil);
    }
}

/**
 * 返回文本字体是否加下划线
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getUnderline,getUnderline:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bUnderline = [textStyle getUnderline];
        resolve([NSNumber numberWithBool:bUnderline]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getUnderline expection",nil);
    }
}

/**
 * 返回文本字体的磅数，表示粗体的具体数值
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(getWeight,getWeight:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        int nWeight = [textStyle getWeight];
        resolve([NSNumber numberWithInt:nWeight]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"getWeight expection",nil);
    }
}

/**
 * 返回注记背景是否透明
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(isBackOpaque,isBackOpaque:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bBackOpaque = [textStyle isBackOpaque];
        resolve([NSNumber numberWithBool:bBackOpaque]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"isBackOpaque expection",nil);
    }
}

/**
 * 返回注记是否为粗体字
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(isBold,isBold:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bBold = [textStyle isBold];
        resolve([NSNumber numberWithBool:bBold]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"isBold expection",nil);
    }
}

/**
 * 返回文本大小是否固定
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(isSizeFixed,isSizeFixed:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        BOOL bSizeFixed = [textStyle IsSizeFixed];
        resolve([NSNumber numberWithBool:bSizeFixed]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"isSizeFixed expection",nil);
    }
}


/**
 * 设置文本对齐方式
 * @param textStyleId
 * @param textAlignmentValue
 * @param promise
 */
RCT_REMAP_METHOD(setAlignment,setAlignment:(NSString*)textStyleId alignment:(int)textAlignment resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setAlignment:textAlignment];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setAlignment expection",nil);
    }
}

/**
 * 设置文本背景是否不透明，true 表示文本背景不透明
 * @param textStyleId
 * @param backOpaque
 * @param promise
 */
RCT_REMAP_METHOD(setBackOpaque,setBackOpaque:(NSString*)textStyleId opaque:(BOOL)backOpaque resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
     @try {
         TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
         [textStyle setBackOpaque:backOpaque];
         resolve([NSNumber numberWithBool:YES]);
     } @catch (NSException *exception) {
         reject(@"JSTextStyle",@"setBackOpaque expection",nil);
     }
}

/**
 * 设置背景透明度
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setBackTransparency,setBackTransparency:(NSString*)textStyleId transparency:(int)backTans resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
     @try {
         TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
         //接口缺失setBackTransparency
         resolve([NSNumber numberWithBool:YES]);
     } @catch (NSException *exception) {
         reject(@"JSTextStyle",@"setBackTransparency expection",nil);
     }
}
/**
  * 设置文本是否为粗体字，true 表示为粗
  * @param textStyleId
  * @param isBold
  * @param promise
 */
RCT_REMAP_METHOD(setBold,setBold:(NSString*)textStyleId blod:(BOOL)bBlod resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
     @try {
         TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
         [textStyle setBold:bBlod];
         resolve([NSNumber numberWithBool:YES]);
     } @catch (NSException *exception) {
         reject(@"JSTextStyle",@"setBold expection",nil);
     }
}
/**
 * 设置文本字体的高度
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setFontHeight,setFontHeight:(NSString*)textStyleId height:(double)dFontHeight resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setFontHeight:dFontHeight];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setFontHeight expection",nil);
    }
}
/**
 * 设置文本字体的名称
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setFontName,setFontName:(NSString*)textStyleId name:(NSString*)strName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setFontName:strName];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setFontHeight expection",nil);
    }
}

/**
 * 设置注记字体的缩放比例
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setFontScale,setFontScale:(NSString*)textStyleId scale:(double)dScale resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setFontScale:dScale];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setFontScale expection",nil);
    }
}

/**
 * 设置文本的宽度
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setFontWidth,setFontWidth:(NSString*)textStyleId width:(double)dFontWidth resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setFontWidth:dFontWidth];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setFontWidth expection",nil);
    }
}

/**
 * 设置文本的前景色
 * @param textStyleId
 * @param r
 * @param g
 * @param b
 * @param a
 * @param promise
 */
RCT_REMAP_METHOD(setForeColor,setForeColor:(NSString*)textStyleId r:(int)r g:(int)g b:(int)b a:(int)a resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        Color *color = [[Color alloc] initWithR:r G:g B:b A:a];
        [textStyle setForeColor:color];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setForeColor expection",nil);
    }
}

/**
 * 设置文本的背景色
 * @param textStyleId
 * @param r
 * @param g
 * @param b
 * @param a
 * @param promise
 */
RCT_REMAP_METHOD(setBackColor,setBackColor:(NSString*)textStyleId r:(int)r g:(int)g b:(int)b a:(int)a resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        Color *color = [[Color alloc] initWithR:r G:g B:b A:a];
        [textStyle setBackColor:color];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setBackColor expection",nil);
    }
}

/**
 * 设置文本是否采用斜体，true 表示采用斜体
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setItalic,setItalic:(NSString*)textStyleId italic:(BOOL)bItalic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setItalic:bItalic];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setItalic expection",nil);
    }
}
/**
 * 设置字体倾斜角度，正负度之间，以度为单位，精确到0.1度
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setItalicAngle,setItalicAngle:(NSString*)textStyleId angle:(double)italicAngle resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        //接口缺失setItalicAngle
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setItalicAngle expection",nil);
    }
}
/**
 * 设置是否以轮廓的方式来显示文本的背景
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setOutline,setOutline:(NSString*)textStyleId outline:(BOOL)bOutline resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setOutline:bOutline];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setOutline expection",nil);
    }
}
/**
 * 设置文本旋转的角度
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setRotation,setRotation:(NSString*)textStyleId angle:(double)dRotationAngle resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setRotation:dRotationAngle];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setRotation expection",nil);
    }
}
/**
 * 设置文本是否有阴影
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setShadow,setShadow:(NSString*)textStyleId shadow:(BOOL)bShadow resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setShadow:bShadow];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setShadow expection",nil);
    }
}
/**
 * 设置文本大小是否固定
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setSizeFixed,setSizeFixed:(NSString*)textStyleId sizeFixed:(BOOL)bSizeFixed resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setIsSizeFixed:bSizeFixed];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setSizeFixed expection",nil);
    }
}
/**
 * 设置文本字体是否加删除线
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setStrikeout,setStrikeout:(NSString*)textStyleId strikeout:(BOOL)bStrikeout resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setStrikeout:bStrikeout];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setStrikeout expection",nil);
    }
}
/**
 * 设置文本字体是否加下划线
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setUnderline,setUnderline:(NSString*)textStyleId underline:(BOOL)bUnderline resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setUnderline:bUnderline];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setUnderline expection",nil);
    }
}
/**
 * 设置文本字体的磅数，表示粗体的具体数值
 * @param textStyleId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setWeight,setWeight:(NSString*)textStyleId weight:(int)nFontWeight resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        [textStyle setWeight:nFontWeight];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"setWeight expection",nil);
    }
}
/**
 * 返回一个表示此文本风格类对象的格式化字符串
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(toString,toString:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextStyle* textStyle = [JSObjManager getObjWithKey:textStyleId];
        NSString *str = [textStyle toString];
        resolve(str);
    } @catch (NSException *exception) {
        reject(@"JSTextStyle",@"toString expection",nil);
    }
}


@end
