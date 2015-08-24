//
//  BNCapture.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNCapture.h"
#import "BNLocationDateFormatter.h"
#import "XMLDictionary.h"

@interface BNCapture ()
@property (nonatomic, retain) NSMutableArray * locations;
@end

@implementation BNCapture

+ (NSString *)documentsPath {
    
    return [(NSURL *)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
}

+ (NSArray *)gpxFiles {
    
    NSString * documentsPath = [self documentsPath];
    NSArray * documentsFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:NULL];
    
    NSMutableArray * gpxFiles = [NSMutableArray array];
    
    for(NSString * file in documentsFiles) {
        
        if([[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"gpx"]) {
        
            [gpxFiles addObject:file];
        }
    }
    
    return gpxFiles;
}

+ (instancetype)capture {
    return [[[self alloc] init] autorelease];
}

+ (instancetype)fromGpxRepresentation:(NSDictionary *)representation {
    
    if([representation[@"wpt"] isKindOfClass:[NSArray class]]) {
        
        BNCapture * capture = [self capture];
        
        for(NSDictionary * entry in representation[@"wpt"]) {
            
            BNLocation * location = [BNLocation fromGpxRepresentation:entry];
            
            if(location) {
                
                [capture addLocation:location];
            }
        }
        
        return capture;
    }
    
    return nil;
}

+ (instancetype)loadFromFile:(NSString *)path {
    
    return [self fromGpxRepresentation:[NSDictionary dictionaryWithXMLFile:path]];
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

    NSString * path = [[BNCapture documentsPath] stringByAppendingPathComponent:fileName];
    
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

- (MKCoordinateRegion)region {
    
    double minLat = 999999.f, maxLat = -999999.f;
    double minLon = 999999.f, maxLon = -999999.f;
    
    for(BNLocation * location in _locations) {
        
        if(minLat > location.location.latitude) minLat = location.location.latitude;
        if(maxLat < location.location.latitude) maxLat = location.location.latitude;
        
        if(minLon > location.location.longitude) minLon = location.location.longitude;
        if(maxLon < location.location.longitude) maxLon = location.location.longitude;
    }
    
    MKCoordinateRegion region;
    
    if([_locations count] > 0) {
        
        region.center = CLLocationCoordinate2DMake((maxLat + minLat)/2.0, (maxLon + minLon)/2.0);
        region.span.latitudeDelta = fabs(maxLat - minLat) * 1.2;
        region.span.longitudeDelta = fabs(maxLon - minLon) * 1.2;
    }
    
    else {
        
        region.center = CLLocationCoordinate2DMake(0.f, 0.f);
        region.span.latitudeDelta = 1.f;
        region.span.longitudeDelta = 1.f;
    }
    
    return region;
}

@end
