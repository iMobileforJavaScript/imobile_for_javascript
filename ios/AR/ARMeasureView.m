//
//  ARRangingView.m
//  SuperMapAR
//
//  Created by wnmng on 2019/11/19.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import "ARMeasureView.h"
#import "LineController.h"
#import "PlaneNode.h"

@interface ARMeasureView()<ARSCNViewDelegate, ARSessionDelegate>{
    AR_SESSION_MODE m_SessionMode;
    BOOL m_bSessionStart;
    
    SCNNode *m_FocusNode;
    
    UILabel *m_SpaceLab;
    UILabel *m_TotalLab;
    UILabel *m_DistanceLab;
    
    SCNVector3 m_VectorCamera;
    SCNVector3 m_VectorStart;
    SCNVector3 m_VectorEnd;
    //量算中的线
    LineController *m_lineCon;
    double m_dCurrentLineLen;
    double m_dTotalLineLen;
    double m_dDistance;
    BOOL m_isMeasuring;
    NSMutableDictionary<NSUUID *, PlaneNode *> *m_planeArr;
    NSMutableArray *m_arrPlanePoint;
    NSMutableArray *m_arrLines;
    
    SCNNode *m_startNode;
    SCNNode *m_endNode;

    UIImageView *m_crossMark;
    
    ARFlagType m_flagType;
    
    NSString* m_language;
}


@end

@implementation ARMeasureView
@synthesize arRangingDelegate;

-(id)init{
    if (self = [super init]) {
        [self initialise];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialise];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withLanguage:(NSString*)language{
    if (self = [super initWithFrame:frame]) {
        [self initialise];
    }
    m_language=language;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialise];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    m_SpaceLab.frame = CGRectMake(self.frame.size.width*0.5-100,self.frame.size.height*0.5+15,200,30);
    [m_crossMark setCenter:self.center];
}

-(BOOL)isChinese{
    if(!m_language){
        return true;
    }
    return [m_language isEqualToString:@"CN"];
}

-(void)initialise{
    m_SessionMode = AR_MODE_RANGING;
    m_bSessionStart = false;
    
    m_arrLines = [[NSMutableArray alloc]init];
    m_arrPlanePoint = [[NSMutableArray alloc]init];
    
    m_isMeasuring = NO;
    m_planeArr = [NSMutableDictionary dictionary];

    
    self.delegate = self;
    [self setShowsStatistics:NO];//是否显示fps 或 timing等信息
    [self setDebugOptions:ARSCNDebugOptionShowFeaturePoints]; //显示平面检测到的特征点（feature points）
    [self setAutoenablesDefaultLighting:YES];
    //[self.view addSubview:self.sceneView];
    
    SCNScene *scene = [[SCNScene alloc] init]; //创建场景
    
    m_flagType = AR_RED_FLAG;
    
    m_FocusNode = [[SCNNode alloc]init];
    m_FocusNode.position = SCNVector3Make(0, 0.01, -0.5);
    [m_FocusNode addChildNode:[self flagNode]];
    [scene.rootNode addChildNode:m_FocusNode];
    m_FocusNode.hidden = true;
    
    m_startNode = [[SCNNode alloc]init];
    [m_startNode addChildNode:[self flagNode]];
    [scene.rootNode addChildNode:m_startNode];
    m_startNode.hidden = true;
    
    m_endNode = [[SCNNode alloc]init];
    [m_endNode addChildNode:[self flagNode]];
    [scene.rootNode addChildNode:m_endNode];
    m_endNode.hidden = true;
    
    self.scene = scene;
    
    
    
    //m_SpaceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 30)];
    m_SpaceLab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5-100,self.frame.size.height*0.5+15,200,30)];
    //[m_SpaceLab setBackgroundColor:[UIColor lightGrayColor]];
    [m_SpaceLab setTextColor:[UIColor whiteColor]];
    [m_SpaceLab setTextAlignment:NSTextAlignmentCenter];
    [m_SpaceLab setText:[self isChinese]?@"初始化中":@"init"];
    [m_SpaceLab.layer setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor];
    [m_SpaceLab.layer setCornerRadius:15];
    //[self.view addSubview:m_SpaceLab];
    [self addSubview:m_SpaceLab];
    
   // m_crossMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crossMark"]];
    NSString * strResPath = [[[NSBundle mainBundle]pathForResource:@"SuperMapAR" ofType:@"bundle"] stringByAppendingFormat:@"/crossMark.png"];
    m_crossMark = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:strResPath] ];
    
    [m_crossMark setFrame:CGRectMake(0,0, 20, 20)];
    //[crossMark setCenter:self.view.center];
    [m_crossMark setCenter:self.center];
    //[self.view addSubview:crossMark];
    [self addSubview:m_crossMark];
    
    
