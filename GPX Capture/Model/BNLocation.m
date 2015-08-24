//
//  BNLocation.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNLocation.h"
#import "BNLocationDateFormatter.h"

@implementation BNLocation

+ (instancetype)locationWithCoordinate:(CLLocationCoordinate2D)coordinate elevation:(double)elevation time:(NSDate *)time {
    
    return [[[self alloc] initWithCoordinate:coordinate elevation:elevation time:time] autorelease];
}

+ (instancetype)fromGpxRepresentation:(NSDictionary *)representation {
    
    if(![representation isKindOfClass:[NSDictionary class]])
        return nil;
    
    if(!representation[@"_lon"] || ![representation[@"_lon"] isKindOfClass:[NSString class]])
        return nil;
    
    if(!representation[@"_lat"] || ![representation[@"_lat"] isKindOfClass:[NSString class]])
        return nil;
    
    if(!representation[@"ele"] || ![representation[@"ele"] isKindOfClass:[NSString class]])
        return nil;
    
    if(!representation[@"time"] || ![representation[@"time"] isKindOfClass:[NSString class]])
        return nil;
    
    NSDate * date = [[BNLocationDateFormatter shared] dateFromGpxString:representation[@"time"]];
                     
    if(date == nil)
         return nil;
                     
    return [self locationWithCoordinate:CLLocationCoordinate2DMake([representation[@"_lat"] doubleValue], [representation[@"_lon"] doubleValue]) elevation:[representation[@"ele"] doubleValue] time:date];
}

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate elevation:(double)elevation time:(NSDate *)time {
    
    if(self = [super init]) {
        
        _location = coordinate;
        _elevation = elevation;
        _timestamp = [time retain];
    }
    
    return self;
}

- (NSString *)gpxRepresentation {
    
    return [NSString stringWithFormat:@"<wpt lat=\"%lf\" lon=\"%lf\"><ele>%lf</ele><time>%@</time></wpt>", _location.latitude, _location.longitude, _elevation, [[BNLocationDateFormatter shared] gpxStringDateFromDate:_timestamp]];
}

- (void)dealloc {
    
    [_timestamp release], _timestamp = nil;
    [super dealloc];
}

@end
