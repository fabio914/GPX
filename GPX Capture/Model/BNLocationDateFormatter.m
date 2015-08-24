//
//  BNLocationDateFormatter.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNLocationDateFormatter.h"

@implementation BNLocationDateFormatter {
    NSDateFormatter * _df;
}

+ (instancetype)shared {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    if(self = [super init]) {
        
        _df = [[NSDateFormatter alloc] init];
    }
    
    return self;
}

- (NSString *)gpxStringDateFromDate:(NSDate *)date {
    
    [_df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z"];
    return [_df stringFromDate:date];
}

- (NSString *)yyyyMMddHHmmssFromDate:(NSDate *)date {
    
    [_df setDateFormat:@"yyyyMMddHHmmss"];
    return [_df stringFromDate:date];
}

- (void)dealloc {
    
    [_df release], _df = nil;
    [super dealloc];
}

@end
