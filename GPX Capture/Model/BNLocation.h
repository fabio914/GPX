//
//  BNLocation.h
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "BNGPXRepresentation.h"

@interface BNLocation : NSObject <BNGPXRepresentation>

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) double elevation;
@property (nonatomic, retain) NSDate * timestamp;

+ (instancetype)locationWithCoordinate:(CLLocationCoordinate2D)coordinate elevation:(double)elevation time:(NSDate *)time;

@end
