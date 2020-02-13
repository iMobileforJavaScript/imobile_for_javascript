//
//  AICameraFrame.m
//  Supermap
//
//  Created by wnmng on 2020/1/19.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "AIPlateCollectionCameraFrame.h"

@interface AIPlateCollectionCameraFrame(){
    NSString* _carPlate;
    NSString* _carType;
    NSString* _carColor;
    UIButton* _submitBnt;
}

@end

@implementation AIPlateCollectionCameraFrame

#define CameraFrame_Edge 0.1
#define CameraFrame_Height 0.75



-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIColor *fillColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.5];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int width = rect.size.width;
    int height = rect.size.height;
    CGContextSetLineWidth(context, 0);
    CGContextAddRect(context, CGRectMake(0, 0, width*CameraFrame_Edge, height));
    CGContextAddRect(context, CGRectMake(width*(1-CameraFrame_Edge), 0, width*CameraFrame_Edge, height));
    CGContextAddRect(context, CGRectMake(width*CameraFrame_Edge, 0, width*(1-CameraFrame_Edge*2), height*CameraFrame_Edge));
    CGContextAddRect(context, CGRectMake(width*CameraFrame_Edge, height*CameraFrame_Height, width*(1-CameraFrame_Edge*2), height*(1-CameraFrame_Height)));
        //填充
    //CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
        //绘制路径及填充模式
    CGContextDrawPath(context, kCGPathFillStroke);
    
    double nUnit = height * 1.0 * (1-CameraFrame_Height-CameraFrame_Edge) / 12;
    
    NSMutableParagraphStyle * textStyle = [[NSMutableParagraphStyle alloc] init];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;//结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab…yz”)
    textStyle.alignment = NSTextAlignmentLeft;//文本对齐方式：（左，中，右，两端对齐，自然）
    textStyle.lineSpacing = nUnit*0.2; //字体的行间距
    textStyle.headIndent = 0.0; //整体缩进(首行除外)
    textStyle.tailIndent = 0.0; //尾部缩进
    textStyle.minimumLineHeight = nUnit*2; //最低行高
    textStyle.maximumLineHeight = nUnit*2; //最大行高
    textStyle.baseWritingDirection = NSWritingDirectionLeftToRight; //从左到右的书写方向
    textStyle.lineHeightMultiple = 15;
    textStyle.hyphenationFactor = 1; //连字属性 在iOS，唯一支持的值分别为0和1
    //文本属性
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
    //段落样式
    [textAttributes setValue:textStyle forKey:NSParagraphStyleAttributeName];
    //字体名称和大小
    [textAttributes setValue:[UIFont systemFontOfSize:nUnit*2*0.8] forKey:NSFontAttributeName];
    //颜色
    [textAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    //绘制文字
    [_carPlate drawInRect:CGRectMake((width-nUnit*2*8)*0.5, height*(CameraFrame_Height+CameraFrame_Edge*0.3), nUnit*2*12, nUnit*2) withAttributes:textAttributes];
    
    [_carType drawInRect:CGRectMake((width-nUnit*2*8)*0.5, height*(CameraFrame_Height+CameraFrame_Edge*0.3)+nUnit*3, nUnit*2*12, nUnit*2) withAttributes:textAttributes];
    
    [_carColor drawInRect:CGRectMake((width-nUnit*2*8)*0.5, height*(CameraFrame_Height+CameraFrame_Edge*0.3)+nUnit*6, nUnit*2*12, nUnit*2) withAttributes:textAttributes];
    
    if (_submitBnt!=nil) {
        _submitBnt.titleLabel.font = [UIFont systemFontOfSize:nUnit*2*0.8];
        _submitBnt.frame = CGRectMake((width-nUnit*11)*0.5, height*(CameraFrame_Height+CameraFrame_Edge*0.3)+nUnit*10, nUnit*11,nUnit*4 );
    }
}


-(void)collectedPlate:(NSString*)plate carType:(NSString*)carType colorDescription:(NSString*)strColor{
    BOOL canSubmit = true;
    if (plate!=nil) {
        _carPlate = [NSString stringWithFormat:@"车辆号码：%@",plate];
    }else{
        _carPlate = @"车辆号码：正在识别...";
        canSubmit = false;
    }
    
    if (carType!=nil) {
        _carType = [NSString stringWithFormat:@"车辆类型：%@",carType];
    }else{
        _carType = @"车辆类型：正在识别...";
        canSubmit = false;
    }
    
    if(strColor!=nil){
        _carColor = [NSString stringWithFormat:@"车辆颜色：%@",strColor];
    }else{
        _carColor = @"车辆颜色：正在识别...";
        canSubmit = false;
    }
    
    if (_submitBnt!=nil) {
        _submitBnt.enabled = canSubmit;
        if (canSubmit) {
            [_submitBnt setBackgroundColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.7 alpha:0.9]];
        }else{
            [_submitBnt setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9]];
        }
    }
    
    [self setNeedsDisplay];
}

-(UIButton*)submitBnt{
    return _submitBnt;
}

-(void)setSubmitBnt:(UIButton *)submitBnt{
    if (_submitBnt!=nil) {
        [_submitBnt removeFromSuperview];
    }
    _submitBnt=submitBnt;
   
    [self addSubview:_submitBnt];
}

@end