//    m_TotalLab = [[UILabel alloc] initWithFrame:CGRectMake(50,30,200,30)];
    m_TotalLab = [[UILabel alloc] initWithFrame:CGRectMake(50,150,200,30)];
    [m_TotalLab setTextColor:[UIColor whiteColor]];
    [m_TotalLab setTextAlignment:NSTextAlignmentLeft];
    NSString* totalLength=[self isChinese]?@"总长度":@"total length";
    [m_TotalLab setText:[NSString stringWithFormat:@" %@： %.2f m",totalLength,m_dTotalLineLen]];
    [m_TotalLab.layer setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor];
    [m_TotalLab.layer setCornerRadius:5];
    //[self.view addSubview:m_SpaceLab];
    [self addSubview:m_TotalLab];
    [m_TotalLab setHidden:YES];
    
//    m_DistanceLab = [[UILabel alloc] initWithFrame:CGRectMake(50,30+30+15,200,30)];
    m_DistanceLab = [[UILabel alloc] initWithFrame:CGRectMake(50,150+30+15,200,30)];
    [m_DistanceLab setTextColor:[UIColor whiteColor]];
    [m_DistanceLab setTextAlignment:NSTextAlignmentLeft];
    [m_DistanceLab setText:[NSString stringWithFormat:@" %@： %.2f m",[self isChinese]?@"视点距离":@"view distance",0.0]];
    [m_DistanceLab.layer setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2].CGColor];
    [m_DistanceLab.layer setCornerRadius:5];
    //[self.view addSubview:m_SpaceLab];
    [self addSubview:m_DistanceLab];
    [m_DistanceLab setHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:tap];
    
    m_dCurrentLineLen = 0;
    m_dTotalLineLen = 0;
    m_dDistance = 0;
    m_VectorCamera = SCNVector3Zero;
}

-(SCNVector3)currentDivicePosition{
    return m_VectorCamera;
}
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self captureRangingNode];
}


-(void)startARSession{
    [self startARSessionWithMode:AR_MODE_RANGING];
}

-(void)startARSessionWithMode:(AR_SESSION_MODE)mode{
    if (!m_bSessionStart) {
        //阻止自动锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        ARWorldTrackingConfiguration *confige = [ARWorldTrackingConfiguration new];
        // 明确表示需要追踪水平面。设置后 scene 被检测到时就会调用 ARSCNViewDelegate 方法
        switch (mode) {
            case AR_MODE_RANGING:
            {
                [confige setPlaneDetection:ARPlaneDetectionHorizontal];
            }
                break;
            case AR_MODE_INDOORPOSITIONING:
            {
                [confige setPlaneDetection:ARPlaneDetectionNone];
                m_crossMark.hidden=true;
                m_SpaceLab.hidden=true;
                m_TotalLab.hidden=true;
                m_DistanceLab.hidden=true;
            }
                break;
            default:
            {
                [confige setPlaneDetection:ARPlaneDetectionHorizontal];
            }
                break;
        }
        //[confige setPlaneDetection:ARPlaneDetectionHorizontal | ARPlaneDetectionVertical];
        [self.session runWithConfiguration:confige];
        m_SessionMode = mode;
        m_bSessionStart = true;
    }
}

