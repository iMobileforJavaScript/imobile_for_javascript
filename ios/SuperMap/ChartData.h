//
//  ChartData.h
//  HotMap
//
//  Created by imobile-xzy on 16/12/29.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartData : NSObject

-(id)initWith:(NSString*)lable color:(UIColor*)color ID:(int)geoId;
//分块颜色，
@property(nonatomic,strong)UIColor* color;
//关联地图 对应几何对象
@property(nonatomic)int geoId;
//每个条目名称
@property(nonatomic)NSString* lable;

@end


//饼图数据
@interface ChartPieData : ChartData

//value:数据类型为 NSNumber类型，否则为无效数据
-(id)initWithItemName:(NSString*)itemName value:(NSArray*)value color:(UIColor*)color ID:(int)geoId;
//条目数值
@property(nonatomic)double value;
@end

//折线图数据
@interface ChartLineData : ChartData

//value:数据类型为 NSNumber类型，否则为无效数据
-(id)initWithItemName:(NSString*)itemName value:(NSArray*)value color:(UIColor*)color ID:(int)geoId;
//折线数据，数据类型为 NSNumber类型，否则为无效数据
@property(nonatomic,strong)NSMutableArray* values;
//线宽
@property(nonatomic)float lineWitdh;
//折线点颜色
@property(nonatomic,strong)UIColor* nodeColor;
//点大小
@property(nonatomic)float nodeRadious;
@end



//柱状图数据
@interface ChartBarData : ChartData

//折线数据，数据类型为 ChartBarDataItem类型，否则为无效数据
@property(nonatomic,strong)NSMutableArray* values;
//value: 数据类型为 ChartBarDataItem
-(id)initWithItemName:(NSString*)itemName values:(NSArray*)values;
@end

@interface ChartBarDataItem : NSObject

@property(nonatomic,strong)NSNumber* value;
//关联地图 对应几何对象
@property(nonatomic)int geoId;
//每个条目名称
@property(nonatomic)NSString* lable;

@property(nonatomic)UIColor* color;

-(id)initWithValue:(NSNumber*)value color:(UIColor*)color lable:(NSString*)lable ID:(int)geoId;
@end
