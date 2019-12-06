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
    NSArray* m_colors;
    NSMutableDictionary* m_lable_color;
}

@end

@implementation InfoView


-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        m_lable_color = [[NSMutableDictionary alloc] initWithCapacity:11];
        NSMutableArray* array=[[NSMutableArray alloc] init];
        [array addObject:[UIColor grayColor]];
        [array addObject:[UIColor redColor]];
        [array addObject:[UIColor greenColor]];
        [array addObject:[UIColor blueColor]];
        [array addObject:[UIColor cyanColor]];
        [array addObject:[UIColor yellowColor]];
        [array addObject:[UIColor magentaColor]];
        [array addObject:[UIColor orangeColor]];
        [array addObject:[UIColor purpleColor]];
        [array addObject:[UIColor brownColor]];
        [array addObject:[UIColor blackColor]];
        m_colors = [[NSArray alloc]initWithArray:array];
        _aIDetectStyle = [[AIDetectStyle alloc]init];
        _aIDetectStyle.aiStrokeWidth = 2;
        _aIDetectStyle.isSameColor = false;
        _aIDetectStyle.isDrawConfidence = true;
        _aIDetectStyle.isDrawTitle = true;
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
        if(_aIDetectStyle&&_aIDetectStyle.isSameColor && _aIDetectStyle.aiColor!=nil){
            if(_aIDetectStyle.aiColor){
                color=_aIDetectStyle.aiColor;
            }
        }else{
            if(m_lable_color[recognition.label] == nil){
                int n = arc4random() % m_colors.count;
                m_lable_color[recognition.label] = m_colors[n];
            }
            color = m_lable_color[recognition.label];
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
            content=[content stringByAppendingFormat:@"%.2f",recognition.confidence*100];
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

    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    // 初始化起始点和结束点
    self.startPoint = [touch locationInView:self];
    [self touchPoint:self.startPoint];
}

-(AIRecognition*)touchPoint:(CGPoint)touchPoint{
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
//     NSLog(@"++ touch %@",@"2");
    if(index!=-1&&index<[self.aIRectArr count]){
//         NSLog(@"++ touch %@",@"3");
        AIRecognition *aIRecognition=[self.aIRecognitionArray objectAtIndex:index];
        self.callBackBlock(aIRecognition);
        return [self.aIRecognitionArray objectAtIndex:index];
    }
    
    return nil;
}

@end
