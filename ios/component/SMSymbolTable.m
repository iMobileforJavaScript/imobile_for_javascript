//
//  SMSymbolTable.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/13.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SMSymbolTable.h"

#import <React/RCTConvert.h>
static SymbolLibLegend* symbolLibLegend = nil;

@interface SymbolLibLegend(ReactCategory)

@property (nonatomic, copy) RCTBubblingEventBlock onSymbolClick;
@end

@implementation SymbolLibLegend (ReactCategory)

-(void)setOnSymbolClick:(RCTBubblingEventBlock)onSymbolClick{
    id property = objc_getAssociatedObject(self, @selector(onSymbolClick));
    
    if (property == nil) {
        objc_setAssociatedObject(self, @selector(onSymbolClick), onSymbolClick, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
//    if(self.onSymbolClick)
//    {
//        self.onSymbolClick(@{@"mapViewId":@((NSUInteger)self).stringValue});
//    }
}
-(RCTBubblingEventBlock)onSymbolClick{
    return (RCTBubblingEventBlock)objc_getAssociatedObject(self, @selector(onSymbolClick));
}
@end

@implementation SMSymbolTable
RCT_EXPORT_MODULE(RCTSymbolTable)
RCT_CUSTOM_VIEW_PROPERTY(data, NSArray, SymbolLibLegend) {
    [view showSymbols:[self findSymbolsByIDs:[RCTConvert NSArray:json]]];
}
RCT_CUSTOM_VIEW_PROPERTY(tableStyle, NSDictionary, SymbolLibLegend) {
    [self setStyle:[RCTConvert NSDictionary:json] view:view];
}
RCT_EXPORT_VIEW_PROPERTY(onSymbolClick, RCTBubblingEventBlock)

- (UIView *)view
{
    symbolLibLegend = [[SymbolLibLegend alloc] init];
    symbolLibLegend.delegate = self;
    return symbolLibLegend;
}

-(void)onSymbolClick:(Symbol*)symbol{
    NSString* type = @"";
    switch (symbol.getType) {
        case 0:
            type = @"marker";
            break;
        case 1:
            type = @"line";
            break;
        case 2:
            type = @"fill";
            break;
            
        default:
            break;
    }
    symbolLibLegend.onSymbolClick(@{
                                       @"id": @(symbol.getID),
                                       @"name": symbol.getName,
                                       @"type": type,
                                       });
    //    symbolLibLegend.onSymbolClick(@{@"mapViewId":@((NSUInteger)self).stringValue});
}

- (NSArray *)findSymbolsByIDs:(NSArray *)arr {
//    NSArray* symbols = [SMSymbol findSymbolsByIDs:[SMap singletonInstance].smMapWC.workspace.resources type:nil IDs:arr];
    NSArray* symbols = [SMSymbol findSymbolsByIDs:[SMap singletonInstance].smMapWC.workspace.resources symbolObjs:arr];
    return symbols;
}

- (void)setStyle:(NSDictionary *)style view:(SymbolLibLegend *)view {
    if ([style objectForKey:@"orientation"]) {
        
        view.isScrollDirectionVertical = [(NSNumber *)[style objectForKey:@"orientation"] intValue];
    }
    if ([style objectForKey:@"height"] || [style objectForKey:@"width"]) {
        view.frame = CGRectMake(0, 0, [(NSNumber *)[style objectForKey:@"width"] doubleValue], [(NSNumber *)[style objectForKey:@"height"] doubleValue]);
    }
    if ([style objectForKey:@"lineSpacing"] >= 0) {
        view.itemLineSpacing = [(NSNumber *)[style objectForKey:@"lineSpacing"] doubleValue];
    } else {
        view.itemLineSpacing = 10;
    }
    if ([style objectForKey:@"cellSpacing"] >= 0) {
        view.itemInteritemSpacing = [(NSNumber *)[style objectForKey:@"cellSpacing"] doubleValue];
    }
    if ([style objectForKey:@"count"] > 0) {
        view.itemCountPerLine = [(NSNumber *)[style objectForKey:@"count"] intValue];
    }
    if ([style objectForKey:@"imageSize"] >= 0) {
        view.imageSize = [(NSNumber *)[style objectForKey:@"imageSize"] doubleValue];
    }
    if ([style objectForKey:@"textSize"] >= 0) {
        view.textSize = [(NSNumber *)[style objectForKey:@"textSize"] doubleValue];
    }
    if ([style objectForKey:@"textColor"]) {
        NSDictionary* textColor = [style objectForKey:@"textColor"];
        CGFloat r = [(NSNumber *)[textColor objectForKey:@"r"] doubleValue];
        CGFloat g = [(NSNumber *)[textColor objectForKey:@"g"] doubleValue];
        CGFloat b = [(NSNumber *)[textColor objectForKey:@"b"] doubleValue];
        CGFloat a = [(NSNumber *)[textColor objectForKey:@"a"] doubleValue];
        view.textColor = [[Color alloc] initWithR:r G:g B:b A:(a >= 0 ? a * 255 : 255)];
    }
    if ([style objectForKey:@"legendBackgroundColor"]) {
        NSDictionary* legendBackgroundColor = [style objectForKey:@"legendBackgroundColor"];
        CGFloat r = [(NSNumber *)[legendBackgroundColor objectForKey:@"r"] doubleValue];
        CGFloat g = [(NSNumber *)[legendBackgroundColor objectForKey:@"g"] doubleValue];
        CGFloat b = [(NSNumber *)[legendBackgroundColor objectForKey:@"b"] doubleValue];
        CGFloat a = [(NSNumber *)[legendBackgroundColor objectForKey:@"a"] doubleValue];
        view.legendBackgroundColor = [[Color alloc] initWithR:r G:g B:b A:(a >= 0 ? a * 255 : 255)];
    }
    [view reloadLegend];
//    return symbols;
}

@end
