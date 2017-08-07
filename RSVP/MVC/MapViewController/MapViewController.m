//
//  MapViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 29/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>



@end

@implementation MapViewController

CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    _mapView.delegate = self;
    _mapView.showsUserLocation = true;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    BidderVC *bidderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidderVC"];
    [self.navigationController pushViewController:bidderVC animated:YES];
}

@end
