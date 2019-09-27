//
//  SScene.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/9.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SScene.h"
#import "TouchUtil3D.h"

#import "PoiSearchHelper.h"
#import "LableHelper3D.h"
#import "Constants.h"
#import "SMSceneWC.h"
#import "FlyHelper3D.h"
#import "AnalysisHelper3D.h"
#import "SuperMap/Camera.h"
#import "SuperMap/Feature3Ds.h"
#import "SuperMap/Feature3D.h"

typedef enum{
    /**
     * 空操作
     */
    SS_None_Action = 0x0,
    /**
     * 选择属性
     */
    SS_Feature_Action = 0x1,
    /**
     * 添加飞翔点
     */
    SS_FlyPoint_Action = 0x2,
    
}SSceneAction;

typedef enum{
    /**
     * 自处理操作
     */
    SS_Normal_Event = 0x0,
    /**
     * LableHelper
     */
    SS_Label_Event = 0x1,
    /**
     * AnalysisHelper
     */
    SS_Analysis_Event = 0x2,
    
}SSceneTouchEvent;

@interface SScene()<FlyHelper3DProgressDelegate,Analysis3DDelegate,LableHelper3DDelegate,Tracking3DDelegate,PoiSearchDelegate>
{
    Camera defaultCamera;
    BOOL bHasCamera;
    NSArray* poiInfos;
    OnlinePOIInfo* firstPoint;
    OnlinePOIInfo* secondPoint;
}
@end

static SScene* sScene = nil;
@implementation SScene
RCT_EXPORT_MODULE();


- (NSArray<NSString *> *)supportedEvents
{
    return @[
             ANALYST_MEASURELINE,
             ANALYST_MEASURESQUARE,
             POINTSEARCH_KEYWORDS,
             SSCENE_FLY,
             SSCENE_ATTRIBUTE,
             SSCENE_SYMBOL,
             SSCENE_CIRCLEFLY,
             SSCENE_FAVORITE
             ];
}

+ (instancetype)singletonInstance{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sScene = [[self alloc] init];
        //解决IOS切后台后三维刷新崩溃
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        // app从后台进入前台都会调用这个方法
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        // 添加检测app进入后台的观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    });
    
    return sScene;
}
+ (void)setInstance:(SceneControl *)sceneControl{
    sScene = [SScene singletonInstance];
    if (sScene.smSceneWC == nil) {
        sScene.smSceneWC = [[SMSceneWC alloc] init];
    }
    sScene.smSceneWC.sceneControl = sceneControl;
    if (sScene.smSceneWC.workspace == nil) {
        sScene.smSceneWC.workspace = [[Workspace alloc] init];
    }

    
   
}

+(void)applicationBecomeActive{
    sScene.smSceneWC.sceneControl.isRender = YES;
}
+(void)applicationEnterBackground{
    sScene.smSceneWC.sceneControl.isRender = false;
}
#pragma mark-手势处理

//常驻操作 int的每位代表一个操作
int sSceneAction = SS_None_Action;
//trackingTouch分发
SSceneTouchEvent sSceneEvent = SS_Normal_Event;
const double SMMarkerScale = 1.0;
const double SMOffSet = 28.0;
-(void)singleTap:(CGPoint)tapPoint{
    // 选择属性（有trackingTouch操作时不响应）
    if( sSceneEvent == SS_Normal_Event && (sSceneAction & SS_Feature_Action)){
        [self getSelectedAttribute:tapPoint];
    }
    
}


-(void)doubleTap:(CGPoint)tapPoint{

}

-(void)longPress:(CGPoint)longPressPoint{
    // 长按操作
    if( sSceneEvent == SS_Normal_Event && (sSceneAction & SS_FlyPoint_Action) ){
//        CGFloat scale = [UIScreen mainScreen].scale;
//        CGPoint point = CGPointMake(longPressPoint.x * scale, longPressPoint.y * scale);//  修正底层添加的点和实际不一致
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        Point3D pnt3D = [sceneControl.scene pixelToGlobeWith:point andPixelToGlobeMode:TerrainAndModel];
//        [[LableHelper3D sharedInstance]addCirclePoint:pnt3D];

        [self addCirclePoint:longPressPoint];
        
//        CGFloat scale = [UIScreen mainScreen].scale;
//        if (longPressPoint.x < SMOffSet * SMMarkerScale / scale) return;//    防止修正坐标导致调用pixelToGlobe崩溃
//        CGPoint point = CGPointMake(longPressPoint.x * scale - SMOffSet * SMMarkerScale, longPressPoint.y * scale);//  修正底层添加的点和实际不一致
//
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        //Point3D pnt3D = [sceneControl.scene pixelToGlobe:longPressPoint];
//        Point3D pnt3D = [sceneControl.scene pixelToGlobeWith:point andPixelToGlobeMode:TerrainAndModel];
//        [[LableHelper3D sharedInstance]addCirclePoint:pnt3D];
//
//        [self sendEventWithName:SSCENE_CIRCLEFLY
//                           body:@{@"pointX":@(longPressPoint.x-SMOffSet * SMMarkerScale / scale),@"pointY":@(longPressPoint.y)}];
    }
}


- (void)handleLongPressGestureEvent:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIWindow *si  = [[UIApplication sharedApplication].windows objectAtIndex:0];
        CGPoint longPressPoint = [gesture locationInView:si];
//        [[UIApplication sharedApplication] statusBarOrientation];
//        NSLog(@"+++ %f,%f",longPressPoint.x,longPressPoint.y);
//        CGPoint longPressPoint1;
//        longPressPoint1.x = 200;
//        longPressPoint1.y = 200;
        [self longPress:longPressPoint];
    }
}

//-(void)longPress:(CGPoint)longPressPoint{
//    // 长按操作
//    if( sSceneEvent == SS_Normal_Event && (sSceneAction & SS_FlyPoint_Action) ){
//        CGPoint point = longPressPoint;
//        point.x *= [UIScreen mainScreen].scale;
//        point.y *= [UIScreen mainScreen].scale;
//
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        //Point3D pnt3D = [sceneControl.scene pixelToGlobe:longPressPoint];
//        Point3D pnt3D = [sceneControl.scene pixelToGlobeWith:point andPixelToGlobeMode:TerrainAndModel];
//        [[LableHelper3D sharedInstance]addCirclePoint:pnt3D];
//
//        [self sendEventWithName:SSCENE_CIRCLEFLY
//                           body:@{@"pointX":@(longPressPoint.x),@"pointY":@(longPressPoint.y)}];
//    }
//}

-(void)tracking3DEvent:(Tracking3DEvent *)event{
    switch (sSceneEvent) {
        case SS_Label_Event:
            [[LableHelper3D sharedInstance]tracking3DEvent:event];
            break;
        case SS_Analysis_Event:
            [[AnalysisHelper3D sharedInstance]tracking3DEvent:event];
            break;
        default:
            break;
    }
}