-(void)stopARSession{
    if(m_bSessionStart){
        [self clearARSession];
        
        m_FocusNode.hidden=true;
        
        m_crossMark.hidden=true;
        m_SpaceLab.hidden=true;
        m_TotalLab.hidden=true;
        m_DistanceLab.hidden=true;
        
        //阻止自动锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        [self.session pause];
        m_SessionMode = AR_MODE_RANGING;
        m_bSessionStart = false;
    }
}

-(void)dealloc{
    [self stopARSession];
}

-(void)captureRangingNode{
    if (m_bSessionStart && m_SessionMode==AR_MODE_RANGING) {
        if (m_planeArr.count == 0) {
//            [m_SpaceLab setText:@"没有找到平面"];
            [m_SpaceLab setText:[self isChinese]?@"没有找到平面":@"not find plane"];
            return;
        }
        if (!m_isMeasuring) {
            m_isMeasuring = YES;
            m_VectorStart = SCNVector3Zero;
            m_VectorEnd = SCNVector3Zero;
            
            [m_arrPlanePoint removeAllObjects];
            for (int i=0; i<m_arrLines.count; i++) {
                [[m_arrLines objectAtIndex:i] removeLine];
            }
            [m_arrLines removeAllObjects];
            if (m_lineCon) {
                [m_lineCon removeLine];
            }
            
            [self setTotal:0];
            [self setCurrent:0];
            
            m_startNode.hidden = true;
            m_endNode.hidden = true;
        }
        else
        {
            [m_arrLines addObject:m_lineCon];
            [m_arrPlanePoint addObject:@[@(m_VectorStart.x),@(m_VectorStart.y),@(m_VectorStart.z)]];
            
            [self setTotal:m_dTotalLineLen+m_dCurrentLineLen];
            [self setCurrent:0];
            
            m_VectorStart = m_VectorEnd;
            m_lineCon = [[LineController alloc] initWithSceneView:self StartVector:m_VectorStart LengthUnit:Enum_LengthUnit_meter];
            
        }
    }
    
}

-(void)undo{
    if (m_bSessionStart && m_SessionMode==AR_MODE_RANGING && m_isMeasuring ) {
        
        if(m_arrLines.count>0){
        NSArray*arrVector = [m_arrPlanePoint lastObject];
        
        SCNVector3 vectorTemp;
        vectorTemp.x = [[arrVector objectAtIndex:0] doubleValue];
        vectorTemp.y = [[arrVector objectAtIndex:1] doubleValue];
        vectorTemp.z = [[arrVector objectAtIndex:2] doubleValue];
        
        [m_arrPlanePoint removeLastObject];
        
        [m_lineCon removeLine];
        m_lineCon = [m_arrLines lastObject];
        [m_arrLines removeLastObject];
        
        [self setTotal: m_dTotalLineLen - [m_lineCon getDistanceWithVector:m_VectorStart]];
        
        m_VectorStart = vectorTemp;
        
        [self setCurrent:[m_lineCon updateLineContentWithVector:m_VectorEnd]];
        }else if(m_arrLines.count==0){
            [self endRanging];
            [self clearARSession];
        }
    }
}

-(void)clearARSession{
    m_isMeasuring = NO;
    [m_arrPlanePoint removeAllObjects];
    for (int i=0; i<m_arrLines.count; i++) {
        [[m_arrLines objectAtIndex:i] removeLine];
    }
    [m_arrLines removeAllObjects];
    if (m_lineCon) {
        [m_lineCon removeLine];
    }
    
    [self setCurrent:0];
    [self setTotal:0];

    m_startNode.hidden=true;
    m_endNode.hidden=true;
}

-(NSArray*)endRanging{
    NSArray*arrRes = nil;
    
    if (m_bSessionStart && m_SessionMode==AR_MODE_RANGING && m_isMeasuring) {
        
        m_isMeasuring = NO;
        
        m_endNode.hidden=false;
        m_endNode.position = SCNVector3Make(m_VectorStart.x, m_VectorStart.y, m_VectorStart.z);
        
        if (m_lineCon!=nil) {
            [m_lineCon removeLine];
            m_lineCon = nil;
        }

        [self setCurrent:0];
        
        m_VectorStart = m_VectorEnd = SCNVector3Zero;
        m_lineCon = nil;
        
        arrRes= [NSArray arrayWithArray:m_arrPlanePoint];
    }
    
    return arrRes;
}

