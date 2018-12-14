//
//  LableHelper3D.m
//  Supermap
//
//  Created by imobile-xzy on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "LableHelper3D.h"
#import "SuperMap/GeoStyle3D.h"
#import "SuperMap/GeoPoint3D.h"
#import "SuperMap/Feature3Ds.h"
#import "SuperMap/GeoPlacemark.h"
#import "SuperMap/AltitudeMode3D.h"
#import "SuperMap/TextPart3D.h"
#import "SuperMap/GeoText3D.h"
#import "SuperMap/Point3Ds.h"
#import "SuperMap/Scene.h"
#import "JSSystemUtil.h"
#import "SuperMap/GeoRegion3D.h"
#import "SuperMap/Tracking3DEvent.h"
#import "SuperMap/TextStyle.h"
#import "SuperMap/Feature3D.h"


typedef enum{
    /**
     * 空操作
     */
    NONE,
    /**
     * 打点
     */
    DRAWPOINT,
    /**
     * 画线
     */
    DRAWLINE,
    /**
     * 画面
     */
    DRAWAREA,
    /**
     * 文字
     */
    DRAWTEXT,
    /**
     * 兴趣点
     */
    DRAWFAVORITE
}EnumLabelOperate;


@interface LableHelper3D(){
    SceneControl* mSceneControl;
    // 定义一个全局变量 存储Point3D
    NSMutableArray* myPoint3DArrayList;
    //文本缓存列表
    NSMutableArray* geoTextStrList;
    // 声明一个全局的节点动画轨迹对象
    GeoLine3D* geoline3d;
    GeoRegion3D* geoArea3d;
    //    private boolean isDrawLine,isDrawArea,isPoint;
    BOOL isEdit;
    EnumLabelOperate labelOperate;
    //保存到kml路径
    NSString* kmlPath ;
    NSString* kmlName ;
    //文本点击回调
    //private DrawTextListener drawTextListener;
    
    
    //兴趣点feature3d
    Feature3D* favoriteFeature3D;
    //绕点选择frature3d
    Feature3D* circleFeature3D;
//    // 长按时添加一个动画
//    private ImageView favoriteAnimImageView;
//    private Animation animationImageView;
//    //绕点飞行添加点动画view
//    private ImageView circleAnimImageView;
    
  //  Layer3D *favoriteLayer3d;
    Layer3D *mLayer3d;
    

}

@end


@implementation LableHelper3D
SUPERMAP_SIGLETON_IMP(LableHelper3D);

-(void)initSceneControl:(SceneControl*)control path:(NSString*)strpath kml:(NSString*)strkmlName{
    [self closePage];
    
    mSceneControl = control;
    kmlName = strkmlName;
    kmlPath = strpath;
   // favoriteLayer3d = nil;
    mLayer3d = nil;
    
    myPoint3DArrayList = [[NSMutableArray alloc]init];
    geoTextStrList = [[NSMutableArray alloc]init];
    
   // 打开手势回调
    //mSceneControl.tracking3DDelegate = self;
    
    mSceneControl.action3D = CREATEPOINT3D;
    [self addKML];
   // favoriteLayer3d = [mSceneControl.scene.layers getLayerWithName:@"Favorite"];
    
    [self reset];
    //    geoline3d = nil;
    //    geoArea3d = nil;
    //    isEdit = false;
    //    labelOperate = NONE;
    
    //    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    //    //使用一根手指双击时，才触发点按手势识别器
    //    recognizer.numberOfTapsRequired = 1;
    //    recognizer.numberOfTouchesRequired = 1;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [mSceneControl addGestureRecognizer:recognizer];
    //    });
}


- (void)tracking3DEvent:(Tracking3DEvent*)event{
    
    if (labelOperate == NONE) {
        return;
    }

//    double x = event.position.x ;
//    double y = event.position.y ;
//    double z = event.position.z;
//    dz = z;
//    Point3D point = {x,y,z};
    //CGPoint point = CGPointMake(x, y);

    Point3D p3d = event.position;

    if(labelOperate==DRAWTEXT){
        if (self.delegate!=nil && [self.delegate  respondsToSelector:@selector(drawTextAtPoint:)]) {
            [self.delegate drawTextAtPoint:p3d];
        }
        return ;
    }else if(labelOperate == DRAWFAVORITE){
        [self showFavorite:p3d];
        return;
    }
    
    GeoPoint3D* geoP3 = [[GeoPoint3D alloc]initWithX:p3d.x Y:p3d.y Z:p3d.z];
//    geoP3.x = p3d.x;
//    geoP3.y = p3d.y;
//    geoP3.z = p3d.z;
    [myPoint3DArrayList addObject:geoP3];
    isEdit = true;
    
    [self show];
}
/**
 * 开始绘制面积
 */