BOOL bTouchBegin = NO;
float dTap_x = 0;
float dTap_y = 0;
#define SSceneTapTolerance 20*20
//float tapTolerance = 30;
NSTimeInterval tapDelaytime = 0.4;
NSTimeInterval longPressDelaytime = 0.8;
//BOOL bSinglePoint = true;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (event.allTouches.count > 1 ) {
        bTouchBegin = NO;
    }else{
        UITouch *touch = [touches anyObject];
        if (touch.tapCount == 1) {
            CGPoint touchPoint = [touch locationInView: self.smSceneWC.sceneControl];
            bTouchBegin = YES;
            dTap_x = touchPoint.x;
            dTap_y = touchPoint.y;
            // 长按开始计时
           // [self performSelector:@selector(longTouch:) withObject:nil afterDelay:longPressDelaytime];
        }
    }

    return;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView: self.smSceneWC.sceneControl];
    float dx = dTap_x-touchPoint.x;
    float dy = dTap_y-touchPoint.y;
    if (bTouchBegin && dx*dx+dy*dy>SSceneTapTolerance) {
        // 移动了就拜拜
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(longPress:) object:nil];
        bTouchBegin = NO;
    }
    
    return;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // 如果已经响应过了就跳过
    if (bTouchBegin) {
        UITouch *touch = [touches anyObject];
        // 长按计时取消
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(longPress:) object:nil];
        if (touch.tapCount == 1) {
            // 单击准备
            [self performSelector:@selector(singleTouch:) withObject:nil afterDelay:tapDelaytime];
        }else{
            UITouch *touch = [touches anyObject];
            CGPoint touchPoint = [touch locationInView: self.smSceneWC.sceneControl];
            float dx = dTap_x-touchPoint.x;
            float dy = dTap_y-touchPoint.y;
            if(touch.tapCount == 2 && dx*dx+dy*dy<=SSceneTapTolerance){
                // 单击取消
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTouch:) object:nil];
                [self doubleTouch:nil];
            }
        }
    }
    
    
    //    if(touches.count > 1)
    //        bSinglePoint = NO;
    //    if(!bSinglePoint){
    //        bSinglePoint = YES;
    //        return;
    //    }
    //    sScene = [SScene singletonInstance];
    //    SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
    //    NSDictionary* info;
    //    [TouchUtil3D getAttribute:sceneControl attribute:&info];
    //    [self sendEventWithName:SSCENE_ATTRIBUTE
    //                       body:info];
    return;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    bTouchBegin = NO;
    return;
}

//-(void)longTouch:(id)sender{
//    if (bTouchBegin) {
//        bTouchBegin = NO;
//        [self longPress:CGPointMake(dTap_x, dTap_y)];
//    }
//}
-(void)singleTouch:(id)sender{
    if (bTouchBegin) {
        bTouchBegin = NO;
        [self singleTap:CGPointMake(dTap_x, dTap_y)];
    }
}
-(void)doubleTouch:(id)sender{
    if (bTouchBegin) {
        bTouchBegin = NO;
        [self doubleTap:CGPointMake(dTap_x, dTap_y)];
    }
}


