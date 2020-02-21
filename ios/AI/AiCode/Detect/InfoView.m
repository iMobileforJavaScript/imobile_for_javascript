//
//  InfoView.m
//  SuperMapAITest
//
//  Created by zhouyuming on 2019/11/20.
//  Copyright © 2019年 supermap. All rights reserved.
//

#import "InfoView.h"
#import "AIRecognition.h"

#define HORIZ_SWIPE_DRAG_MIN  4    //水平滑动最小间距
#define VERT_SWIPE_DRAG_MAX    4    //垂直方向最大偏移量

@interface InfoView()
{
   //NSArray* m_colors;
   // NSMutableDictionary* m_lable_color;
}

@end

@implementation InfoView


-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
//        m_lable_color = [[NSMutableDictionary alloc] initWithCapacity:11];
//        NSMutableArray* array=[[NSMutableArray alloc] init];
////        [array addObject:[UIColor grayColor]];
//        [array addObject:[UIColor redColor]];
//        [array addObject:[UIColor greenColor]];
//        [array addObject:[UIColor blueColor]];
//        [array addObject:[UIColor cyanColor]];
//        [array addObject:[UIColor yellowColor]];
//        [array addObject:[UIColor magentaColor]];
//        [array addObject:[UIColor orangeColor]];
//        [array addObject:[UIColor purpleColor]];
//        [array addObject:[UIColor brownColor]];
//        [array addObject:[[UIColor alloc]initWithRed:224/255.0 green:207/255.0 blue:226/255.0 alpha:1]];
//        [array addObject:[[UIColor alloc]initWithRed:151/255.0 green:191/255.0 blue:242/255.0 alpha:1]];
//        [array addObject:[[UIColor alloc]initWithRed:174/255.0 green:241/255.0 blue:176/255.0 alpha:1]];
////        [fillColors addObject:[[Color alloc] initWithR:224 G:207 B:226]];
////        [fillColors addObject:[[Color alloc] initWithR:151 G:191 B:242]];
////        [fillColors addObject:[[Color alloc] initWithR:242 G:242 B:186]];
////        [fillColors addObject:[[Color alloc] initWithR:190 G:255 B:232]];
////        [fillColors addObject:[[Color alloc] initWithR:255 G:190 B:232]];
////        [fillColors addObject:[[Color alloc] initWithR:255 G:190 B:190]];
////        [fillColors addObject:[[Color alloc] initWithR:255 G:235 B:175]];
////        [fillColors addObject:[[Color alloc] initWithR:233 G:255 B:190]];
////        [fillColors addObject:[[Color alloc] initWithR:234 G:225 B:168]];
////        [fillColors addObject:[[Color alloc] initWithR:174 G:241 B:176]];
////        [array addObject:[UIColor blackColor]];
//        m_colors = [[NSArray alloc]initWithArray:array];
        _aIDetectStyle = [[AIDetectStyle alloc]init];
        _aIDetectStyle.aiStrokeWidth = 2;
        _aIDetectStyle.isSameColor = false;
        _aIDetectStyle.isDrawConfidence = true;
        _aIDetectStyle.isDrawTitle = true;
        _misPolymerize=NO;
        _misPolyWithRect=true;
        _mPolyColorArray=[[NSMutableArray alloc] init];
        [_mPolyColorArray addObject:[self colorWithHexString:@"#90EE90"]];
        [_mPolyColorArray addObject:[self colorWithHexString:@"#FFD700"]];
        [_mPolyColorArray addObject:[self colorWithHexString:@"#FF4500"]];
        [_mPolyColorArray addObject:[self colorWithHexString:@"#DC143C"]];
        _thresholdx=-1;
        _thresholdy=-1;
    }
    return self;
}
-(void)refresh{
//    [self setNeedsDisplay];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

-(void)drawRect:(CGRect)rx//UIView绘制入口，系统回调
{
    if(_clickAIRecognition){
        [self.aIRecognitionArray removeAllObjects];
        [self.aIRecognitionArray addObject:_clickAIRecognition];
    }
    UIColor* color=nil;
    
    // 获得上下文
    CGContextRef context =UIGraphicsGetCurrentContext();
    //清空所有rect对象
    self.aIRectArr=[[NSMutableArray alloc] init];
    [self.aIRectArr removeAllObjects];
    
    
    float xSize = rx.size.width;
    float xOffset = 0;
    float ySize = rx.size.height;
    float yOffset = 0;
    float scalex = xSize/self.sizeCamera.width;
    float scaley = ySize/self.sizeCamera.height;
    if (scalex>scaley) {
        ySize = scalex * self.sizeCamera.height;
        yOffset = 0.5*(rx.size.height - ySize);
    }else{
        xSize = scaley * self.sizeCamera.width;
        xOffset = 0.5*(rx.size.width - xSize);
    }
    if(![self isPolymerize]){
        for(int i=0;i<self.aIRecognitionArray.count;i++){
            AIRecognition* recognition=[self.aIRecognitionArray objectAtIndex:i];
            
            //CGRect rx = self.bounds;
            CGRect tempCGRect=CGRectMake(recognition.rect.origin.x*xSize+xOffset,
                                         recognition.rect.origin.y*ySize+yOffset,
                                         recognition.rect.size.width*xSize,
                                         recognition.rect.size.height*ySize);
            if(tempCGRect.origin.x<0){
                tempCGRect.origin.x=2;
                tempCGRect.size.width=tempCGRect.size.width-(2-tempCGRect.origin.x);
            }
            if(tempCGRect.origin.y<0){
                tempCGRect.origin.y=2;
                tempCGRect.size.height=tempCGRect.size.height-(2-tempCGRect.origin.y);
            }

            if(tempCGRect.origin.x+tempCGRect.size.width>rx.size.width){
                tempCGRect.size.width=tempCGRect.size.width-(tempCGRect.origin.x+tempCGRect.size.width-rx.size.width);
            }
            if(tempCGRect.origin.y+tempCGRect.size.height>rx.size.height){
                tempCGRect.size.height=tempCGRect.size.height-(tempCGRect.origin.y+tempCGRect.size.height-rx.size.height);
            }

            [self.aIRectArr addObject:[NSValue valueWithCGRect:tempCGRect]];
    //        NSValue* value;
    //        value.CGRectValue
            //设置识别框颜色
            if(_aIDetectStyle&&_aIDetectStyle.isSameColor ){
                if(_aIDetectStyle.aiColor){
                    color=_aIDetectStyle.aiColor;
                }else{
                    color=[UIColor redColor];
                }
            }else{
    //            if(m_lable_color[recognition.label] == nil){
    //                int n = arc4random() % m_colors.count;
    //                m_lable_color[recognition.label] = m_colors[n];
    //            }
    //            color = m_lable_color[recognition.label];
                color = recognition.displayColor;
            }
            
            
            // 设置绘制颜色
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            //设置线条样式
            CGContextSetLineCap(context, kCGLineCapSquare);
            //设置线条粗细宽度
            CGContextSetLineWidth(context, _aIDetectStyle.aiStrokeWidth);
            //开始一个起始路径
            CGContextBeginPath(context);
            //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
            CGContextMoveToPoint(context, tempCGRect.origin.x, tempCGRect.origin.y);
            //设置下一个坐标点
            CGContextAddLineToPoint(context, tempCGRect.origin.x+tempCGRect.size.width, tempCGRect.origin.y);
            //设置下一个坐标点
            CGContextAddLineToPoint(context, tempCGRect.origin.x+tempCGRect.size.width, tempCGRect.origin.y+tempCGRect.size.height);
            //设置下一个坐标点
            CGContextAddLineToPoint(context, tempCGRect.origin.x, tempCGRect.origin.y+tempCGRect.size.height);
            CGContextAddLineToPoint(context, tempCGRect.origin.x, tempCGRect.origin.y);
            //连接上面定义的坐标点
            CGContextStrokePath(context);


            // 绘制文字
            NSString* content=@"";
            if(_aIDetectStyle&&_aIDetectStyle.isDrawTitle){
                content=[content stringByAppendingString:recognition.label];
    //            [recognition.label stringByAppendingFormat:@"%.2f",recognition.confidence*100];
            }
            //绘制可信度
            if(_aIDetectStyle&&_aIDetectStyle.isDrawConfidence){
                content=[content stringByAppendingFormat:@" %.2f",recognition.confidence*100];
                content=[content stringByAppendingString:@"%"];
            }
            //文本属性
            NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
            //字体名称和大小
            [textAttributes setValue:[UIFont systemFontOfSize:20.0] forKey:NSFontAttributeName];
            
            UIColor* backgroundColor=[UIColor colorWithRed:CGColorGetComponents(color.CGColor)[0] green:CGColorGetComponents(color.CGColor)[1] blue:CGColorGetComponents(color.CGColor)[2] alpha:0.5f];
        
            [textAttributes setValue:backgroundColor forKey:NSBackgroundColorAttributeName];
            
            //颜色
            [textAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [content drawAtPoint:tempCGRect.origin withAttributes:textAttributes];
            
            if (_aIDetectStyle&&_aIDetectStyle.isDrawCount) {
                NSString* strCount = [NSString stringWithFormat:@"%d",recognition.count];
                [strCount drawAtPoint:CGPointMake(tempCGRect.origin.x, tempCGRect.origin.y-20) withAttributes:textAttributes];
            }
        }
    }else{
        if(_thresholdx==-1&&_thresholdy==-1){
            [self setmPolymerizeThreshold:rx.size.width withy:rx.size.height];
        }
        NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
        for(int i=0;i<self.aIRecognitionArray.count;i++){
            AIRecognition* recognition=[self.aIRecognitionArray objectAtIndex:i];

            CGRect tempCGRect=CGRectMake(recognition.rect.origin.x*xSize+xOffset,
                                         recognition.rect.origin.y*ySize+yOffset,
                                         recognition.rect.size.width*xSize,
                                         recognition.rect.size.height*ySize);
            if(tempCGRect.origin.x<0){
                tempCGRect.origin.x=2;
                tempCGRect.size.width=tempCGRect.size.width-(2-tempCGRect.origin.x);
            }
            if(tempCGRect.origin.y<0){
                tempCGRect.origin.y=2;
                tempCGRect.size.height=tempCGRect.size.height-(2-tempCGRect.origin.y);
            }
            
            if(tempCGRect.origin.x+tempCGRect.size.width>rx.size.width){
                tempCGRect.size.width=tempCGRect.size.width-(tempCGRect.origin.x+tempCGRect.size.width-rx.size.width);
            }
            if(tempCGRect.origin.y+tempCGRect.size.height>rx.size.height){
                tempCGRect.size.height=tempCGRect.size.height-(tempCGRect.origin.y+tempCGRect.size.height-rx.size.height);
            }
            
            [self.aIRectArr addObject:[NSValue valueWithCGRect:tempCGRect]];
            if(_aIDetectStyle&&_aIDetectStyle.isSameColor ){
                if(_aIDetectStyle.aiColor){
                    color=_aIDetectStyle.aiColor;
                }else{
                    color=[UIColor redColor];
                }
            }else{
                color = recognition.displayColor;
            }
            if(_misPolyWithRect){
                // 设置绘制颜色
                CGContextSetStrokeColorWithColor(context, color.CGColor);
                //设置线条样式
                CGContextSetLineCap(context, kCGLineCapSquare);
                //设置线条粗细宽度
                CGContextSetLineWidth(context, _aIDetectStyle.aiStrokeWidth);
                //开始一个起始路径
                CGContextBeginPath(context);
                //起始点设置为(0,0):注意这是上	下文对应区域中的相对坐标，
                CGContextMoveToPoint(context, tempCGRect.origin.x, tempCGRect.origin.y);
                //设置下一个坐标点
                CGContextAddLineToPoint(context, tempCGRect.origin.x+tempCGRect.size.width, tempCGRect.origin.y);
                //设置下一个坐标点
                CGContextAddLineToPoint(context, tempCGRect.origin.x+tempCGRect.size.width, tempCGRect.origin.y+tempCGRect.size.height);
                //设置下一个坐标点
                CGContextAddLineToPoint(context, tempCGRect.origin.x, tempCGRect.origin.y+tempCGRect.size.height);
                CGContextAddLineToPoint(context, tempCGRect.origin.x, tempCGRect.origin.y);
                //连接上面定义的坐标点
                CGContextStrokePath(context);
            }
            CGPoint centerPoint = CGPointMake(CGRectGetMidX(tempCGRect),CGRectGetMidY(tempCGRect));
            CGPoint pointPos = [self calcPos:centerPoint];
            NSString* key=[NSString stringWithFormat:@"%f_%f",pointPos.x,pointPos.y];
            if(![[dic allKeys] containsObject:key]){
                NSMutableArray* array=[[NSMutableArray alloc] init];
                [array addObject:[NSValue valueWithCGRect:tempCGRect]];
                [dic setValue:array forKey:key];
            }else{
                NSMutableArray* array=[dic objectForKey:key];
                [array addObject:[NSValue valueWithCGRect:tempCGRect]];
            }
            
            //文本属性
            NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
            //字体名称和大小
            [textAttributes setValue:[UIFont systemFontOfSize:20.0] forKey:NSFontAttributeName];
            
            UIColor* backgroundColor=[UIColor colorWithRed:CGColorGetComponents(color.CGColor)[0] green:CGColorGetComponents(color.CGColor)[1] blue:CGColorGetComponents(color.CGColor)[2] alpha:0.5f];
            
            [textAttributes setValue:backgroundColor forKey:NSBackgroundColorAttributeName];
            
            //颜色
            [textAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            
            if (_aIDetectStyle&&_aIDetectStyle.isDrawCount) {
                NSString* strCount = [NSString stringWithFormat:@"%d",recognition.count];
                [strCount drawAtPoint:CGPointMake(tempCGRect.origin.x+tempCGRect.size.width/2-10, tempCGRect.origin.y+tempCGRect.size.height/2-10) withAttributes:textAttributes];
            }
        }
        {
            UIColor* color;
            for(NSMutableArray* array in [dic allValues]){
                int count=array.count;
                if(count>0 && count<=3){
                    color=[_mPolyColorArray objectAtIndex:0];
                }else if(count>=4 && count<=6){
                    color=[_mPolyColorArray objectAtIndex:1];
                }else if(count>=7 && count<=9){
                    color=[_mPolyColorArray objectAtIndex:2];
                }else if(count>10){
                    color=[_mPolyColorArray objectAtIndex:3];
                }
                [color colorWithAlphaComponent:0.3];
                
                CGRect rect=[self rectMerge:array];
                
                CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.0);
                
                CGContextAddRect(context, rect);
                CGContextSetFillColorWithColor(context, color.CGColor);
                CGContextDrawPath(context, kCGPathFillStroke);
                
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    // 初始化起始点和结束点
    self.startPoint = [touch locationInView:self];
    [self touchPoint:self.startPoint];
}

-(AIRecognition*)touchPoint:(CGPoint)touchPoint{
    if([self isPolymerize]){
        return nil;
    }
    if(!self.aIRectArr||[self.aIRectArr count]==0){
        return nil;
    }
    CGRect touchCGRect;
    int index=-1;
    for(int i=0;i<[self.aIRectArr count];i++){
        NSValue* tempValue=[self.aIRectArr objectAtIndex:i];
        CGRect tempCGRect=tempValue.CGRectValue;
        if(CGRectContainsPoint(tempCGRect,touchPoint)){
            //筛选面积最小的
            if(index==-1||touchCGRect.size.height*touchCGRect.size.height>tempCGRect.size.height*tempCGRect.size.height){
                touchCGRect=tempCGRect;
                index=i;
            }
        }
    }
    if(index!=-1&&index<[self.aIRectArr count]){
        AIRecognition *aIRecognition=[self.aIRecognitionArray objectAtIndex:index];
       
        _clickAIRecognition=aIRecognition;
        [self setNeedsDisplay];
        
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             self.callBackBlock(aIRecognition);
        });
        
        return aIRecognition;
    }
    
    return nil;
}

-(void)setIsPolymerize:(BOOL)value{
    _misPolymerize=value;
}
-(BOOL)isPolymerize{
    return _misPolymerize;
}
-(void)setmPolymerizeThreshold:(int)thresholdx withy:(int)thresholdy{
    _thresholdx=thresholdx;
    _thresholdy=thresholdy;
}
-(CGPoint)calcPos:(CGPoint)point{
    int x=point.x/_thresholdx;
    int y=point.y/_thresholdy;
    CGPoint resultPoint=CGPointMake(x, y);
    return resultPoint;
}

-(CGRect)rectMerge:(NSArray*) rectArray{
    NSValue *tempValue = [rectArray objectAtIndex:0];
    CGRect rect=tempValue.CGRectValue;
    float left = rect.origin.x;
    float top = rect.origin.y;
    float right = rect.origin.x+rect.size.width;
    float bottom = rect.origin.y+rect.size.height;
    int count=[rectArray count];
    for (int i=1; i<count; i++) {
        NSValue *tempValue = [rectArray objectAtIndex:i];
        CGRect rectTemp=tempValue.CGRectValue;
        if(rectTemp.origin.x<left) left=rectTemp.origin.x;
        if(rectTemp.origin.y<top) top=rectTemp.origin.y;
        if(rectTemp.origin.x+rectTemp.size.width>right) right=rectTemp.origin.x+rectTemp.size.width;
        if(rectTemp.origin.y+rectTemp.size.height>bottom) bottom=rectTemp.origin.y+rectTemp.size.height;
    }
    return CGRectMake(left,top,right-left,bottom-top);
    
}

- (UIColor *) colorWithHexString: (NSString *)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //hexString应该6到8个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    //如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    //RGB转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:0.3f];
}

@end