- (void)scanWorld
{
    @try {
        if (m_bSessionStart) {
            m_VectorCamera = [SCNVector3Tool positionTranform: self.session.currentFrame.camera.transform];
            if( m_SessionMode==AR_MODE_RANGING){
                SCNVector3 worldPostion = SCNVector3Zero;
                //中心点和平面交点 和特征点相交
                //worldPostion = [self.sceneView worldVectorFromPosition:self.view.center];
                {
                    NSArray<ARHitTestResult *> * planeHitTestResult = [self hitTest:self.center types:ARHitTestResultTypeFeaturePoint];
                    if (planeHitTestResult.count != 0 && planeHitTestResult.firstObject) {
                        ARHitTestResult *result = planeHitTestResult.firstObject;
                        worldPostion = [SCNVector3Tool positionTranform:result.worldTransform];
                    }
                    
                }
                if ([SCNVector3Tool isEqualBothSCNVector3WithLeft:worldPostion Right:SCNVector3Zero]) {
                    [m_SpaceLab setText:[self isChinese]?@"没有找到平面":@"not find plane"];
                    m_FocusNode.hidden=true;
                    return;
                }
                if (m_planeArr.count == 0) {
                    [m_SpaceLab setText:[self isChinese]?@"没有找到平面":@"not find plane"];
                    m_FocusNode.hidden=true;
                    return;
                }
                else
                {
                    //中心点和平面交点 和带范围平面相交
                    //worldPostion = [self.sceneView planeExtentFromPosition:self.view.center];
                    {
                        NSArray<ARHitTestResult *> * planeHitTestResult = [self hitTest:self.center types:ARHitTestResultTypeExistingPlaneUsingExtent];
                        if (planeHitTestResult.count != 0 && planeHitTestResult.firstObject) {
                            ARHitTestResult *result = planeHitTestResult.firstObject;
                            worldPostion = [SCNVector3Tool positionTranform:result.worldTransform];
                        }else{
                            worldPostion = SCNVector3Zero;
                        }
                        
                    }
                    if (!m_isMeasuring)
                    {
                        [m_SpaceLab setText:[self isChinese]?@"可以开始测量":@"can start measure"];
                    }
                    //NSLog(@"worldPostion = %@", [NSValue valueWithSCNVector3:worldPostion]);
                    if ([SCNVector3Tool isEqualBothSCNVector3WithLeft:worldPostion Right:SCNVector3Zero]) {
                        [m_SpaceLab setText:[self isChinese]?@"焦点不在平面内":@"focus not in plane"];
                        m_FocusNode.hidden=true;
                        return;
                    }
                }
                m_FocusNode.hidden = false;
                [m_FocusNode setPosition:SCNVector3Make(worldPostion.x, worldPostion.y, worldPostion.z)];
                if (m_isMeasuring)
                {
                    if ([SCNVector3Tool isEqualBothSCNVector3WithLeft:m_VectorStart Right:SCNVector3Zero]) {
                        //设置第一个起始量算点
                        m_VectorStart = worldPostion;
                        m_lineCon = [[LineController alloc] initWithSceneView:self StartVector:m_VectorStart LengthUnit:Enum_LengthUnit_meter];
                        m_startNode.hidden=false;
                        m_startNode.position = SCNVector3Make(m_VectorStart.x, m_VectorStart.y, m_VectorStart.z);
                        [self.scene.rootNode addChildNode:m_startNode];
                    }
                    m_VectorEnd = worldPostion;
                    [self setCurrent: [m_lineCon updateLineContentWithVector:m_VectorEnd]];
                }
                
                double distance = [SCNVector3Tool distanceWithVector:worldPostion StartVector:m_VectorCamera];
                [self setDistance:distance];
            }
        }
    } @catch (NSException *exception) {
        
    }
}

