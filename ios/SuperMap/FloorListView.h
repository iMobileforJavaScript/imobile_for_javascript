//
//  FloorListView.h
//  Transportion3D
//
//  Created by imobile-xzy on 16/8/24.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapControl,Datasource;
@protocol IndoorMapChangedDelegate;

@interface FloorListView : UIView
@property(nonatomic)id<IndoorMapChangedDelegate>delegate;
@property(nonatomic,strong)NSString* currentFloorId;

//加载
-(void)linkMapControl:(MapControl*)mapControl;
-(void)dispose;
-(Datasource*)getIndoorDatasource;
-(void)reload;
@end

@protocol IndoorMapChangedDelegate <NSObject>

-(void)openMap:(NSString*)mapName datasource:(Datasource*)datasource;
-(void)closeMap;
-(void)floorChange:(NSString*)name floorID:(NSString*)floorId;
@end