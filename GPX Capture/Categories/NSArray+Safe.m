//
//  NSArray+Safe.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index {
    
    if(index >= [self count])
        return nil;
    
    return [self objectAtIndex:index];
}

@end