#pragma mark - 界面更新问题
-(BOOL)isTotalLengthLabelEnable{
    return !m_TotalLab.hidden;
}
-(void)setIsTotalLengthLabelEnable:(BOOL)isTotalLengthLabelEnable{
    m_TotalLab.hidden = !isTotalLengthLabelEnable;
}
-(BOOL)isCurrentLengthLabelEnable{
    return !m_SpaceLab.hidden;
}
-(void)setIsCurrentLengthLabelEnable:(BOOL)isCurrentLengthLabelEnable{
    m_SpaceLab.hidden = !isCurrentLengthLabelEnable;
}
-(BOOL)isIsViewPointDistanceLabelEnable{
    return  !m_DistanceLab.hidden;
}
-(void)setIsViewPointDistanceLabelEnable:(BOOL)isViewPointDistanceLabelEnable{
    m_DistanceLab.hidden = !isViewPointDistanceLabelEnable;
}

-(double)totalLengthOfSides{
    return m_dTotalLineLen;
}

-(double)viewPointDistanceToSurface{
    return m_dDistance;
}

-(double)currentToLastPointDistance{
    return m_dCurrentLineLen;
}

-(void)setCurrent:(double)dLen{
    if (m_dCurrentLineLen!=dLen) {
        m_dCurrentLineLen = dLen;
        [m_SpaceLab setText:[NSString stringWithFormat:@" %@： %.2f m",[self isChinese]?@"当前长度":@"current length",m_dCurrentLineLen]];
        if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onCurrentToLastPointDistanceChange:)]) {
            [arRangingDelegate onCurrentToLastPointDistanceChange:m_dCurrentLineLen];
        }
    }
}

-(void)setTotal:(double)dLen{
    if (m_dTotalLineLen!=dLen) {
        m_dTotalLineLen = dLen;
        [m_TotalLab setText:[NSString stringWithFormat:@" %@： %.2f m",[self isChinese]?@"总长度":@"total length",m_dTotalLineLen]];
        if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onTotalLengthOfSidesChange:)]) {
            [arRangingDelegate onTotalLengthOfSidesChange:m_dTotalLineLen];
        }
        [m_TotalLab setHidden:NO];
    }
}

-(void)setDistance:(double)dLen{
    if (m_dDistance!=dLen) {
        m_dDistance = dLen;
        [m_DistanceLab setText:[NSString stringWithFormat:@" %@： %.2f m",[self isChinese]?@"视点距离":@"view distance",m_dDistance]];
        if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onViewPointDistanceToSurfaceChange:)]) {
            [arRangingDelegate onViewPointDistanceToSurfaceChange:m_dDistance];
        }
        [m_DistanceLab setHidden:NO];
    }
}

-(ARFlagType)flagType{
    return m_flagType;
}

-(void)setFlagType:(ARFlagType)flagType{
    if (m_flagType!=flagType) {
        m_flagType = flagType;
        
        [[m_FocusNode.childNodes objectAtIndex:0] removeFromParentNode];
        [m_FocusNode addChildNode:[self flagNode]];
        
        [[m_startNode.childNodes objectAtIndex:0] removeFromParentNode];
        [m_startNode addChildNode:[self flagNode]];
        
        [[m_endNode.childNodes objectAtIndex:0] removeFromParentNode];
        [m_endNode addChildNode:[self flagNode]];
    }
}

-(SCNNode*)flagNode{
    SCNReferenceNode *customNode = nil;
    switch (m_flagType) {
        case AR_RED_FLAG:
        {
            NSString * strResPath = [[[NSBundle mainBundle]pathForResource:@"SuperMapAR" ofType:@"bundle"] stringByAppendingFormat:@"/flag2/1.obj"];//@"/obj/pin_bowling.obj"];
            customNode = [[SCNReferenceNode alloc]initWithURL:[NSURL fileURLWithPath:strResPath]];
            [customNode setScale: SCNVector3Make(0.0005, 0.0005, 0.0005)];
            [customNode load];
        }
            break;
            
        case AR_PIN_BOWLING:
        {
            NSString * strResPath = [[[NSBundle mainBundle]pathForResource:@"SuperMapAR" ofType:@"bundle"] stringByAppendingFormat:@"/obj/pin_bowling.scn"];
            customNode = [[SCNReferenceNode alloc]initWithURL:[NSURL fileURLWithPath:strResPath]];
            [customNode setScale: SCNVector3Make(0.0005, 0.0005, 0.0005)];
            [customNode load];
        }
        default:
            break;
    }
    return customNode;
}

