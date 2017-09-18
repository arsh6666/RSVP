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
    NSMutableArray *DriwayinfoList;
    NSArray *myDriveWaylist;
    BOOL isLocUpdated;
    
    
    NSTimer *timer;
}



@end

@implementation MapViewController

CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    NSLog(@"%@",currentDeviceId);
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"MAPBOOL"];
        timer=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    isLocUpdated = NO;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    _mapView.delegate = self;
    _mapView.showsUserLocation = true;
    [self webService];
    [self.navigationController setNavigationBarHidden:YES];
        

    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"MAPBOOL"];
    
}



-(IBAction)timerFired:(id)sender
{
   BOOL RecallBool = [[NSUserDefaults standardUserDefaults]boolForKey:@"MAPBOOL"];
    
    if (RecallBool == NO)
    {
        [timer invalidate];
        timer = nil;
        return;
    }

    id userLocation = [_mapView userLocation];
    
    [_mapView removeAnnotations:[_mapView annotations]];
   // [self webService];
    if ( userLocation != nil )
    {
        [self webService];
       // [_mapView addAnnotation:userLocation];
        // will cause user location pin to blink
    }
    
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
   
    ConfirmationVC *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmationVC"];
    VC.markerData = markerData;
    
    if ([markerData[@"ParkingType"]  isEqual: @"Driway"] || [markerData[@"ParkingType"]  isEqual: @"Block"])
    {
        
        VC.Price = @"10";
        
    }
    else
    {
//
        VC.Price = @"1";
//        BidderVC *bidderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidderVC"];
//        bidderVC.drivewayID = markerData[@"StreetId"];
//        
////        for(NSInteger i=0; i < myDriveWaylist.count; i++){
////            NSDictionary *drivewayDict = myDriveWaylist[i];
////            NSString *StreetUserID = drivewayDict[@"UserId"];
////            if (myDrivewayID == DriwayId){
////                bidderVC.isMyDriveway = YES;
////            }
////        }
//        
//        [self.navigationController pushViewController:bidderVC animated:YES];
        
        
    }
   [self.navigationController pushViewController:VC animated:YES];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // Don't do anything if it's the user's location point
    if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    // Fetch all necessary data from the point object
    NSDictionary *myDict = ((PointAnnotation*)annotation).markerDict;
    CustomAnnotation * pin = [[CustomAnnotation alloc]initWithAnnotation:annotation markerDict:myDict];
    
    return pin;
}


-(void)webService
    {
        NSDate *date1 = [NSDate date];
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:date1];
        
        int weekDay =(int)[component weekday];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *weekdayString = [[formatter weekdaySymbols] objectAtIndex:weekDay - 1];
        
        NSString *IntDay = [[NSString alloc]init];
        
        if ([weekdayString isEqualToString:@"Monday"]){
            IntDay = @"1";
        }
        if ([weekdayString isEqualToString:@"Tuesday"]){
            IntDay = @"2";
        }
        if ([weekdayString isEqualToString:@"Wednesday"]){
            IntDay = @"3";
        }
        if ([weekdayString isEqualToString:@"Thursday"]){
            IntDay = @"4";
        }
        if ([weekdayString isEqualToString:@"Friday"]){
            IntDay = @"5";
        }
        if ([weekdayString isEqualToString:@"Saturday"]){
            IntDay = @"6";
        }
        if ([weekdayString isEqualToString:@"Sunday"]){
            IntDay = @"7";
        }

      NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"hh:mm a"];
    NSString *time = [[outputFormatter stringFromDate:[NSDate date]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSString *url=[NSString  stringWithFormat:@"%@?Day=%@&Time=%@",GetDriwayinfoList,IntDay,time];
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = responseObject;
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        if ([jsonDict[@"Success"] boolValue]){
            DriwayinfoList = [[NSMutableArray alloc]init];
            [DriwayinfoList addObjectsFromArray:jsonDict[@"DriwayinfoList"]];
            [DriwayinfoList addObjectsFromArray:jsonDict[@"StreetList"]];
            [self setMarkerData];
          //  [self getMyDrivayList];
            
        }
        
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

//-(void)getMyDrivayList{
//    [SVProgressHUD show];
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//
//    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetDriwayinfoList?UserId=";
//    NSString *UrlToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]]];
//    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
//    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    [manager1 GET:UrlToHit parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *jsonDict = responseObject;
//        [SVProgressHUD dismiss];
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//        if ([jsonDict[@"Success"] boolValue]){
//            myDriveWaylist = jsonDict[@"DriwayinfoList"];
//            [DriwayinfoList arrayByAddingObject:myDriveWaylist];
//        }
//        [self setMarkerData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
//        NSLog(@"%@",error);
//    }];
//}

-(void)setMarkerData{
   
    for (NSInteger i = 0; i < DriwayinfoList.count; i++)
    {
        NSDictionary *DrivewayDict = DriwayinfoList[i];
        
        NSString *Lat = DrivewayDict[@"Latitude"];
        NSString *lng =  DrivewayDict[@"Longitude"];
        PointAnnotation *point = [[PointAnnotation alloc] init];
        point.markerDict = DrivewayDict;
       
        if ([DrivewayDict[@"ParkingType"]  isEqual: @"Driway"] || [DrivewayDict[@"ParkingType"]  isEqual: @"Block"]){
             point.title = [NSString stringWithFormat:@"%@",DrivewayDict[@"Name"]];
            point.subtitle = @"$10/30min";
        }else{
             point.title = [NSString stringWithFormat:@"%@",DrivewayDict[@"UserName"]];
            point.subtitle = @"$1";
        }
        
        point.coordinate = CLLocationCoordinate2DMake([Lat doubleValue], [lng doubleValue]);
        [self.mapView addAnnotation:point];
        
    }
    
}




@end
