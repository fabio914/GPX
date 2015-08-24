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
