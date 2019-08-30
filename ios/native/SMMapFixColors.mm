//
//  SMMapFixColors.m
//  Supermap
//
//  Created by wnmng on 2019/8/29.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMMapFixColors.h"

@interface SMMapFixColors(){
    int _parame[12];
//    //Brightness
//    int _LB ;
//    int _FB ;
//    int _BB ;
//    int _TB ;
//    //Contrast
//    int _LC ;
//    int _FC ;
//    int _BC ;
//    int _TC ;
//    //Saturation
//    int _LS ;
//    int _FS ;
//    int _BS ;
//    int _TS ;
}

@end

@implementation SMMapFixColors

//由Objective-C的一些特性可以知道，在对象创建的时候，无论是alloc还是new，都会调用到 allocWithZone方法。
+(id)allocWithZone:(struct _NSZone *)zone{
    return [SMMapFixColors sharedInstance];
}
// 在通过拷贝的时候创建对象时，会调用到-(id)copyWithZone:(NSZone *)zone，-(id)mutableCopyWithZone:(NSZone *)zone方法
-(id)copyWithZone:(NSZone *)zone{
    return [SMMapFixColors sharedInstance];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [SMMapFixColors sharedInstance];
}

// 串行队列的创建方法
//static dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
+(id)sharedInstance{
    // 为了隔离外部修改，放在方法内部，在设置成静态变量
    static id smMapFixColorsInstance = nil;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        if(smMapFixColorsInstance ==  nil){
            //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
            //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
            smMapFixColorsInstance =  [[super allocWithZone:nil] init] ;
            [smMapFixColorsInstance onCreate];
            
        }
    });
    return (SMMapFixColors*)smMapFixColorsInstance;
}

-(void)onCreate{
    for (int i=0; i<12; i++) {
        _parame[i] = 0;
    }
    
//    //Brightness
//    _LB =0  ;
//    _FB =0  ;
//    _BB =0  ;
//    _TB =0  ;
//    //Contrast
//    _LC =0  ;
//    _FC =0  ;
//    _BC =0  ;
//    _TC =0  ;
//    //Saturation
//    _LS =0  ;
//    _FS =0  ;
//    _BS =0  ;
//    _TS =0  ;
}

-(int)getMapFixColorModeValue:(FixColorsMode)mode{
   return  _parame[mode];
}

-(void)updatMapFixColorsMode:(FixColorsMode)mode value:(int)value{
    
}

@end
