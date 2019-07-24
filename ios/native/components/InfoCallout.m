//
//  InfoCallout.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/13.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "InfoCallout.h"

@implementation InfoCallout

@synthesize ID;
@synthesize description;
@synthesize layerName;
@synthesize geoID;
@synthesize modifiedDate;
@synthesize mediaName;
@synthesize mediaFilePaths;
//@synthesize type;
@synthesize httpAddress;

- (id)initWithMapControl:(MapControl *)mapControl BackgroundColor:(UIColor*)customcolor Alignment:(CalloutAlignment)calloutAlignment {
    self = [super initWithMapControl:mapControl BackgroundColor:customcolor Alignment:calloutAlignment];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    long long totalMilliseconds = interval*1000;
    
    self.ID = [[NSNumber numberWithLongLong:totalMilliseconds] stringValue];
    
    return self;
}

- (id)initWithMapControl:(MapControl *)mapControl {
    self = [super initWithMapControl:mapControl];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    long long totalMilliseconds = interval*1000;
    
    self.ID = [[NSNumber numberWithLongLong:totalMilliseconds] stringValue];
    
    return self;
}

- (void)setGeoID:(int)GEOID {
    geoID = GEOID;
    if (layerName) {
        ID = [NSString stringWithFormat:@"%@-%d", layerName, geoID];
    }
}

- (void)setLayerName:(NSString *)name {
    layerName = name;
    if (geoID >= 0) {
        ID = [NSString stringWithFormat:@"%@-%d", layerName, geoID];
    }
}

@end
