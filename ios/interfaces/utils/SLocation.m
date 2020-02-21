//
//  SLocation.m
//  Supermap
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "SLocation.h"
static SLocation* m_slocation = nil;

@interface locationChangedDelegate :NSObject<AMapLocationManagerDelegate>
{
//    LocationManagePlugin* LocationPlugin;
//    GPSData* mGPSData;
}
@property(nonatomic,strong)GPSData* gpsData;
@property(nonatomic,strong)AMapLocationManager* Plugin;
@end
@implementation locationChangedDelegate
-(id)init{
    
    if(self = [super init]){
        [AMapServices sharedServices].apiKey = @"cbeda0d0a5c465620be7bd6cccbf39ce";
        _Plugin = [[AMapLocationManager alloc]init];
        _Plugin.delegate = self;
        //设置不允许系统暂停定位
        [_Plugin setPausesLocationUpdatesAutomatically:NO];
        //设置允许在后台定位
        [_Plugin setAllowsBackgroundLocationUpdates:YES];
        //设置允许连续定位逆地理
        [_Plugin setLocatingWithReGeocode:YES];
    }
    return self;
}
#pragma mark GPS
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    _gpsData = [[GPSData alloc]init];
    _gpsData.dLatitude = location.coordinate.latitude;
    _gpsData.dLongitude = location.coordinate.longitude;
    
    //获取到定位信息，更新annotation
//    if (self.pointAnnotaiton == nil)
//    {
//        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
//        [self.pointAnnotaiton setCoordinate:location.coordinate];
//
//        [self.mapView addAnnotation:self.pointAnnotaiton];
//    }
//
//    [self.pointAnnotaiton setCoordinate:location.coordinate];
//
//    [self.mapView setCenterCoordinate:location.coordinate];
//    [self.mapView setZoomLevel:15.1 animated:NO];
}
@end

@implementation SLocation
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents{
    return @[LOCATION_SEARCH_DEVICE];
}

static NSString* deviceName = @"local";
static int listenPort = 16555;
static int sock;
static int listenSock;
static BOOL inGPSInited = NO;
static BOOL isOpenExternalGPS = NO;
static BOOL isSerachingDevice = NO;
static locationChangedDelegate* LocationPlugin = nil;
static GPSData * externalGPS;

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_slocation = [[self alloc]init];
    });
    return m_slocation;
}

+ (id)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_slocation = [super allocWithZone:zone];
    });
    return m_slocation;
}