#pragma mark-初始化+打开场景
RCT_REMAP_METHOD(setListener, setListener:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sScene = [SScene singletonInstance];
        
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        sceneControl.sceneControlDelegate = self;
        sceneControl.tracking3DDelegate = self;
        
//        initLabelHelper();
        NSString* path = sScene.smSceneWC.workspace.connectionInfo.server;
        NSString* result = [path.stringByDeletingLastPathComponent stringByAppendingString:@"/files/"];
        NSString* kmlname = @"newKML.kml";
        
        [[LableHelper3D sharedInstance] initSceneControl:sceneControl path:result kml:kmlname];
        [LableHelper3D sharedInstance].delegate = self;
//        initAnalysisHelper();
        [[AnalysisHelper3D sharedInstance] initializeWithSceneControl:sceneControl];
        [AnalysisHelper3D sharedInstance].delegate = self;
        
        [[PoiSearchHelper sharedInstance] initSceneControl:sceneControl];
        [PoiSearchHelper sharedInstance].delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureEvent:)];
            longPressGesture.minimumPressDuration = longPressDelaytime;
            //        self.longPressGestureDelegate = [[LongPressGestureDelegate alloc] init];
            //        longPressGesture.delegate = self.longPressGestureDelegate;
            [sceneControl addGestureRecognizer:longPressGesture];
            
            sSceneAction |= SS_FlyPoint_Action;
        });
       
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(removeKMLOfWorkcspace,  removeKMLOfWorkcspaceResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
       
        [[LableHelper3D sharedInstance] closePage];
        // [self openGPS];
        resolve([NSNumber numberWithBool:@1]);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getLableAttributeList,  getLableAttributeListResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        Layer3D* layer3D = [scene.layers getLayerWithName:@"NodeAnimation"];
        if(!layer3D){
            resolve([NSNumber numberWithBool:@0]);
        }else{
            Feature3Ds* feature3Ds = layer3D.feature3Ds;
            int count =feature3Ds.count;
            NSArray *array = [feature3Ds allFeature3DObjectsWithOption:Feature3DSearchOptionAllFeatures];
            NSMutableArray* dict = [NSMutableArray array];
            for (int i = 0; i <array.count ; i++) {
                Feature3D* feature3D=  array[i];//[feature3Ds feature3DWithID:i option:Feature3DSearchOptionAllFeatures];
                ;
                //NSString* description = [NSString stringWithFormat:@"x=%.2f, y=%.2f, z=%.2f",feature3D.geometry3D.position.x,feature3D.geometry3D.position.y,feature3D.geometry3D.position.z];
                NSDictionary* map = @{@"description":feature3D.description,@"id":@(feature3D.ID),@"name":feature3D.name};
               
                [dict addObject:map];
            }
            resolve(dict);
        }
       
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

/**
 * 获取设置相关信息
 */
RCT_REMAP_METHOD(getSetting,  getSettingResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        Layer3D* layer3D = [scene.layers getLayerWithName:@"NodeAnimation"];
        NSDictionary* map = @{@"sceneNmae":scene.name,@"heading":@(scene.camera.heading)};
        resolve(map);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}


RCT_REMAP_METHOD(flyToFeatureById,  index:(int)index flyToFeatureByIdResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        Layer3D* layer3D = [scene.layers getLayerWithName:@"NodeAnimation"];
        if(!layer3D){
            resolve([NSNumber numberWithBool:@0]);
        }else{
            Feature3Ds* feature3Ds = layer3D.feature3Ds;
            Feature3D* feature3D=  [feature3Ds feature3DWithID:index option:Feature3DSearchOptionAllFeatures];
          //  Feature3D feature3D= (Feature3D) layer3D.getFeatures().get(id);
            if(feature3D==nil){
                resolve([NSNumber numberWithBool:@0]);
            }else {
                Point3D pnt3d = feature3D.geometry3D.innerPoint3D;
                
                Camera camera= {pnt3d.x,pnt3d.y,pnt3d.z};
                [scene flyToCamera:camera];
                resolve([NSNumber numberWithBool:@1]);
            }
        }
        
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

/**
 * 设置飞行
 *
 * @param promise
 */
RCT_REMAP_METHOD(getWorkspacePath, Position:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        NSString* path = sScene.smSceneWC.workspace.connectionInfo.server;
        resolve(path);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(openWorkspace, openWorkspaceByInfo:(NSDictionary*)infoDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        BOOL result = [sScene.smSceneWC openWorkspace:infoDic];
       // [self openGPS];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}
RCT_REMAP_METHOD(openMap, openMapByName:(NSString*)name  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
     //   Maps* maps = sMap.smMapWC.workspace.maps;
        BOOL bOPen = false;
        sScene.smSceneWC.sceneControl.isRender = NO;
        if (sScene.smSceneWC.workspace.scenes.count  > 0) {
            NSString* mapName = name;
            bOPen = [scene open:mapName];
            if(bOPen){
                sScene.smSceneWC.sceneControl.isRender = YES;
                [scene refresh];
            }
        }
        
        resolve([NSNumber numberWithBool:@(bOPen)]);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
/*
 判断是否3D工作空间
 */
RCT_REMAP_METHOD(is3DWorkspace, is3DWorkspaceByInfo:(NSDictionary*)infoDic  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        if(sScene.smSceneWC==nil){
            sScene.smSceneWC = [[SMSceneWC alloc] init];
        }
        BOOL result = [sScene.smSceneWC is3DWorkspaceInfo:infoDic];
        resolve(@(result));
    }@catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
/*
 从pxp文件打开scence
 */
RCT_REMAP_METHOD(openScence, openScenceByName:(NSString*)name  isPrivate:(BOOL)bPrivate resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        sScene.smSceneWC.sceneControl.isRender = NO;
        BOOL result = [sScene.smSceneWC openScenceName:name toScenceControl:sScene.smSceneWC.sceneControl isPrivate:bPrivate];
        sScene.smSceneWC.sceneControl.isRender = YES;
        [sScene.smSceneWC.sceneControl.scene refresh];
        
        bHasCamera = NO;
        if(result){
            defaultCamera = sScene.smSceneWC.sceneControl.scene.camera;
            bHasCamera = YES;
        }
        resolve(@(result));
    }@catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(resetCamera, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        if(bHasCamera){
            sScene.smSceneWC.sceneControl.scene.camera = defaultCamera;
            resolve(@(1));
           // sScene.smSceneWc.getSceneControl().getScene().setCamera(defaultCamera);
           // promise.resolve(true);
        }else {
             resolve(@(0));
        }
    }@catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/*
 导入3维工作空间成pxp
 */
RCT_REMAP_METHOD(import3DWorkspace, import3DWorkspaceByInfo:(NSDictionary*)infoDic  isPrivate:(BOOL)bPrivate teresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        if(sScene.smSceneWC==nil){
            sScene.smSceneWC = [[SMSceneWC alloc] init];
        }
        BOOL result = [sScene.smSceneWC import3DWorkspaceInfo:infoDic isPrivate:bPrivate];
        resolve(@(result));
    }@catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
/*
 导出pxp到工作空间
 */
RCT_REMAP_METHOD(export3DScenceName, export3DScenceByName:(NSString*)name toFile:(NSString*)strFile resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        BOOL result = [sScene.smSceneWC export3DScenceName:name toFolder:strFile];
        resolve(@(result));
    }@catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
/*
 设置CustomerDirectory
 */
RCT_REMAP_METHOD(setCustomerDirectory, setCustomerDirectory:(NSString*)path  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        [sScene.smSceneWC setCustomerDirectory:path];
        resolve(@(1));
    }@catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 获取场景列表
 *
 * @param promise
 */
RCT_REMAP_METHOD(getMapList, getMapListResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scenes* scenes = sScene.smSceneWC.workspace.scenes;
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        int count = [scenes count];
        
        for (int i = 0; i < count; i++) {
            NSString* name = [scenes get:i];// .get(i).getName();
            NSDictionary* map = @{@"name":name};
            [arr addObject:map];
        }
        
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 获取当前场景图层列表
 *
 * @param promise
 */
RCT_REMAP_METHOD(getLayerList, getLayerList:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        int count = scene.layers.count;
       
        for (int i = 0; i < count; i++) {
            NSString* name = [scene.layers getLayerWithIndex:i].name;// .get(i).getName();
            BOOL visible = [scene.layers getLayerWithIndex:i].visible;
            BOOL selectable = [scene.layers getLayerWithIndex:i].selectable;// .isSelectable();
            Layer3DType type = [[scene.layers getLayerWithIndex:i] type];
            NSString *strType = nil;
            switch (type) {
                case IMAGEFILE:
                    strType = @"IMAGEFILE";
                    break;
                case KML :
                    strType = @"KML";
                    break;
                case VECTORFILE:
                    strType = @"VECTORFILE";
                    break;
                case WMTS:
                    strType = @"WMTS";
                    break;
                case OSGBFILE:
                    strType = @"OSGBFILE";
                    break;
                case BINGMAPS:
                    strType = @"BINGMAPS";
                    break;
                    
                default:
                    break;
            }

            NSDictionary* map;
            if (i == count - 1) {
                map = @{@"name":name,@"visible": @(visible),@"selectable": @(selectable),@"basemap":@(1),@"type":strType};
               // map.putBoolean("basemap", true);
            }
            map = @{@"name":name,@"visible": @(visible),@"selectable": @(selectable),@"type":strType};
            
            
            [arr addObject:map];
        }
        
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(changeBaseLayer, type:(int)type  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    sScene = [SScene singletonInstance];
    Scene* scene = sScene.smSceneWC.sceneControl.scene;
     @try {
         sScene.smSceneWC.sceneControl.isRender = false;
         [scene.layers removeLayerWithName:@"TianDiTu"];
         [scene.layers removeLayerWithName:@"BingMap"];
         Layer3D* layer3d = nil;
         if(type==1){//tianditu
             NSString * tiandituUrl = @"http://t0.tianditu.com/img_c/wmts";
             layer3d = [scene.layers addLayerWithTiandituURL:tiandituUrl type:BINGMAPS dataLayerName:@"TianDiTu" imageFormatType:ImageFormatTypeJPG_PNG dpi:96 toHead:NO];
         }else if (type==2){//bingMap
             layer3d = [scene.layers addLayerWithURL:@"" type:BINGMAPS dataLayerName:@"BingMap" toHead:NO];

         }
         sScene.smSceneWC.sceneControl.isRender = YES;
         resolve(@(layer3d!=nil));
     }@catch (NSException *exception) {
         reject(@"SScene", exception.reason, nil);
     }
}
RCT_REMAP_METHOD(addLayer3D,  Url:(NSString*) Url Layer3DType:(NSString*) layer3DType layerName:(NSString*) layerName imageFormatType:(NSString*) imageFormatType dpi:(double) dpi addToHead:(BOOL)addToHead  token:(NSString*)token resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    sScene = [SScene singletonInstance];
    Scene* scene = sScene.smSceneWC.sceneControl.scene;
    @try {
//        if (oldLayer != nil) {
//            [scene.layers removeLayerWithName:oldLayer];
//            //            scene.getLayers().get(oldLayer).setVisible(false);
//        }
        Layer3DType nlayer3DType = 0;
        if([layer3DType isEqualToString:@"IMAGEFILE"]){
            nlayer3DType = IMAGEFILE;
        }else if ([layer3DType isEqualToString:@"KML"]){
            nlayer3DType = KML;
        }else if ([layer3DType isEqualToString:@"l3dBingMaps"]){
            nlayer3DType = BINGMAPS;
        }else if ([layer3DType isEqualToString:@"OSGBFILE"]){
            nlayer3DType = OSGBFILE;
        }else if ([layer3DType isEqualToString:@"VECTORFILE"]){
            nlayer3DType = VECTORFILE;
        }else if ([layer3DType isEqualToString:@"WMTS"]){
            nlayer3DType = WMTS;
        }
        
       
        ImageFormatType imageFormatType1 ;
        if([imageFormatType isEqualToString:@"BMP"]){
            imageFormatType1 = ImageFormatTypeBMP;
        }else if ([imageFormatType isEqualToString:@"DXTZ"]){
            imageFormatType1 = ImageFormatTypeDXTZ;
        }else if ([imageFormatType isEqualToString:@"GIF"]){
            imageFormatType1 = ImageFormatTypeGIF;
        }else if ([imageFormatType isEqualToString:@"JPG"]){
            imageFormatType1 = ImageFormatTypeJPG;
        }else if ([imageFormatType isEqualToString:@"JPG_PNG"]){
            imageFormatType1 = ImageFormatTypeJPG_PNG;
        }else if ([imageFormatType isEqualToString:@"NONE"]){
            imageFormatType1 = ImageFormatTypeNONE;
        }else if ([imageFormatType isEqualToString:@"PNG"]){
            imageFormatType1 = ImageFormatTypeNONE;
        }
        
        Layer3D* layer3d = nil;
        if (dpi == 0 && imageFormatType == nil) {
            layer3d = [scene.layers addLayerWithURL:Url type:nlayer3DType dataLayerName:layerName toHead:addToHead];
        } else {
            layer3d = [scene.layers  addLayerWithTiandituURL:Url type:nlayer3DType dataLayerName:layerName imageFormatType:imageFormatType1 dpi:dpi toHead:dpi];
        }
        
        resolve(@(layer3d!=nil));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

//缩放到当前图层
RCT_REMAP_METHOD(ensureVisibleLayer, layer:(NSString*)layerName ensureVisibleLayerResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        Layer3D* layer3d = [sScene.smSceneWC.sceneControl.scene.layers getLayerWithName:layerName];
        Rect2D* bounds = layer3d.bounds;
        if(!bounds){
            TerrainLayer* layer3dTerr = [sScene.smSceneWC.sceneControl.scene.terrainLayers getLayerWithName:layerName];
            bounds = layer3dTerr.bounds;
        }
        if(bounds){
            [scene ensureVisibleWithBounds:[[Rectangle2D alloc]initWith:bounds.left bottom:bounds.bottom right:bounds.right top:bounds.top]];
        }
        resolve(@(1));
    }@catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
  
}
/**
 * 获取当前场景地形图层列表
 *
 * @param promise
 */
RCT_REMAP_METHOD(getTerrainLayerList, terrainLayerLisTresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        //   Maps* maps = sMap.smMapWC.workspace.maps;
        
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        int count = scene.terrainLayers.count;
        
        for (int i = 0; i < count; i++) {
            NSString* name = [scene.terrainLayers getLayerAtIndex:i].name;// .get(i).getName();
            BOOL visible = [scene.terrainLayers getLayerAtIndex:i].visible;
           // BOOL selectable = [scene.terrainLayers getLayerWithIndex:i].selectable;// .isSelectable();
            NSDictionary* map;
//             map = @{@"name":name,@"visible": @(visible),@"selectable": @(selectable),@"basemap":@(1),@"type":strType};
            map = @{@"name":name,@"visible": @(visible),@"selectable": @(0),@"basemap":@(0),@"type":@"Terrain"};
            [arr addObject:map];
        }
        
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 设置场景地形图层是否可见
 *
 * @param promise
 */
RCT_REMAP_METHOD(setTerrainLayerListVisible, name:(NSString*)name  bVisual:(BOOL)bVisual setTerrainLayerListVisible:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        //   Maps* maps = sMap.smMapWC.workspace.maps;
        
      //  NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        
       TerrainLayer* layer3D = [scene.terrainLayers getLayerWithName:name];
       layer3D.visible = bVisual;
        
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 设置场景图层是否可见
 *
 * @param promise
 */
RCT_REMAP_METHOD(setVisible, name:(NSString*)name  bVisual:(BOOL)bVisual setVisible:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        //   Maps* maps = sMap.smMapWC.workspace.maps;
        
        //NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        [scene.layers getLayerWithName:name].visible = bVisual;
        
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 设置场景图层是否可选择
 *
 * @param promise
 */
RCT_REMAP_METHOD(setSelectable, name:(NSString*)name  bVisual:(BOOL)bVisual setSelectable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        //   Maps* maps = sMap.smMapWC.workspace.maps;
        
        //NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        int count = scene.layers.count;
        if(count>0){
            [scene.layers getLayerWithName:name].selectable = bVisual;
        }
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

///**
// *搜索关键字显示位置相关信息列表
// * @param promise
// */
//
//RCT_REMAP_METHOD(pointSearch, key:(NSString*)key  pointSearch:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        NSLog(@"+++++++");
//        resolve(@(1));
//    } @catch (NSException *exception) {
//        reject(@"SScene", exception.reason, nil);
//    }
//}


RCT_REMAP_METHOD(pointSearch, keyWords:(NSString*)keyWords pointSearch:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        [[PoiSearchHelper sharedInstance] poiSearch:keyWords];
        resolve(@(1));
    } @catch (NSException * exception){
        reject(@"SScene",exception.reason, nil);
    }
}

-(void)locations:(NSArray *)locations{
    poiInfos=locations;
    
    NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
    int count = locations.count;
    for (int i = 0; i < count; i++) {
        OnlinePOIInfo * onlinePoiInfo=[locations objectAtIndex:i];
        NSString* name = onlinePoiInfo.name;
        NSDictionary* map;
        map = @{@"pointName":name};
        [arr addObject:map];
    }
    [self sendEventWithName:POINTSEARCH_KEYWORDS body:arr];
}

/**
 *初始化位置搜索
 * @param promise
 */
RCT_REMAP_METHOD(initPointSearch, initPointSearch:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        [[PoiSearchHelper sharedInstance] initSceneControl:sceneControl];
        resolve(@(1));
    } @catch (NSException * exception){
        reject(@"SScene",exception.reason, nil);
    }
}
/**
 * 获取当前sScene中心点 相机位置  场景未打开则返回定位
 * @param promise
 */
RCT_REMAP_METHOD(getSceneCenter, getSceneCenterWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Camera camera = sScene.smSceneWC.sceneControl.scene.camera;
        double x = camera.longitude;
        double y = camera.latitude;
        resolve(@{@"x":[NSNumber numberWithDouble:x],@"y":[NSNumber numberWithDouble:y]});
    } @catch (NSException *exception) {
        GPSData* gpsData = [NativeUtil getGPSData];
        double x = gpsData.dLongitude;
        double y = gpsData.dLatitude;
        resolve(@{@"x":[NSNumber numberWithDouble:x],@"y":[NSNumber numberWithDouble:y]});
    }
}
/**
 传入map，飞到指定位置
 * @param map = {
 *            "x": double,
 *            "y": double,
 *            "pointName": String
 *            }
 * @param promise
 */
RCT_REMAP_METHOD(toLocationPoint, Map:(NSDictionary *)map toLocationPoint:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        [scene.trackingLayer3D clear];
        
        double x = [[map objectForKey:@"x"]doubleValue];
        double y = [[map objectForKey:@"y"]doubleValue];
        
        Point2D *location = [[Point2D alloc]initWithX:x Y:y];
        
        NSString *name = [map objectForKey:@"pointName"];
        
        OnlinePOIInfo *onlinePoiInfo= [[OnlinePOIInfo alloc]init];
        onlinePoiInfo.location = location;
        onlinePoiInfo.name = name;
        
        [[PoiSearchHelper sharedInstance] toLocationPoint:onlinePoiInfo];
        [scene refresh];
        poiInfos=nil;
        resolve(@(1));
    } @catch (NSException * exception){
        reject(@"SScene",exception.reason, nil);
    }
}

/**
 *记录起点与终点
 * @param promise
 */
RCT_REMAP_METHOD(savePoint, index:(int)index pointType:(NSString*)type savePoint:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        if([type isEqualToString:@"firstPoint"]){
            firstPoint=[poiInfos objectAtIndex:index];
        }else if([type isEqualToString:@"secondPoint"]){
            secondPoint=[poiInfos objectAtIndex:index];
        }
        resolve(@(1));
    } @catch (NSException * exception){
        reject(@"SScene",exception.reason, nil);
    }
}

/**
 *三维在线路径分析
 * @param promise
 */
RCT_REMAP_METHOD(navigationLine,  navigationLine:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl=sScene.smSceneWC.sceneControl;
        [[PoiSearchHelper sharedInstance] clearPoint:sceneControl];
        [[PoiSearchHelper sharedInstance] navigationLine:firstPoint poiInfoEnd:secondPoint];
        [sceneControl.scene refresh];
        poiInfos=nil;
        resolve(@(1));
    } @catch (NSException * exception){
        reject(@"SScene",exception.reason, nil);
    }
}

/**
 * 场景放大缩小
 *
 * @param promise
 */
RCT_REMAP_METHOD(zoom,  scale:(double)scale zoom:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            sScene = [SScene singletonInstance];
            Scene* scene = sScene.smSceneWC.sceneControl.scene;
            [scene zoom:scale];
            [scene refresh];
            resolve(@(1));
        } @catch (NSException *exception) {
            reject(@"SScene", exception.reason, nil);
        }
    });
   
}
/**
 * 关闭工作空间及地图控件
 */
RCT_REMAP_METHOD(closeWorkspace,  closeWorkspace:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[LableHelper3D sharedInstance] closePage];
            
            sScene = [SScene singletonInstance];
            Scene* scene = sScene.smSceneWC.sceneControl.scene;
            Workspace *workspace = [scene workspace];
            [scene close];
            if (workspace!=nil) {
                [workspace close];
            }
            //[sScene.smSceneWC setWorkspace:nil];
            
        });
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
#pragma mark-指北
/**
 * 指北针
 *
 * @param promise
 */
RCT_REMAP_METHOD(setHeading,  setHeading:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        @try {
            sScene = [SScene singletonInstance];
            Scene* scene = sScene.smSceneWC.sceneControl.scene;
            Camera camera = [scene camera];
            camera.heading = 0;
            scene.camera = camera;
            [scene refresh];
            resolve(@(1));
        } @catch (NSException *exception) {
            reject(@"SScene", exception.reason, nil);
        }
    });
   
}
/**
 * 获取指北角度
 */