#pragma mark - ARSCNViewDelegate

/*
 // Override to create and configure nodes for anchors added to the view's session.
 - (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
 SCNNode *node = [SCNNode new];
 
 // Add geometry to the node...
 
 return node;
 }
 */
//检测到平面
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    SCNVector3 extent = [SCNVector3Tool positionExtent:((ARPlaneAnchor *)anchor).extent];
    if ([SCNVector3Tool isEqualBothSCNVector3WithLeft:extent Right:SCNVector3Zero]) {
        return;
    }
    PlaneNode *planeNode = [[PlaneNode alloc] initWithPlaneAnchor:(ARPlaneAnchor *)anchor];//创建节点
    [node addChildNode:planeNode];
    if ([m_planeArr count]==0) {
        if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onARRuntimeStatusChange:)]) {
            [arRangingDelegate onARRuntimeStatusChange:AR_SEARCHING_SURFACES_SUCCEED];
        }
    }
    [m_planeArr setObject:planeNode forKey:anchor.identifier];
}
//更新平面
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    SCNVector3 extent = [SCNVector3Tool positionExtent:((ARPlaneAnchor *)anchor).extent];
    if ([SCNVector3Tool isEqualBothSCNVector3WithLeft:extent Right:SCNVector3Zero]) {
        return;
    }
    
    PlaneNode *planeNode = [m_planeArr objectForKey:anchor.identifier];
    [planeNode updateNodeWithPlaneAnchor:(ARPlaneAnchor *)anchor];
}
//平面消失
- (void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    PlaneNode *planeNode = [m_planeArr objectForKey:anchor.identifier];
    [planeNode removeFromParentNode];
    [m_planeArr removeObjectForKey:anchor.identifier];
    if ([m_planeArr count]==0) {
        if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onARRuntimeStatusChange:)]) {
            [arRangingDelegate onARRuntimeStatusChange:AR_SEARCHING_SURFACES];
        }
    }
}
//场景更新（每秒x次）
- (void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time
{
    [self performSelectorOnMainThread:@selector(scanWorld) withObject:nil waitUntilDone:NO];
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    NSLog(@"Present an error message to the user error = %@",error);
//    [m_SpaceLab setText:@"didFailWithError 错误"];
    [m_SpaceLab setText:[NSString stringWithFormat:@"didFailWithError %@",[self isChinese]?@"错误":@"error"]];
    
    if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onARRuntimeStatusChange:)]) {
        [arRangingDelegate onARRuntimeStatusChange:AR_INITIAL_FAILED];
    }
}

- (void)sessionWasInterrupted:(ARSession *)session {
    NSLog(@"Inform the user that the session has been interrupted, for example, by presenting an overlay");
//    [m_SpaceLab setText:@"sessionWasInterrupted 中断"];
    [m_SpaceLab setText:[NSString stringWithFormat:@"sessionWasInterrupted %@",[self isChinese]?@"中断":@"interrupt"]];
    if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onARRuntimeStatusChange:)]) {
        [arRangingDelegate onARRuntimeStatusChange:AR_RUNTIME_TRACKING_PAUSED];
    }
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    NSLog(@"Reset tracking and/or remove existing anchors if consistent tracking is required");
//    [m_SpaceLab setText:@"sessionInterruptionEnded 结束"];
    [m_SpaceLab setText:[NSString stringWithFormat:@"sessionInterruptionEnded %@",[self isChinese]?@"结束":@"end"]];
    if (arRangingDelegate!=nil && [arRangingDelegate respondsToSelector:@selector(onARRuntimeStatusChange:)]) {
        [arRangingDelegate onARRuntimeStatusChange:AR_RUNTIME_TRACKING_STOPPED];
    }
}


@end