-(void)startDrawArea{
    [myPoint3DArrayList removeAllObjects];
    [mSceneControl setAction3D:CREATEPOINT3D];
    labelOperate = DRAWAREA;
}

/**
 * 开始绘制文本
 */
-(void)startDrawText{
    [self reset];
    [mSceneControl setAction3D:CREATEPOINT3D];
    labelOperate = DRAWTEXT;
}

/**
 * 开始绘制线段
 */
-(void)startDrawLine{
    [myPoint3DArrayList removeAllObjects];
    [mSceneControl setAction3D:CREATEPOINT3D];
    labelOperate = DRAWLINE;
}

/**
 * 开始绘制点
 */
-(void)startDrawPoint{
    [myPoint3DArrayList removeAllObjects];
    [mSceneControl setAction3D:CREATEPOINT3D];
    labelOperate = DRAWPOINT;
}

/**
 * 开始绘制兴趣点
 */
-(void)startDrawFavorite{
    [self reset];
    [mSceneControl setAction3D:CREATEPOINT3D];
    labelOperate = DRAWFAVORITE;
}

/**
 * 返回
 */
-(void)back{
    if (labelOperate == DRAWFAVORITE) {
        [self favoriteCancel];
        return;
    }
    if (myPoint3DArrayList.count > 0) {
        isEdit = true;
    } else {
        isEdit = false;
        return;
    }
    
    [myPoint3DArrayList removeLastObject];// remove(myPoint3DArrayList.size() - 1);
    
    [self show];
}

/**
 * 清除所有标注
 */
-(void)clearAllLabel{
    mSceneControl.isRender = false;
    [mSceneControl.scene.layers removeLayerWithName:@"NodeAnimation"];// getScene().getLayers().removeLayerWithName("NodeAnimation");
    //[self reset];
    if ( [self deleteSingleFile: [kmlPath stringByAppendingString:kmlName]]){// deleteSingleFile(kmlPath + kmlName)) {
       // [self addKML];
    }
//    [mSceneControl.scene.layers removeLayerWithName:@"Favorite"];// getScene().getLayers().removeLayerWithName("NodeAnimation");
//
//    if ( [self deleteSingleFile: [kmlPath stringByAppendingString:@"Favorite.kml"]]){// deleteSingleFile(kmlPath + kmlName)) {
//
//    }
    mLayer3d = nil;
    [self reset];
     [self addKML];
    mSceneControl.isRender  = YES;
}

/**
 * 保存
 */
