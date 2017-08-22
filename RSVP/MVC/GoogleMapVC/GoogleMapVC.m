//
//  GoogleMapVC.m
//  RSVP
//
//  Created by Maninder Singh on 22/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "GoogleMapVC.h"



@interface GoogleMapVC ()<GMSMapViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>{
    CLLocationCoordinate2D location;
    BOOL isLocUpdated;
    CLLocationManager *locationManager1;
    GMSMarker *marker;
}
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@end

@implementation GoogleMapVC
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager1 = [[CLLocationManager alloc] init];
    locationManager1.delegate = self;
    [locationManager1 requestAlwaysAuthorization];
    [locationManager1 startUpdatingLocation];
    _mapView.myLocationEnabled = YES;
    _mapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [delegate getCordinates: marker.position];
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (!isLocUpdated){
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:locations.lastObject.coordinate zoom: 15];
        [_mapView setCamera:camera];
        isLocUpdated = YES;
    }
    location = locations.lastObject.coordinate;
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    location = newLocation.coordinate;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [_mapView clear];
    marker = [GMSMarker markerWithPosition:coordinate];
    marker.map = mapView;
}



@end
