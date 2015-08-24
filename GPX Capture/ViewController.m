//
//  ViewController.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>

#import "BNCapture.h"
#import "BNLocation.h"
#import "MKMapView+ZoomLevel.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet MKMapView * mapView;
@property (retain, nonatomic) IBOutlet UIButton * buttonView;
@property (retain, nonatomic) IBOutlet UIView * redView;

@property (nonatomic, retain) CLLocationManager * manager;
@property (nonatomic, retain) BNCapture * capture;
@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    
    _mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [_manager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_manager requestAlwaysAuthorization];
    [_manager startUpdatingLocation];
}

- (void)startBlinking {
    
    [self.redView setHidden:NO];
    [self blink];
}

- (void)blink {
    
    [self.redView setHidden:![self.redView isHidden]];
    [self performSelector:@selector(blink) withObject:nil afterDelay:1.f];
}

- (void)stopBlinking {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.redView setHidden:YES];
}

- (IBAction)buttonAction:(id)sender {
    
    if(!self.capture) {
        
        self.capture = [BNCapture capture];
        [self startBlinking];
        [self.buttonView setTitle:@"Stop" forState:UIControlStateNormal];
    }
    
    else {
        
        NSString * fileName = [self.capture save];
        
        if(fileName) {
            
            [[[[UIAlertView alloc] initWithTitle:@"Saved" message:[NSString stringWithFormat:@"Saved as %@", fileName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
        
        [_capture release], _capture = nil;
        [self stopBlinking];
        [self.buttonView setTitle:@"Start" forState:UIControlStateNormal];
    }
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString * AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView * annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if(annotationView)
        return annotationView;
    
    else {
        
        MKAnnotationView * annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"icon_map_pin"];
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    CLLocation * location = [locations lastObject];

    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    MKPointAnnotation * point = [[[MKPointAnnotation alloc] init] autorelease];
    point.coordinate = location.coordinate;
    [self.mapView addAnnotation:point];
    
    [_mapView setCenterCoordinate:location.coordinate zoomLevel:17 animated:NO];
    
    if(!self.capture)
        return;
    
    [self.capture addLocation:[BNLocation locationWithCoordinate:location.coordinate elevation:location.altitude time:[NSDate date]]];
    
    [self.mapView removeOverlays:[self.mapView overlays]];
    
    MKPolyline * polyline = [self.capture polyline];
    
    if(polyline)
        [_mapView addOverlays:@[polyline]];
}

- (void)dealloc {
    
    [_manager stopUpdatingLocation];
    
    [_mapView release], _mapView = nil;
    [_buttonView release], _buttonView = nil;
    
    [_capture release], _capture = nil;
    [_manager release], _manager = nil;
    
    [_redView release];
    [super dealloc];
}

@end