RCT_REMAP_METHOD( getcompass,  getcompassResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        if(sceneControl == nil){
            resolve(@(0));
        }else{
            double heading = sceneControl.scene.camera.heading ;
            resolve(@(heading));
        }
    } @catch (NSException *exception) {
        resolve(@(0));
    }
}

#pragma mark-查找
///**
// * 搜索关键字显示位置相关信息列表
// *
// * @param promise
// */
//RCT_REMAP_METHOD(pointSearch, name:(NSString*)name  pointSearch:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        resolve(@(1));
//    } @catch (NSException *exception) {
//        reject(@"SScene", exception.reason, nil);
//    }
//}
//
///**
// * 初始化位置搜索
// *
// * @param promise
// */
//RCT_REMAP_METHOD(pointSearch, pointSearch:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        resolve(@(1));
//    } @catch (NSException *exception) {
//        reject(@"SScene", exception.reason, nil);
//    }
//}

+(void)showAllFileWithPath:(NSString *) path filter:(NSString*)fileter resArr:(NSMutableArray*)resArr {
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath  = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                [self showAllFileWithPath:subPath filter:fileter resArr:resArr];
            }
        }else{
            NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
            if ([fileName.uppercaseString hasSuffix:fileter.uppercaseString]) {
                [resArr addObject:@{@"name":fileName,@"path":path}];
            }
        }
    }else{
        NSLog(@"this path is not exist!");
    }
}
#pragma mark-获取影像"sci3d"
RCT_REMAP_METHOD(getImageCacheNames, getImageCacheNames:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = [[sScene smSceneWC]sceneControl];
        NSString* path = [sScene.smSceneWC.workspace.connectionInfo server];
        NSArray* strArr = [path componentsSeparatedByString:@"/"];
        NSString * strServerName = [strArr lastObject];
        NSString* strDir = [[path substringToIndex:path.length-strServerName.length] stringByAppendingString:@"image"];
        
        //        [[FlyHelper3D sharedInstance] resetSceneControl:sceneControl SceneDir:strDir];
        //        NSArray *resultArray = [[FlyHelper3D sharedInstance] getFlyRouteNames];
        
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        [SScene showAllFileWithPath:strDir filter:@".sci3d" resArr:arr];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
//+(NSString*)findAvailableName:()
#pragma mark-添加影像缓存
RCT_REMAP_METHOD(addTerrainCacheLayer, TerrainCachePath:(NSString*)terrainCache layerName:(NSString*)layerName getTerrainCacheNames:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = [[sScene smSceneWC]sceneControl];
        int n = 1;
        NSString* AvailableName = layerName;
        while(true){
            if([sceneControl.scene.terrainLayers contains:AvailableName]){
                AvailableName = [layerName stringByAppendingFormat:@"#%i",n++];
            }else{
                break;
            }
        }
//        if([sceneControl.scene.terrainLayers contains:layerName]){
//
//            resolve(layerName);
//        }else
        {
            sceneControl.isRender = false;
            TerrainLayer* layer = [sceneControl.scene.terrainLayers addLayerWithPath:terrainCache toHead:YES name:AvailableName password:nil];
            sceneControl.isRender = YES;
            resolve(layer.name);
        }
       
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

#pragma mark-移除地形缓存
RCT_REMAP_METHOD(removeTerrainCacheLayer, terrainlayerName:(NSString*)layerName getTerrainCacheNames:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = [[sScene smSceneWC]sceneControl];
        
        sceneControl.isRender = false;
        BOOL b = [sceneControl.scene.terrainLayers removeLayerWithName:layerName];
        sceneControl.isRender = YES;
        resolve(@(b));
        
        
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

#pragma mark-添加影像缓存
RCT_REMAP_METHOD(addImageCacheLayer, ImageCachePath:(NSString*)terrainCache layerName:(NSString*)layerName getTerrainCacheNames:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = [[sScene smSceneWC]sceneControl];
        
        int n = 1;
        NSString* AvailableName = layerName;
        while(true){
            if([sceneControl.scene.layers getLayerWithName:AvailableName] != nil){
                AvailableName = [layerName stringByAppendingFormat:@"#%i",n++];
            }else{
                break;
            }
        }
//        if([sceneControl.scene.layers getLayerWithName:layerName] != nil){
//            resolve(layerName);
//        }else
        {
             sceneControl.isRender = false;
            Layer3D* layer = [sceneControl.scene.layers addLayerWith:terrainCache Type:IMAGEFILE ToHead:YES LayerName:layerName];
            sceneControl.isRender = YES;
            resolve(layer.name);
        }
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

#pragma mark-删除影像图层
RCT_REMAP_METHOD(removeImageCacheLayer, ImagelayerName:(NSString*)layerName getTerrainCacheNames:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = [[sScene smSceneWC]sceneControl];
        
        sceneControl.isRender = false;
        BOOL b = [sceneControl.scene.layers removeLayerWithName:layerName];
        sceneControl.isRender = YES;
        resolve(@(b));
        
        
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
#pragma mark-获取地形缓存 “.sct”
RCT_REMAP_METHOD(getTerrainCacheNames, getTerrainCacheNames:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = [[sScene smSceneWC]sceneControl];
        NSString* path = [sScene.smSceneWC.workspace.connectionInfo server];
        NSArray* strArr = [path componentsSeparatedByString:@"/"];
        NSString * strServerName = [strArr lastObject];
        NSString* strDir = [[path substringToIndex:path.length-strServerName.length] stringByAppendingString:@"terrain"];
        
//        [[FlyHelper3D sharedInstance] resetSceneControl:sceneControl SceneDir:strDir];
//        NSArray *resultArray = [[FlyHelper3D sharedInstance] getFlyRouteNames];
        
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        [SScene showAllFileWithPath:strDir filter:@".sct" resArr:arr];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

#pragma mark-飞行
/**
 * 获取飞行列表
 *
 * @param promise
 */
RCT_REMAP_METHOD(getFlyRouteNames, getFlyRouteNames:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = [[sScene smSceneWC]sceneControl];
        NSString* path = [sScene.smSceneWC.workspace.connectionInfo server];
        NSArray* strArr = [path componentsSeparatedByString:@"/"];
        NSString * strServerName = [strArr lastObject];
        NSString* strDir = [path substringToIndex:path.length-strServerName.length];
        [[FlyHelper3D sharedInstance] resetSceneControl:sceneControl SceneDir:strDir];
        NSArray *resultArray = [[FlyHelper3D sharedInstance] getFlyRouteNames];
        
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:1];
        int count = resultArray.count;
        
        for (int i = 0; i < count; i++) {
            NSString* name =[resultArray objectAtIndex:i];// .get(i).getName();
            NSDictionary* map;
            map = @{@"title":name,@"index": @(i)};
            [arr addObject:map];
        }
        
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 设置飞行
 *
 * @param promise
 */
RCT_REMAP_METHOD(setPosition, index:(int)index setPosition:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] chooseFlyRoute:index];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 开始飞行
 *
 * @param promise
 */
RCT_REMAP_METHOD(flyStart,  flyStart:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] flyPause];
        [[FlyHelper3D sharedInstance] flyStart];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 暂停飞行
 *
 * @param promise
 */
RCT_REMAP_METHOD(flyPause,  flyPause:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] flyPause];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 暂停或开始飞行
 *
 * @param promise
 */
RCT_REMAP_METHOD(flyPauseOrStart,  flyPauseOrStart:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance]flyPauseOrStart];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 结束飞行
 *
 * @param promise
 */
RCT_REMAP_METHOD(flyStop,  flyStop:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance]flyStop];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 获取飞行进度
 *
 * @param promise
 */
RCT_REMAP_METHOD(getFlyProgress,  getFlyProgress:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [FlyHelper3D sharedInstance].flyProgressDelegate = self;
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

-(void)flyProgressPercent:(int)percent{
    [self sendEventWithName:SSCENE_FLY body:@(percent)];
}



#pragma mark-属性
/**
 * 设置触控器获取对象属性
 *
 * @param promise
 */
RCT_REMAP_METHOD(getAttribute,  getAttribute:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//         sceneControl.sceneControlDelegate = self;
        sSceneAction |= SS_Feature_Action;
        [SScene setActionHelper:PANSELECT3D];
//        [sceneControl setAction3D:PANSELECT3D];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 清除对象列表属性
 *
 * @param promise
 */
RCT_REMAP_METHOD(clearSelection,  clearSelection:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Scene* scene = sScene.smSceneWC.sceneControl.scene;
        dispatch_async(dispatch_get_main_queue(), ^{
            int count = scene.layers.count;
            for (int i = 0; i < count; i++) {
                [[scene.layers getLayerWithIndex:i].selection3D clear];//  get(i).getSelection().clear();
            }
            
            [scene refresh];
        });
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(removeOnTouchListener,  removeOnTouchListener:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        sceneControl.sceneControlDelegate = nil;
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

-(void)getSelectedAttribute:(CGPoint)tapPoint{
    sScene = [SScene singletonInstance];
    SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
    NSDictionary* info = nil;
    [TouchUtil3D getAttribute:sceneControl attribute:&info];
    if (info!=nil) {
        [self sendEventWithName:SSCENE_ATTRIBUTE
                           body:info];
    }
}

#pragma mark-LabelHelper
/**
 * 标注初始化
 */
//RCT_REMAP_METHOD(initsymbol,  initsymbol:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        Workspace* workspace = sScene.smSceneWC.workspace;
//        NSString* path = sScene.smSceneWC.workspace.connectionInfo.server;
//        NSString* result = [path.stringByDeletingLastPathComponent stringByAppendingString:@"/files/"];
//        NSString* kmlname = @"newKML.kml";
//
//        [[LableHelper3D sharedInstance] initSceneControl:sceneControl path:result kml:kmlname];
//        [LableHelper3D sharedInstance].delegate = self;
//
//        resolve(@(1));
//    } @catch (NSException *exception) {
//        reject(@"SScene", exception.reason, nil);
//    }
//}

/**
 * 标注打点
 */
//RCT_REMAP_METHOD(startDrawPoint,  startDrawPoint:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sSceneEvent = SS_Label_Event;
////        sScene = [SScene singletonInstance];
////        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        [[LableHelper3D sharedInstance] startDrawPoint];
//        resolve(@(1));
//    } @catch (NSException *exception) {
//        reject(@"SScene", exception.reason, nil);
//    }
//}

/**
 * 标注点绘线
 */
RCT_REMAP_METHOD(startDrawLine,  startDrawLine:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sSceneEvent = SS_Label_Event;
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        [[LableHelper3D sharedInstance] startDrawLine];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 标注点绘面
 */
RCT_REMAP_METHOD(startDrawArea,  startDrawArea:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sSceneEvent = SS_Label_Event;
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        [[LableHelper3D sharedInstance] startDrawArea];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 标注撤销
 */
RCT_REMAP_METHOD(symbolback,  symbolback:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        [[LableHelper3D sharedInstance] back];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}



/**
 * 保存所有标注
 */
RCT_REMAP_METHOD(save,  save:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LableHelper3D sharedInstance] save];
        });
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 标注绘制文本
 */
RCT_REMAP_METHOD(startDrawText,  startDrawText:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sSceneEvent = SS_Label_Event;
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;

        [[LableHelper3D sharedInstance] startDrawText];
        

        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

-(void)drawTextAtPoint:(Point3D)pnt{
            [self sendEventWithName:SSCENE_SYMBOL
                               body:@{@"pointX":@(pnt.x),@"pointY":@(pnt.y),@"pointZ":@(pnt.z)}];
}

/**
 * 标注添加文本
 */
RCT_REMAP_METHOD(addGeoText,  addGeoTextX:(double)x Y:(double)y Z:(double)z Text:(NSString*)text resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            Point3D pnt = {x,y,z};
            [[LableHelper3D sharedInstance] addGeoText:pnt test:text];
        });
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
/**
 * 关闭所有标注
 */
RCT_REMAP_METHOD( closeAllLabel,   closeAllLabel:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LableHelper3D sharedInstance] clearAllLabel];
        });
        sSceneEvent = SS_Normal_Event;
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        [sceneControl setAction3D:PANSELECT3D];
        [SScene setActionHelper:PANSELECT3D];
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
/**
 * 清除所有标注
 */
RCT_REMAP_METHOD(clearAllLabel,  clearAllLabel:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LableHelper3D sharedInstance] reset];
        });
        sSceneEvent = SS_Normal_Event;
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        [SScene setActionHelper:PANSELECT3D];
//        [sceneControl setAction3D:PANSELECT3D];
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
RCT_REMAP_METHOD(resetLableAction,  resetLableAction:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {

        [[LableHelper3D sharedInstance] reset];
        sSceneEvent = SS_Normal_Event;
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        [SScene setActionHelper:PANSELECT3D];
//        [sceneControl setAction3D:PANSELECT3D];
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
/**
 * 清除当前编辑下的所有标注
 */
RCT_REMAP_METHOD(clearcurrentLabel,  clearcurrentLabel:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        [[LableHelper3D sharedInstance] clearTrackingLayer];
//        sSceneEvent = SS_Normal_Event;
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        [sceneControl setAction3D:PANSELECT3D];
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

#pragma mark-兴趣点
/**
 * 开始绘制兴趣点
 */
RCT_REMAP_METHOD(startDrawFavorite,  startDrawFavoriteWithText:(NSString *)text resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sSceneEvent = SS_Label_Event;
        
        [[LableHelper3D sharedInstance] setFavoriteText:text];
        [[LableHelper3D sharedInstance] startDrawFavorite];
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        
       
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

-(void)drawFavoriteAtPoint:(Point3D)pnt{
    sScene = [SScene singletonInstance];
    SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
    CGPoint pixel = [sceneControl.scene globeToPixel:pnt];
    [[LableHelper3D sharedInstance] setFavoriteText:@""];
    [self sendEventWithName:SSCENE_FAVORITE
                       body:@{@"pointX":@(pixel.x),@"pointY":@(pixel.y)}];
}

/**
 * 设置兴趣点文本
 */
RCT_REMAP_METHOD(setFavoriteText,  setFavoriteText:(NSString*)text resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        //        sScene = [SScene singletonInstance];
        //        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[LableHelper3D sharedInstance] setFavoriteText:text];
        });
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}


#pragma mark-绕点飞行
/**
 * 添加环绕飞行的点
 *
 * @param point
 */
RCT_REMAP_METHOD(getFlyPoint,  getFlyPoint:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
//        sceneControl.sceneControlDelegate = self;
        sSceneAction |= SS_FlyPoint_Action;
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 清除环绕飞行的点
 */
RCT_REMAP_METHOD(clearCirclePoint,  clearCirclePoint:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        //        sScene = [SScene singletonInstance];
        //        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        
        [[LableHelper3D sharedInstance]clearCirclePoint];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 环绕飞行
 */
RCT_REMAP_METHOD(setCircleFly,  circleFly:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        //        sScene = [SScene singletonInstance];
        //        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        
        [[LableHelper3D sharedInstance]circleFly];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

/**
 * 环绕飞行
 */
RCT_REMAP_METHOD(stopCircleFly,  stopCircleFly:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        sScene = [SScene singletonInstance];
//        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        
        [[LableHelper3D sharedInstance]stopCircleFly];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

-(void)addCirclePoint:(CGPoint)position{
    BOOL res = [[LableHelper3D sharedInstance]addCirclePoint:position];
    if (res) {
        [self sendEventWithName:SSCENE_CIRCLEFLY
                           body:@{@"pointX":@(position.x),@"pointY":@(position.y)}];
    }
}

RCT_REMAP_METHOD(back,  back:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

#pragma mark-三维分析
/**
 * 三维量算分析
 *
 * @param promise
 */
RCT_REMAP_METHOD(setMeasureLineAnalyst, setMeasureLineAnalystResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        SceneControl* sceneControl = [[[SScene singletonInstance]smSceneWC] sceneControl];
//        [[AnalysisHelper3D sharedInstance] initializeWithSceneControl:sceneControl];
        [AnalysisHelper3D sharedInstance].delegate = self;
//        sceneControl.tracking3DDelegate = self;
        sSceneEvent = SS_Analysis_Event;

        [[AnalysisHelper3D sharedInstance] startMeasureAnalysis];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
-(void)distanceResult:(double)distance{
//    distance = ((int)(distance*1000000+0.5))/1000000.0;
    distance = ((long)(distance*100))/100.0;
    [self sendEventWithName:ANALYST_MEASURELINE body:@(distance)];
}

/**
 * 三维面积分析
 *
 * @param promise
 */
RCT_REMAP_METHOD(setMeasureSquareAnalyst, setMeasureSquareAnalystResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        SceneControl* sceneControl = [[[SScene singletonInstance]smSceneWC] sceneControl];
//        [[AnalysisHelper3D sharedInstance] initializeWithSceneControl:sceneControl];
        [AnalysisHelper3D sharedInstance].delegate = self;
//        sceneControl.tracking3DDelegate = self;
        sSceneEvent = SS_Analysis_Event;

        [[AnalysisHelper3D sharedInstance] startSureArea];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
-(void)areaResult:(double)area{
    [self sendEventWithName:ANALYST_MEASURESQUARE body:@(area)];
}


/**
 * 关闭所有分析
 *
 * @param promise
 */
RCT_REMAP_METHOD( closeAnalysis,  closeAnalysisResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        SceneControl* sceneControl = [[[SScene singletonInstance]smSceneWC] sceneControl];
//        [[AnalysisHelper3D sharedInstance] initializeWithSceneControl:sceneControl];
        dispatch_async(dispatch_get_main_queue(), ^{
            [AnalysisHelper3D sharedInstance].delegate = nil;
            [[AnalysisHelper3D sharedInstance] closeAnalysis];
            sSceneEvent = SS_Normal_Event;
        });
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(setNavigationControlVisible,  setNavigationControlVisible:(BOOL)bVisable resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
        [sceneControl setNavigationControlVisible:bVisable];
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
+(void)setActionHelper:(Action3D)action{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            sScene = [SScene singletonInstance];
            SceneControl* sceneControl = sScene.smSceneWC.sceneControl;
            [sceneControl setAction3D:action];
        });
    });
}
RCT_REMAP_METHOD(setAction,  setAction:(NSString*)strAction resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        if ([strAction isEqualToString:@"CREATELINE3D"]) {
            [SScene setActionHelper:CREATELINE3D];
//            [sceneControl setAction3D:CREATELINE3D];
        }else if([strAction isEqualToString:@"CREATEPOINT3D"]){
            [SScene setActionHelper:CREATEPOINT3D];
//            [sceneControl setAction3D:CREATEPOINT3D];
        }else if([strAction isEqualToString:@"CREATEPOLYGON3D"]){
            [SScene setActionHelper:CREATEPOLYGON3D];
//            [sceneControl setAction3D:CREATEPOLYGON3D];
        }else if([strAction isEqualToString:@"CREATEPOLYLINE3D"]){
            [SScene setActionHelper:CREATEPOLYLINE3D];
//            [sceneControl setAction3D:CREATEPOLYLINE3D];
        }else if([strAction isEqualToString:@"MEASUREAREA3D"]){
            [SScene setActionHelper:MEASUREAREA3D];
//            [sceneControl setAction3D:MEASUREAREA3D];
        }else if([strAction isEqualToString:@"MEASUREDISTANCE3D"]){
            [SScene setActionHelper:MEASUREDISTANCE3D];
//            [sceneControl setAction3D:MEASUREDISTANCE3D];
        }else if([strAction isEqualToString:@"NULL"]){
            [SScene setActionHelper:NONEACTION3D];
//            [sceneControl setAction3D:NONEACTION3D];
        }else if([strAction isEqualToString:@"PAN3D"]){
            [SScene setActionHelper:PAN3D];
//            [sceneControl setAction3D:PAN3D];
        }else if([strAction isEqualToString:@"PANSELECT3D"]){
            [SScene setActionHelper:PANSELECT3D];
//            [sceneControl setAction3D:PANSELECT3D];
        }
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(saveCurrentRoutStop, saveCurrentRoutStop:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] saveCurrentRouteStop];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(saveRoutStop, saveRoutStop:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] saveRoutStop];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(pauseRoutStop, pauseRoutStop:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] routStopPasue];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}


RCT_REMAP_METHOD(clearRoutStops, clearRoutStops:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] clearRoutStops];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getRoutStops, getRoutStops:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSArray* array=[[FlyHelper3D sharedInstance] getStopList];
        resolve(array);
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(removeByName, removeByName:(NSString*)name resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [[FlyHelper3D sharedInstance] removeStop:name];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
#pragma mark ----------------------------     三维裁剪相关开始     ------------------------------

#pragma mark box裁剪
// posDic参数
//  {
//   startX:"",    //起点x坐标
//   startY:"",    //起点y坐标
//   endX:"",   //终点x坐标
//   endY:"",  //终点y坐标
//   layers:[],  //参加裁剪的图层 为空全部裁剪
//   clipInner:boolean 裁剪位置 true 裁剪内部 false 裁剪外部
//   ************************可选参数 携带了以下参数可以不用传起点 终点坐标***************
//   width:"", //底面长
//   length:"", //底面宽
//   height:"", //高度
//   x:"",  //中心点坐标
//   y:"",
//   z:"",
//   zRot:"", //z旋转
//   lineColor:""，//裁剪线颜色
//   ********************************************************************
// }
RCT_REMAP_METHOD(clipByBox, clipByBoxWithDic:(NSDictionary *)posDic resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        __block NSDictionary *returnDic = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL useCookie = NO;
            double zRot = 0;
            if([posDic valueForKey:@"width"]){
                useCookie = YES;
                zRot = [[posDic valueForKey:@"zRot"] doubleValue];
            }
            sScene = [SScene singletonInstance];
            Layer3Ds *layer3ds = sScene.smSceneWC.sceneControl.scene.layers;
            
            Point3D centerPoint;
            double width,length,height,x,y,z;
            Size2D *size2d = [[Size2D alloc]init];
            GeoBox *box = [[GeoBox alloc]init];
            
            if(!useCookie){
                CGPoint p1 = {.x=[[posDic valueForKey:@"startX"]doubleValue],.y=[[posDic valueForKey:@"startY"]doubleValue]};
                
                CGPoint p2 = {.x=[[posDic valueForKey:@"endX"]doubleValue],.y=[[posDic valueForKey:@"endY"]doubleValue]};
                
                CGFloat scale = [UIScreen mainScreen].scale;
                CGPoint pointStart = CGPointMake( p1.x * scale-56/2, p1.y * scale);//  修正底层添加的点和实际不一致
                CGPoint pointEnd = CGPointMake( p2.x * scale-56/2, p2.y * scale);//  修正底层添加的点和实际不一致
                
//                Point3D pnt3D = [mSceneControl.scene pixelToGlobeWith:point andPixelToGlobeMode:TerrainAndModel];

                Point3D startPoint = [sScene.smSceneWC.sceneControl.scene pixelToGlobeWith:pointStart andPixelToGlobeMode:TerrainAndModel];
                Point3D endPoint = [sScene.smSceneWC.sceneControl.scene pixelToGlobeWith:pointEnd andPixelToGlobeMode:TerrainAndModel];
                
                [[LableHelper3D sharedInstance] addGeoText:startPoint test:@"start"];
                [[LableHelper3D sharedInstance] addGeoText:endPoint test:@"end"];
                x = (startPoint.x + endPoint.x) / 2;
                y = (startPoint.y + endPoint.y) / 2;
                z = (startPoint.z + endPoint.z) / 2;
                
                //经纬度差值转距离 单位 米
                double R = 6371393;
                double PI = 3.141592653589793;
                double dpi = 1;
                width = fabs((endPoint.x - startPoint.x) * PI * R * cos((endPoint.y + startPoint.y) / 2 * PI / 180) /180);
                length = fabs((endPoint.y - startPoint.y) * PI *R / 180);
                height = fabs(p1.y - p2.y) / dpi;
                
            }else{
                x = [[posDic valueForKey:@"X"]doubleValue];
                y = [[posDic valueForKey:@"Y"]doubleValue];
                z = [[posDic valueForKey:@"Z"]doubleValue];
                width = [[posDic valueForKey:@"width"]doubleValue];
                length = [[posDic valueForKey:@"length"]doubleValue];
                height = [[posDic valueForKey:@"height"]doubleValue];
            }
            
            centerPoint.x = x;
            centerPoint.y = y;
            centerPoint.z = z;
            
            [size2d setWidth:width];
            [size2d setHeight:height];
            
            [box setPosition:centerPoint];
            [box setBottomSize:size2d];
            [box setHeight:height];
            BoxClipPart part;
            BOOL clipInner = [[posDic valueForKey:@"clipInner"] boolValue];
            if(clipInner){
                part = BoxClipPartInner;
            }else{
                part = BoxClipPartOuter;
            }
            
            BOOL needFilter = YES;
            NSArray *layers = [posDic valueForKey:@"layers"];
            
            if([layers count] == 0 && !((NSNumber*)[posDic valueForKey:@"isCliped"]).boolValue){
                needFilter = NO;
            }
            
            if(needFilter){
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                for(int i = 0; i < layer3ds.count; i++){
                    Layer3D *layer3d = [layer3ds getLayerWithIndex:i];
                    [layer3d clearCustomClipPlane];
                    for(int j = 0; j < [layers count]; j++){
                        dic = layers[j];
                        if([[dic valueForKey:@"name"]isEqualToString:layer3d.name]){
                            [layer3d clipByBox:box part:part];
                        }
                    }
                }
            }else{
                for(int i = 0; i < layer3ds.count; i++){
                    Layer3D *layer3d = [layer3ds getLayerWithIndex:i];
                    [layer3d clearCustomClipPlane];
                    [layer3d clipByBox:box part:part];
                }
            }
            [sScene.smSceneWC.sceneControl.scene refresh];
            
            returnDic = @{
                          @"width":[[NSNumber alloc]initWithDouble:width],
                          @"height":[[NSNumber alloc]initWithDouble:height],
                          @"length":[[NSNumber alloc]initWithDouble:length],
                          @"zRot":[[NSNumber alloc]initWithDouble:zRot],
                          @"X":[[NSNumber alloc]initWithDouble:x],
                          @"Y":[[NSNumber alloc]initWithDouble:y],
                          @"Z":[[NSNumber alloc]initWithDouble:z],
                          @"clipInner":@(clipInner),
                          };
            
        });
        
       
        while(returnDic == nil){
            sleep(1);
        }
        
        resolve(returnDic);
    } @catch (NSException *exception) {
        reject(@"clipByBox()",exception.reason,nil);
    }
}
RCT_REMAP_METHOD(clipSenceClear, clipByBoxWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sScene = [SScene singletonInstance];
        Layer3Ds *layer3ds = sScene.smSceneWC.sceneControl.scene.layers;
        for(int i = 0; i < layer3ds.count; i++){
            Layer3D *layer3D = [layer3ds getLayerWithIndex:i];
            [layer3D clearCustomClipPlane];
        }
        [sScene.smSceneWC.sceneControl.scene refresh];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"clipSenceClear()",exception.reason,nil);
    }
}
#pragma mark ----------------------------     三维裁剪相关结束    ------------------------------
@end