-(void)save{
    if (DRAWFAVORITE==labelOperate) {
        [self saveFavoritePoint];
        return;
    }
    
    if (!isEdit) {
        return;
    }
    mSceneControl.isRender = false;
    Layer3D* layer3d = [mSceneControl.scene.layers getLayerWithName:@"NodeAnimation"];// getScene().getLayers().get("NodeAnimation");
    
    switch (labelOperate) {
        case DRAWPOINT:
            for (GeoPoint3D* point3D in myPoint3DArrayList) {
                GeoStyle3D* geoPoint3dStyle = [[GeoStyle3D alloc]init];
                geoPoint3dStyle.fillForeColor = [[Color alloc]initWithR:255 G:255 B:0];//.setFillForeColor((new Color(255, 255, 0)));
                geoPoint3dStyle.altitudeMode = Absolute3D; //setAltitudeMode(AltitudeMode.ABSOLUTE);
                GeoPoint3D* geoPoint3D = [[GeoPoint3D alloc]init];//new GeoPoint3D(point3D);
                geoPoint3D.style3D =  geoPoint3dStyle;//setStyle3D(geoPoint3dStyle);
                //保存点
                Feature3D* fea3d = [layer3d.feature3Ds addGeometry3D:geoPoint3D]; //getFeatures().add(geoPoint3D);
                NSString* description = [NSString stringWithFormat:@"x=%.2f, y=%.2f, z=%.2f",geoPoint3D.position.x,geoPoint3D.position.y,geoPoint3D.position.z];
                fea3d.description = description;
            }
            break;
        case DRAWLINE:{
            //保存线
            
            Feature3D* fea3d = [layer3d.feature3Ds addGeometry3D:geoline3d];
             NSString* description = [NSString stringWithFormat:@"x=%.2f, y=%.2f, z=%.2f",geoline3d.position.x,geoline3d.position.y,geoline3d.position.z];
            fea3d.description = description;
            // layer3d.getFeatures().add(geoline3d);
            break;
        }case DRAWAREA:
        {
//            Point3Ds *pnt3ds = [geoArea3d getPart:0];
//            GeoRegion3D *georegion3d = [[GeoRegion3D alloc] initWithPoint3Ds:pnt3ds];
            Feature3D* fea3d = [layer3d.feature3Ds addGeometry3D:geoArea3d];
            NSString* description = [NSString stringWithFormat:@"x=%.2f, y=%.2f, z=%.2f",geoArea3d.position.x,geoArea3d.position.y,geoArea3d.position.z];
            fea3d.description = description;
        }
            break;
        case DRAWTEXT:
            for (int index = 0; index < myPoint3DArrayList.count; index++) {
                GeoPoint3D* point3D = myPoint3DArrayList[index];
                GeoPlacemark* geoPlacemark = [[GeoPlacemark alloc]initWithName:geoTextStrList[index] andGeomentry:point3D];//new GeoPlacemark(geoTextStrList.get(index), new GeoPoint3D(point3D));
                 Feature3D* fea3d = [layer3d.feature3Ds addGeometry3D:geoPlacemark];//add(geoPlacemark);
                NSString* description = [NSString stringWithFormat:@"x=%.2f, y=%.2f, z=%.2f",geoPlacemark.position.x,geoPlacemark.position.y,geoPlacemark.position.z];
                fea3d.description = description;
            }
            break;
        default:
            break;
    }
    //保存
    [layer3d.feature3Ds toKMLFile:[kmlPath stringByAppendingString:kmlName]];// .toKMLFile(kmlPath + kmlName);
    mSceneControl.isRender = YES;
    
    geoline3d = nil;
    geoArea3d = nil;
    [mSceneControl.scene.trackingLayer3D clear];
    [myPoint3DArrayList removeAllObjects];
    [geoTextStrList removeAllObjects];
    isEdit = false;
    [self favoriteCancel];
    
}

/**
 * 添加文本标注
 * @param point
 * @param text
 */
-(void)addGeoText:(Point3D)pnt test:(NSString*)text{
    //Point3D pnt3d = [mSceneControl.scene pixelToGlobeWith:point andPixelToGlobeMode:TerrainAndModel];// getScene().pixelToGlobe(point, PixelToGlobeMode.TERRAINANDMODEL);
    
    
    GeoPoint3D* p3d = [[GeoPoint3D alloc]initWithPoint3D:pnt];
    GeoPlacemark* geoPlacemark = [[GeoPlacemark alloc]initWithName:text andGeomentry: p3d];//new GeoPlacemark(text, new GeoPoint3D(pnt3d));
    
//    TextPart3D* part = [[TextPart3D alloc]initWithString:text x:point.x y:point.y z:dz];
//    GeoText3D *geotext = [[GeoText3D alloc]initWithTextPart3D:part];
    GeoStyle3D* textStyle3D = [[GeoStyle3D alloc]init];
    textStyle3D.altitudeMode = Absolute3D; // setAltitudeMode(AltitudeMode.ABSOLUTE);
    geoPlacemark.style3D = textStyle3D;
    TextStyle* textStyle = [[TextStyle alloc]init];;
    [textStyle setForeColor:[ [Color alloc]initWithR:255 G:0 B:0]];
    [textStyle setFontWidth:50];
    [textStyle setFontHeight:50];
    geoPlacemark.nameStyle = textStyle;;
    
    mSceneControl.isRender = NO;
    [mSceneControl.scene.trackingLayer3D AddGeometry:geoPlacemark Tag:@"text"]; //getScene().getTrackingLayer().add(geoPlacemark, "text");
    mSceneControl.isRender = YES;
    
    [myPoint3DArrayList addObject:p3d];// .add(pnt3d);
    [geoTextStrList addObject:text];//.add(text);
    isEdit = true;
}

