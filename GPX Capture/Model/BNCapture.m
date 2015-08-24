//
//  BNCapture.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNCapture.h"
#import "BNLocationDateFormatter.h"

@interface BNCapture ()
@property (nonatomic, retain) NSMutableArray * locations;
@end

@implementation BNCapture

+ (instancetype)capture {
    return [[[self alloc] init] autorelease];
}

- (void)addLocation:(BNLocation *)location {
    
    if(_locations == nil) {
        
        _locations = [[NSMutableArray alloc] init];
    }
    
    [_locations addObject:location];
}

- (NSString *)gpxRepresentation {
    
    NSMutableString * result = [NSMutableString stringWithString:@"<gpx>\n"];
    
    for(BNLocation * location in _locations) {
        
        [result appendFormat:@"%@\n", [location gpxRepresentation]];
    }
    
    [result appendString:@"</gpx>"];
    return result;
}

- (NSString *)save {
    
    NSString * fileName = [[[BNLocationDateFormatter shared] yyyyMMddHHmmssFromDate:[NSDate date]] stringByAppendingString:@".gpx"];
    
    NSURL * documentsPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString * path = [[documentsPath path] stringByAppendingPathComponent:fileName];
    
    NSError * error = nil;
    [[self gpxRepresentation] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if(error != nil) {
        
        return nil;
    }
    
    return fileName;
}

- (void)dealloc {
    
    [_locations release], _locations = nil;
    [super dealloc];
}

@end

@implementation BNCapture (MapKit)

- (MKPolyline *)polyline {
    
    if([_locations count] < 2)
        return nil;
    
    CLLocationCoordinate2D * coordinates = (CLLocationCoordinate2D *)malloc([_locations count] * sizeof(CLLocationCoordinate2D));
    
    if(coordinates == NULL)
        return nil;
    
    for(unsigned i = 0; i < [_locations count]; i++)
        coordinates[i] = [(BNLocation *)[_locations objectAtIndex:i] location];
    
    MKPolyline * ret = [MKPolyline polylineWithCoordinates:coordinates count:[_locations count]];
    free(coordinates);
    
    return ret;
}

@end
