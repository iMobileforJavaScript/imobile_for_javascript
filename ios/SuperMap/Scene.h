//
//  Scene.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Point3D.h"
#import "Rect2D.h"
#import "Camera.h"
#import "Workspace.h"
#import "PixelToGlobeMode.h"
#import "MultiViewportMode.h"

@class Layer3D,Layer3Ds,FlyManager,Workspace,TerrainLayers,TrackingLayer3D,GeoPoint3D,GlobalImage, LookAt;

/** 三维场景类。
 <p>三维场景的主体是一个模拟地球的三维球体（以半径为6378137 米的球体来模拟地球），该球体具有地理参考，球体上的点采用经纬度进行定位，并且可以通过三维场景提供的球体上的经纬网格，方便地浏览；同时，使用全球的遥感影像图作为背景覆盖在球体表面，增强三维球体模拟的逼真性；除此之外，三维场景还模拟了地球所处的环境，包括：宇宙的星空，地球的大气环境，地球表面的雾环境等。三维场景还提供了相机的设置，相机可以用来控制对球体的观测角度、方位和观测范围，从而以不同的视角呈现球体的不同部位。
 */
@interface Scene : NSObject {
    NSString *_name;
    Layer3Ds *_layer3Ds;
    TerrainLayers *_terrainLayers;
    TrackingLayer3D *_trackingLayer3D;
    FlyManager *_flyManager;
    Camera camera;
    NSString *_url;
    Workspace* _workspace;
    GlobalImage *_globalImage;
}

 /// 返回或设置场景名称。
@property(nonatomic,readonly)NSString *name;

 /// 返回当前场景的url路径。
@property(nonatomic,readonly)NSString *url;

/// 返回当前场景的相机。
@property(nonatomic)Camera camera;

/// 返回当前场景的第一人称相机。
@property(nonatomic)Camera firstPersonCamera;

/// 返回或设置当前场景的lookat相机
@property (nonatomic, strong) LookAt *lookAt;

 /// 返回三维场景的飞行管理对象。
@property(nonatomic,readonly)FlyManager *flyManager;

 /// 返回 3D 图层集合对象。
@property(nonatomic,readonly)Layer3Ds *layers;

 /// 返回 3D 跟踪图层对象
@property(nonatomic,readonly)TrackingLayer3D *trackingLayer3D;

 /// 返回 3D 地形图层集合对象。
@property (nonatomic,readonly)TerrainLayers *terrainLayers;

/// 设置或返回三维场景对应的工作空间对象。
@property (strong,nonatomic) Workspace* workspace;

/// 获取或设置地形是否有裙边
@property (assign, nonatomic, getter=isCreateSkirt) BOOL createSkirt;

/// 返回全球底图对象
@property (nonatomic, readonly) GlobalImage *globalImage;

/// 获取或设置下行俯仰
@property (assign, nonatomic, getter=isZoomFlyPitching) BOOL zoomFlyPitching;

/// 获取或设置多视口模式
@property (assign, nonatomic) RealspaceMultiViewportMode multiViewportMode;

/// 获取或设置大气层可见性
@property (assign, nonatomic, getter=isAtmosphereVisible) BOOL atmosphereVisible;

///开启文字避让
@property (assign, nonatomic, getter=isOverlapDisplayed) BOOL overlapDisplayed;


-(double)GetFPS;

/**@brief 打开指定名称的三维场景。
 @param  sceneName 三维场景名称。
 <p>注：只支持打开通过iDesktop 7C版本生成的只包含iOS场景缓存的三维场景。使用此方法必须配置三维许可，否则打开失败。
 */
-(BOOL) open:(NSString*) sceneName;

 ///关闭三维场景。
- (void)close;

///释放该对象所占用的资源。
- (void)dispose;

/**@brief 根据合适的图层观察尺度来显示场景。
 @param  layer3D 需要显示的图层。
 */
- (void)ensureVisible:(Layer3D *)layer3D;
/**@brief 通过iServer数据服务打开三维场景。
 @param  url iServer数据服务的URL(如：Http://118.186.246.138:8091/iserver/services/realspace-Scene/rest/realspace)。
 @param  sceneName 指定的三维场景名称。
 @param  password 打开场景的密码。当打开在线场景时，此参数应设置为nil；若将下载完成的数据拷贝到UserData.bundle中进行打开时，此参数应设置为发布服务时设置的密码，如果发布服务时没有进行密码修改，则默认密码为“supermap”。
 @return  打开成功返回 true，否则返回 false。
 */
- (BOOL)openSceneWithUrl:(NSString *)url Name:(NSString *)sceneName Password:(NSString *)password;

//打开带有token令牌加密认证的数据服务
-(BOOL)openTokenServiceWithUrl:(NSString *)iserverUrl Name:(NSString *)sceneName Token:(NSString *)token;

/**@brief 通过Online数据私有服务打开三维场景(需登陆后使用)。
 @param  url Online数据私有服务的URL(如：http://118.186.246.138:8091/iserver/services/realspace-Scene/rest/realspace)。
 @param  sceneName 指定的三维场景名称。
 @param  completionHandler 打开三维场景之后的回调, ture表示打开成功, false表示打开失败。
 */
- (void)openPrivateSceneWithUrl:(NSString *)url name:(NSString *)sceneName completionHandler:(void(^)(BOOL isOpen))completionHandler;

/**@brief 飞行到指定的三维点几何对象。
 @param  point3D 指定的三维点几何对象。
 */
- (void)flyToPoint:(Point3D)point3D;

/**@brief 飞行到指定相机位置。
 @param  camera 指定相机位置。
 */
- (void)flyToCamera:(Camera)camera;

-(void)flyToCamera:(Camera)camera milliseconds:(NSInteger)time isDirect:(BOOL)bdirect;

-(void)flyToLookAt:(LookAt *)lookat milliseconds:(NSInteger)time isDirect:(BOOL)bdirect;

/**@brief 飞行到指定的经纬度范围。
 @param  bounds 指定的经纬度范围。
 */
- (void)flyToBounds:(Rect2D *)bounds;

/**@brief 围绕指定地点旋转飞行。
 @param  point3D 指定的三维点几何对象。
 @param  speedRatio 基准飞行速度的倍数，默认为1   
 */
- (void)flyCircle:(GeoPoint3D*)point3D SpeedRatio:(NSInteger)speedRatio;

 ///刷新三维场景。
- (void)refresh;

 ///全幅显示三维球。
- (void)viewEntire;

 ///缩放
- (void)zoom:(double)ratio;

 ///平移
- (void)panWithOffsetLongitude:(double)offsetLongitude offsetLatitude:(double)offsetLatitude;

 ///根据给定的角度值，对三维场景进行倾斜，从而从不同角度观察三维场景中的对象
- (void)pitch:(double)ratio;

 ///将三维场景绕视点进行一定角度的旋转
- (void)rollEye:(double)ratio;

 ///停止相机惯性
- (void)stopCameraInteria;

/**@brief 屏幕坐标转地理坐标。
 @param  point 指定的屏幕坐标。   
 */
- (Point3D)pixelToGlobe:(CGPoint)point;

/**@brief 屏幕坐标转地理坐标。
 @param  point 指定的屏幕坐标。  
 @param  mode 判断所选择点位于模型之上或是地形之上
 */
- (Point3D)pixelToGlobeWith:(CGPoint)point andPixelToGlobeMode:(PixelToGlobeMode) mode;

/**@brief 地理坐标转屏幕坐标。
 @param  point 指定的地理坐标。
 */
- (CGPoint)globeToPixel:(Point3D)point;

@end