/**
 * 添加环绕飞行的点
 *
 * @param point
 */
-(BOOL)addCirclePoint:(CGPoint)longPressPoint{
    if (mLayer3d!=nil) {
        CGFloat scale = [UIScreen mainScreen].scale;
        if (longPressPoint.x * scale-56/2<0) {
            return false;
        }
        CGPoint point = CGPointMake( longPressPoint.x * scale-56/2, longPressPoint.y * scale);//  修正底层添加的点和实际不一致
    
        Point3D pnt3D = [mSceneControl.scene pixelToGlobeWith:point andPixelToGlobeMode:TerrainAndModel];

        
        GeoPoint3D *geopnt = [[GeoPoint3D alloc]initWithPoint3D:pnt3D];
        NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:@"resources" ofType:@"bundle"];
        NSString *strMarkerPath = [strBundlePath stringByAppendingString:@"/icon_red.png"];

        //NSString *strMarkerPath = @"assert.bundle/icon_green.png";
        GeoStyle3D *geostyle = [[GeoStyle3D alloc]init];
        
        [geostyle setMarkerFile:strMarkerPath];
        [geostyle setAltitudeMode:Absolute3D];
        
        [geopnt setStyle3D:geostyle];
        
        //动画
        UIImage *image = [UIImage imageNamed:@"resources.bundle/icon_red.png"];
        UIImageView *favoritesView = [[UIImageView alloc] initWithImage:image];
        favoritesView.layer.anchorPoint = longPressPoint;
        favoritesView.frame = CGRectMake(longPressPoint.x - 56 / 2, longPressPoint.y - 56, 56, 56);
        [mSceneControl addSubview:favoritesView];
        [self applyAnimationToFavorites:favoritesView completion:^{
            mSceneControl.isRender = NO;
            GeoPlacemark *geoPlacemark = [[GeoPlacemark alloc]initWithName:@"" andGeomentry:geopnt];
            TextStyle *textstyle = [[TextStyle alloc]init];
            [geoPlacemark setNameStyle:textstyle];
            
            if (circleFeature3D==nil) {
                circleFeature3D = [[mLayer3d feature3Ds]addGeometry3D:geoPlacemark];
            }else{
                [[mLayer3d feature3Ds]removeFeature3D:circleFeature3D];
                circleFeature3D = nil;
                circleFeature3D = [[mLayer3d feature3Ds]addGeometry3D:geoPlacemark];
                //[circleFeature3D setGeometry3D:geoPlacemark];
            }
            //isEdit = true;
            mSceneControl.isRender = YES;
        }];
        return true;
    }
    return false;
}
- (void)applyAnimationToFavorites:(UIView *)favorites completion:(void(^)())completion {
    CGRect frame = favorites.frame;
    [UIView animateWithDuration:0.2
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         favorites.frame = CGRectMake(CGRectGetMinX(frame) - CGRectGetWidth(frame) / 2, CGRectGetMinY(frame) - CGRectGetHeight(frame), 2*CGRectGetWidth(frame), 2*CGRectGetHeight(frame));
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0
                              usingSpringWithDamping:0.8
                               initialSpringVelocity:0.5
                                             options:UIViewAnimationOptionLayoutSubviews
                                          animations:^{
                                              favorites.frame = frame;
                                              if (completion) completion();
                                              favorites.hidden = YES;
                                          }
                                          completion:^(BOOL finished) {
                                              [favorites removeFromSuperview];
                                          }];
                     }];
}
/**
 * 清除环绕飞行的点
 */
-(void) clearCirclePoint{
    if (circleFeature3D==nil ) {
        return;
    }
    [[mLayer3d feature3Ds]removeFeature3D:circleFeature3D];
    circleFeature3D = nil;
}
-(void)clearTrackingLayer{
    [mSceneControl.scene.trackingLayer3D clear];
    [myPoint3DArrayList removeAllObjects];
    [geoTextStrList removeAllObjects];
    isEdit = true;
}
/**
 * 环绕飞行
 */
