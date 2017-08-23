//
//  MapViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 29/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    NSArray *DriwayinfoList;
    NSArray *myDriveWaylist;
    BOOL isLocUpdated;
}



@end

@implementation MapViewController

CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    isLocUpdated = NO;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    _mapView.delegate = self;
    _mapView.showsUserLocation = true;
    [self webService];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (!isLocUpdated){
        CLLocationCoordinate2D loc = [userLocation coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
        [_mapView setRegion:region animated:YES];
        isLocUpdated = YES;
    }
    
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CustomAnnotation *an = view.annotation;
    NSDictionary *markerData = an.markerDict;
    NSString *DriwayId = markerData[@"DriwayId"];
    if ([markerData[@"ParkingType"]  isEqual: @"Driway"] || [markerData[@"ParkingType"]  isEqual: @"Block"]){
        
    }else{
        BidderVC *bidderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidderVC"];
        bidderVC.drivewayID = DriwayId;
        for(NSInteger i=0; i < myDriveWaylist.count; i++){
            NSDictionary *drivewayDict = myDriveWaylist[i];
            NSString *myDrivewayID = drivewayDict[@"DriwayId"];
            if (myDrivewayID == DriwayId){
                bidderVC.isMyDriveway = YES;
            }
        }
        [self.navigationController pushViewController:bidderVC animated:YES];
    }
   
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // Don't do anything if it's the user's location point
    if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    // Fetch all necessary data from the point object
    NSDictionary *myDict = ((PointAnnotation*)annotation).markerDict;
    CustomAnnotation * pin = [[CustomAnnotation alloc]initWithAnnotation:annotation markerDict:myDict];
    
    return pin;
}


-(void)webService{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetDriwayinfoList?UserId=";
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = responseObject;
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        if ([jsonDict[@"Success"] boolValue]){
            DriwayinfoList = jsonDict[@"DriwayinfoList"];
            [self getMyDrivayList];
            
        }else{
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@", jsonDict[@"Message"]] closeButtonTitle:@"OK" duration:0.0f];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

-(void)getMyDrivayList{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetDriwayinfoList?UserId=";
    NSString *UrlToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]]];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET:UrlToHit parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = responseObject;
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if ([jsonDict[@"Success"] boolValue]){
            myDriveWaylist = jsonDict[@"DriwayinfoList"];
            [DriwayinfoList arrayByAddingObject:myDriveWaylist];
        }
        [self setMarkerData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

-(void)setMarkerData{
    for (NSInteger i = 0; i < DriwayinfoList.count; i++) {
        NSDictionary *DrivewayDict = DriwayinfoList[i];
        NSString *Lat = DrivewayDict[@"Latitude"];
        NSString *lng =  DrivewayDict[@"Longitude"];
        PointAnnotation *point = [[PointAnnotation alloc] init];
        point.markerDict = DrivewayDict;
        point.title = [NSString stringWithFormat:@"%@",DrivewayDict[@"Address"]];
        if ([DrivewayDict[@"ParkingType"]  isEqual: @"Driway"] || [DrivewayDict[@"ParkingType"]  isEqual: @"Block"]){
            point.subtitle = @"$10";
        }else{
            point.subtitle = @"$1";
        }
        
        point.coordinate = CLLocationCoordinate2DMake([Lat doubleValue], [lng doubleValue]);
        [self.mapView addAnnotation:point];
        
    }
    
}


@end
