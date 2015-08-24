//
//  BNLocationDateFormatter.h
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNLocationDateFormatter : NSObject

+ (instancetype)shared;
- (NSString *)gpxStringDateFromDate:(NSDate *)date;
- (NSString *)yyyyMMddHHmmssFromDate:(NSDate *)date;

@end