-(void)circleFly{
    if (circleFeature3D!=nil) {
        GeoPlacemark *geo = (GeoPlacemark *)[circleFeature3D geometry3D];
        GeoPoint3D *gp = (GeoPoint3D *)[geo geometry];
        GeoPoint3D * circlePoint = [[GeoPoint3D alloc]initWithX:gp.x Y:gp.y Z:gp.z+100];
        [mSceneControl.scene flyCircle:circlePoint SpeedRatio:2];
    }
}
/**
 * 停止环绕飞行
 */
-(void)stopCircleFly{
   
    GeoPoint3D * circlePoint = [[GeoPoint3D alloc]initWithX:1 Y:1 Z:1];
    [mSceneControl.scene flyCircle:circlePoint SpeedRatio:0];
    
}
/**
 * 点击弹出兴趣点
 *
 * @param pnt3d 地图上显示图标的位置
 * @param pnt   设置动画的位置
 */
-(void)showFavorite:(Point3D)pnt3d{
    [self addFavoritePoint:pnt3d Text:@""];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawFavoriteAtPoint:)]) {
        //[mSceneControl.scene globeToPixel:pnt3d];
        [self.delegate drawFavoriteAtPoint:pnt3d];
    }
}

-(void)setFavoriteText:(NSString*)text{
    if (favoriteFeature3D!=nil) {
        GeoPoint3D * geoPnt = (GeoPoint3D *)[(GeoPlacemark *)[favoriteFeature3D geometry3D] geometry];
        Point3D pnt3d = {geoPnt.x,geoPnt.y,geoPnt.z};
        [self addFavoritePoint:pnt3d Text:text];
    }
}

/**
 * 添加兴趣点标注
 *
 * @param pnt3d
 * @param text
 */

-(void)addFavoritePoint:(Point3D)pnt3d Text:(NSString*)text {
    if (mLayer3d!=nil) {
        
        
        GeoPoint3D *geopnt = [[GeoPoint3D alloc]initWithPoint3D:pnt3d];
        NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:@"resources" ofType:@"bundle"];
        NSString *strMarkerPath = [strBundlePath stringByAppendingString:@"/icon_green.png"];
        //NSString *strMarkerPath = @"assert.bundle/icon_green.png";
        GeoStyle3D *geostyle = [[GeoStyle3D alloc]init];
        
        [geostyle setMarkerFile:strMarkerPath];
        [geostyle setAltitudeMode:Absolute3D];
        [geostyle setMarkerSize:1000];
        [geopnt setStyle3D:geostyle];
        
        
        mSceneControl.isRender = NO;
        GeoPlacemark *geoPlacemark = [[GeoPlacemark alloc]initWithName:text andGeomentry:geopnt];
       // geoPlacemark.description = @"123456";
        TextStyle *textstyle = [[TextStyle alloc]init];
        [geoPlacemark setNameStyle:textstyle];
        
        if (favoriteFeature3D==nil) {
            favoriteFeature3D = [[mLayer3d feature3Ds]addGeometry3D:geoPlacemark];
        }else{
            [[mLayer3d feature3Ds]removeFeature3D:favoriteFeature3D];
            favoriteFeature3D = nil;
            favoriteFeature3D = [[mLayer3d feature3Ds]addGeometry3D:geoPlacemark];
            //[favoriteFeature3D setGeometry3D:geoPlacemark];
        }
        favoriteFeature3D.description = [NSString stringWithFormat:@"x=%.2f, y=%.2f, z=%.2f",geopnt.x,geopnt.y,geopnt.z];
        //[mSceneControl.scene.trackingLayer3D AddGeometry:geoPlacemark Tag:@"aaaa"];
        mSceneControl.isRender = YES;
        //[mSceneControl.scene refresh];
        isEdit = true;
    }
}

/**
 * 取消兴趣点
 */
-(void)favoriteCancel{
    if (favoriteFeature3D == nil ) {
        return;
    }
    //Layer3D* favoriteLayer3d = [mSceneControl.scene.layers getLayerWithName:@"Favorite"];//mSceneControl.getScene().getLayers().get();
    [[mLayer3d feature3Ds]removeFeature3D:favoriteFeature3D];
    favoriteFeature3D = nil;
    isEdit = false;
}

/**
 * 保存兴趣点
 */
