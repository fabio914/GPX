//
//  GPXViewController.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "GPXViewController.h"
#import "BNCapture.h"
#import <MapKit/MapKit.h>

@interface GPXViewController () <MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet MKMapView * mapView;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) BNCapture * capture;
@end

@implementation GPXViewController

+ (instancetype)gpxViewControllerWithPath:(NSString *)path {
    
    GPXViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GPXViewController"];
    [vc setPath:path];
    return vc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _mapView.delegate = self;
    
    self.capture = [BNCapture loadFromFile:_path];
    
    MKPolyline * polyline = [self.capture polyline];
    
    if(polyline)
        [self.mapView addOverlays:@[polyline]];
    
    [self.mapView setRegion:[self.capture region]];
}

#pragma mark - Map View

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer * renderer = [[[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay] autorelease];
        [renderer setStrokeColor:[UIColor blueColor]];
        [renderer setLineWidth:5.f];
        return renderer;
    }
    
    return nil;
}

- (void)dealloc {
    
    [_path release], _path = nil;
    [_mapView release], _mapView = nil;
    [_capture release], _capture = nil;
    [super dealloc];
}

@end
