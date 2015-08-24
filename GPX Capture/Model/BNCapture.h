//
//  BNCapture.h
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "BNGPXRepresentation.h"
#import "BNLocation.h"

@interface BNCapture : NSObject <BNGPXRepresentation>

+ (instancetype)capture;
- (void)addLocation:(BNLocation *)location;
- (NSString *)save;

@end

@interface BNCapture (MapKit)

- (MKPolyline *)polyline;

@end
