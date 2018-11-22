//
//  ImageFormatType.h
//  LibUGC
//
//  Created by zyd on 16/7/19.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

/**
 *  网络服务图片格式
 */
typedef NS_ENUM(NSUInteger, ImageFormatType) {
    //  NONE
    ImageFormatTypeNONE        = 0,
    //  PNG
    ImageFormatTypePNG         = 123,
    //  JPG
    ImageFormatTypeJPG         = 122,
    //  GIF
    ImageFormatTypeGIF         = 124,
    //  JPG_PNG
    ImageFormatTypeJPG_PNG     = 147,
    //  DXTZ
    ImageFormatTypeDXTZ        = 126,
    //  BMP
    ImageFormatTypeBMP         = 121,
};