RCT_REMAP_METHOD(openGPS, openWithResolver:(RCTPromiseResolveBlock) resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        [[SLocation sharedInstance] openGPS];
        resolve(@YES);
    } @catch(NSException* exception) {
        reject(@"SLocation", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(closeGPS, closeWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        [[SLocation sharedInstance] closeGPS];
        resolve(@YES);
    } @catch(NSException* exception) {
        reject(@"SLocation", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(setDeviceName, set:(NSString*)name WithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        deviceName = name;
        resolve(@YES);
    } @catch(NSException* exception) {
        reject(@"SLocation", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(searchDevice, search:(BOOL)isSearch WithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        isSerachingDevice = isSearch;
        resolve(@YES);
    } @catch(NSException* exception) {
        reject(@"SLocation", exception.reason, nil);
    }
}

-(void)openGPS{
    [[SLocation sharedInstance] initGPS];
    if([deviceName isEqualToString:@"local"]) {
        [[SLocation sharedInstance] openLocalGPS];
    } else {
        [[SLocation sharedInstance] openExternalGPS];
    }
}

-(void)closeGPS{
    if([deviceName isEqualToString:@"local"]) {
        [[SLocation sharedInstance] closeLocalGPS];
    } else {
        [[SLocation sharedInstance] closeExternalGPS];
    }
}

-(void)initGPS{
    if(!inGPSInited) {
        [[SLocation sharedInstance] initExternalGPS];
        inGPSInited = YES;
    }
}

-(void)openLocalGPS{
   dispatch_async(dispatch_get_main_queue(), ^{
       if(!LocationPlugin){
           LocationPlugin = [[locationChangedDelegate alloc]init];
       }
       
       [LocationPlugin.Plugin startUpdatingLocation];
   });
}
-(void)closeLocalGPS{
    @synchronized(LocationPlugin) {
        [LocationPlugin.Plugin stopUpdatingLocation];
    }
    
}
-(void)openExternalGPS{
    isOpenExternalGPS = YES;
}
-(void)closeExternalGPS{
    isOpenExternalGPS = NO;
}

-(GPSData*)getGPSData{
    if([deviceName isEqualToString:@"local"]) {
        return [LocationPlugin.gpsData clone];
    } else {
        return externalGPS;
    }
}

-(void)initExternalGPS{
    sock = socket(AF_INET, SOCK_STREAM, 0);
     if(sock == -1){
       close(sock);
       NSLog(@"socket error : %d",sock);
         return;
     }
    
    struct sockaddr_in sockAddr;
    sockAddr.sin_family = AF_INET;
    const char *ip = [@"127.0.0.1" cStringUsingEncoding:NSASCIIStringEncoding];
    sockAddr.sin_addr.s_addr = inet_addr(ip);
    sockAddr.sin_port = htons(listenPort);

    int bd = bind(sock,(struct sockaddr *) &sockAddr, sizeof(sockAddr));
    if(bd == -1){
      close(sock);
      NSLog(@"bind error : %d",bd);
      return;
    }
    
    int ls = listen(sock,20);
    if(ls == -1){
      close(sock);
      NSLog(@"listen error : %d",ls);
      return;
    }
    
    dispatch_queue_t listenGPS_queue = dispatch_queue_create("listenGPS", NULL);
    dispatch_async(listenGPS_queue, ^{
        struct sockaddr_in recvAddr;
        socklen_t recv_size = sizeof(struct sockaddr_in);
        listenSock = accept(sock,(struct sockaddr *) &recvAddr, &recv_size);
        
        ssize_t bytesRecv = -1; // 返回数据字节大小
        char recvData[1024] = ""; // 返回数据缓存区
        // 如果一端断开连接，recv就会马上返回，bytesrecv等于0，然后while循环就会一直执行,所以判断等于0是跳出去
          while(1){
              @try {
                  bytesRecv = recv(listenSock,recvData,1024,0); // recvData为收到的数据
                  NSString * str = [NSString stringWithUTF8String:recvData];
                  NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
                  NSError *error;
                  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&error];
                  if(!error) {
                      if([dic objectForKey:@"deviceName"]) {
                          NSString* device = [dic valueForKey:@"deviceName"];
                          if(isSerachingDevice) {
                              [self sendEventWithName:LOCATION_SEARCH_DEVICE body:device];
                          }
                          NSString* deviceFullName = [NSString stringWithFormat:@"external_%@", device];
                          if([deviceFullName isEqualToString:deviceName] && isOpenExternalGPS) {
                              GPSData * gpsData = [[GPSData alloc]init];
                              gpsData.dLatitude =  [[dic valueForKey:@"latitude"] doubleValue];
                              gpsData.dLongitude = [[dic valueForKey:@"longitude"] doubleValue];
                              if([dic objectForKey:@"altitude"]) {
                                  gpsData.dAltitude = [[dic valueForKey:@"altitude"] doubleValue];
                              }
                              if([dic objectForKey:@"speed"]) {
                                  gpsData.dSpeed = [[dic valueForKey:@"speed"] doubleValue];
                              }
                              externalGPS = gpsData;
                              NSLog(@"location:{lat:%f; lon:%f;}", gpsData.dLatitude, gpsData.dLongitude);
                          }
                      }
                  }
              } @catch(NSException * exception) {
                  NSLog(@"external location error: %@", exception.reason);
              }
          }
    });
}

@end