-(void)saveFavoritePoint{
    if (favoriteFeature3D == nil ) {
        return;
    }
    Layer3D *layer3d = [mSceneControl.scene.layers getLayerWithName:@"NodeAnimation"];
    [[layer3d feature3Ds]addFeature3D:favoriteFeature3D];
    [[layer3d feature3Ds]toKMLFile:[kmlPath stringByAppendingString:kmlName]];
    [[mLayer3d feature3Ds]removeFeature3D:favoriteFeature3D];
    favoriteFeature3D = nil;
    geoline3d = nil;
    geoArea3d = nil;
    [mSceneControl.scene.trackingLayer3D clear];
    [myPoint3DArrayList removeAllObjects];
    [geoTextStrList removeAllObjects];
    isEdit = false;
    [self favoriteCancel];

}

-(void)reset{
    geoline3d = nil;
    geoArea3d = nil;
    [mSceneControl.scene.trackingLayer3D clear];
    labelOperate = NONE;
    [myPoint3DArrayList removeAllObjects];
    [geoTextStrList removeAllObjects];
    isEdit = false;
    [self favoriteCancel];
}

-(void)addKML{
    mSceneControl.isRender = false;
    if (mLayer3d==nil) {
        [self makeFilePath:kmlPath fileName:kmlName]; //(kmlPath, kmlName);
        [mSceneControl.scene.layers removeLayerWithName:@"NodeAnimation"];
        mLayer3d = [mSceneControl.scene.layers addLayerWith:[kmlPath stringByAppendingString:kmlName] Type:KML ToHead:true LayerName:@"NodeAnimation"];
    }
//    if (favoriteLayer3d==nil) {
//        [self makeFilePath:kmlPath fileName:@"Favorite.kml"];
//        [mSceneControl.scene.layers removeLayerWithName:@"Favorite"];
//        favoriteLayer3d = [mSceneControl.scene.layers addLayerWith:[kmlPath stringByAppendingString:@"Favorite.kml"] Type:KML ToHead:true LayerName:@"Favorite"];
//    }
     mSceneControl.isRender  = YES;
   // mSceneControl.getScene().getLayers().addLayerWith(kmlPath + kmlName, Layer3DType.KML, true,
                                        //              "NodeAnimation");
}

-(void)show{
    
    [self favoriteCancel];
    [mSceneControl.scene.trackingLayer3D clear];
    int count = myPoint3DArrayList.count;
    if (count == 0) {
        return;
    }
 //   GeoPoint3D* points = [[NSMutableArray alloc]initWithCapacity:1];
    switch (labelOperate) {
        case DRAWPOINT:
            for (GeoPoint3D* point3D in myPoint3DArrayList) {
                GeoStyle3D* geoPoint3dStyle = [[GeoStyle3D alloc]init];
                [geoPoint3dStyle setMarkerColor:[[Color alloc]initWithR:255 G:255 B:0]];//.setMarkerColor((new Color(255, 255, 0)));
                geoPoint3dStyle.altitudeMode = Absolute3D;///setAltitudeMode(AltitudeMode.ABSOLUTE);
                GeoPoint3D* geoPoint3D =  [[GeoPoint3D alloc]initWithGeoPoint3D:point3D];//new GeoPoint3D(point3D);
                geoPoint3D.style3D = geoPoint3dStyle;///.setStyle3D(geoPoint3dStyle);
                [mSceneControl.scene.trackingLayer3D AddGeometry:geoPoint3D Tag:@"point"]; //getScene().getTrackingLayer().add(geoPoint3D, "point");
            }
            return;
        case DRAWLINE:
//            points = new Point3D[count];
//            for (int i = 0; i < count; i++) {
//                points[i] = myPoint3DArrayList.get(i);
//            }
            [self drawLineByPoints:myPoint3DArrayList];
            break;
        case DRAWAREA:
//            points = new Point3D[count + 1];
//            int i = 0;
//            for (; i < count; i++) {
//                points[i] = myPoint3DArrayList.get(i);
//            }
           // [myPoint3DArrayList addObject:myPoint3DArrayList[0]];
            [self drawAreaByPoints:myPoint3DArrayList];
           // points[i] = points[0];
            // drawLineByPoints(points);
            break;
        case DRAWTEXT:
            for (int position = 0; position < myPoint3DArrayList.count; position++) {
                GeoPoint3D* point3D = myPoint3DArrayList[position]; //.get(position);
                
                TextPart3D* textPart3D= [[TextPart3D alloc]init];
                Point3D p3 = {point3D.x,point3D.y,point3D.z};
                [textPart3D setAnchorPoint:p3];// setAnchorPoint(point3D);
                textPart3D.text = geoTextStrList[position]; //setText(c.get(position));
                
                GeoText3D* geoText3D = [[GeoText3D alloc] initWithGeoText3D:textPart3D]; //new GeoText3D(textPart3D);
                [mSceneControl.scene.trackingLayer3D AddGeometry:geoText3D Tag:@"text"]; //getScene().getTrackingLayer().add(geoText3D, "text");
                
            }
            break;
        case NONE:
            break;
    }
}
-(void)drawAreaByPoints:(NSArray*)points{
    if (points.count == 0) {
        return;
    }
    Point3Ds* point3ds = [[Point3Ds alloc]init];
    for(GeoPoint3D* geoP in points){
        Point3D p3 = {geoP.x,geoP.y,geoP.z};
        NSValue *value = [NSValue valueWithBytes:&p3 objCType:@encode(Point3D)];
        [point3ds addPoint3D:p3];
        //[m_point3DArray addObject:value];
    }
    
    if (points.count > 1) {
        GeoStyle3D* lineStyle3D = [[GeoStyle3D alloc]init];
        lineStyle3D.fillForeColor = [[Color alloc] initWithR:140 G:224 B:80];// .setLineColor(new Color(255, 255, 0));
        lineStyle3D.lineColor = [[Color alloc] initWithR:18 G:183 B:245];
        lineStyle3D.altitudeMode = Absolute3D; // setAltitudeMode(AltitudeMode.ABSOLUTE);
        lineStyle3D.lineWidth = 5;// setLineWidth(5);
        geoArea3d = [[GeoRegion3D alloc] initWithPoint3Ds:point3ds];
        geoArea3d.style3D = lineStyle3D;// setStyle3D(lineStyle3D);
        [mSceneControl.scene.trackingLayer3D AddGeometry:geoArea3d Tag:@"geoArea"]; // getScene().getTrackingLayer().add(geoline3d, "geoline");
    }
}
-(void)drawLineByPoints:(NSArray*)points{
    if (points.count == 0) {
        return;
    }
     Point3Ds* point3ds = [[Point3Ds alloc]init];
    for(GeoPoint3D* geoP in points){
        Point3D p3 = {geoP.x,geoP.y,geoP.z};
        NSValue *value = [NSValue valueWithBytes:&p3 objCType:@encode(Point3D)];
        [point3ds addPoint3D:p3];
        //[m_point3DArray addObject:value];
    }
   
    if (points.count > 1) {
        GeoStyle3D* lineStyle3D = [[GeoStyle3D alloc]init];
        lineStyle3D.lineColor = [[Color alloc] initWithR:18 G:183 B:245];// .setLineColor(new Color(255, 255, 0));
        lineStyle3D.altitudeMode = Absolute3D; // setAltitudeMode(AltitudeMode.ABSOLUTE);
        lineStyle3D.lineWidth = 15;// setLineWidth(5);
        geoline3d = [[GeoLine3D alloc] initWithPoint3Ds:point3ds];
        geoline3d.style3D = lineStyle3D;// setStyle3D(lineStyle3D);
        [mSceneControl.scene.trackingLayer3D AddGeometry:geoline3d Tag:@"geoline"]; // getScene().getTrackingLayer().add(geoline3d, "geoline");
    }
}

-(void)makeFilePath:(NSString*)filePath fileName:(NSString*)fileName{
    
    
     [JSSystemUtil createFileDirectories:filePath];
     NSString*file = [filePath stringByAppendingFormat:@"%@",fileName];
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDir];
    
    
    if(!isDirExist){
        BOOL b = [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
        if(!b){
            NSLog(@"%@",@"dd");
        }
    }
   
}

-(BOOL)deleteSingleFile:(NSString*)filePathName{
    NSError* error;
    BOOL b =[[NSFileManager defaultManager] removeItemAtPath:filePathName error:&error];
    NSLog(@"%d",b);
    return b;
}

-(void)closePage{
    [self reset];
    [mSceneControl.scene.layers removeLayerWithName:@"NodeAnimation"];
    mLayer3d = nil;
    [mSceneControl.scene.layers removeLayerWithName:@"Favorite"];
   // favoriteLayer3d = nil;
    mSceneControl = nil;
}

@end
