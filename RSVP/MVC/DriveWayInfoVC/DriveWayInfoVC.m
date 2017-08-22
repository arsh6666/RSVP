//
//  DriveWayInfoVC.m
//  RSVP
//
//  Created by Maninder Singh on 10/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "DriveWayInfoVC.h"


@interface DriveWayInfoVC ()<MKMapViewDelegate,CLLocationManagerDelegate,getCordsDelegates>{
    CLLocationCoordinate2D location;
    NSString *isOwner;
    NSString *Rented;
    NSString *Sharing;
    NSString *AvailableBlock;
    NSString *SpaceAvailableForRegularCar;
    NSString *ParkingRule;
    NSString *blockAvailable;
    BOOL islocationEnable;
    
}
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UISwitch *blockAvailableSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *ownerSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *rentingSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sharingSwitch;
@property (strong, nonatomic) IBOutlet UITextField *sharingCommentTextField;
@property (strong, nonatomic) IBOutlet UISwitch *spaceForRegularCarSwitch;
@property (strong, nonatomic) IBOutlet UITextField *regularCarCommentTextField;
@property (strong, nonatomic) IBOutlet UISwitch *ruleSwitch;
@property (strong, nonatomic) IBOutlet UIButton *adressButton;
@property (strong, nonatomic) IBOutlet UITextField *rulesTextField;
@end

@implementation DriveWayInfoVC
CLLocationManager *locationManager1;


- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager1 = [[CLLocationManager alloc] init];
    locationManager1.delegate = self;
    [locationManager1 requestAlwaysAuthorization];
    [locationManager1 startUpdatingLocation];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)getCordinates:(CLLocationCoordinate2D)coordintes{
    [_adressButton setTitle:@"Your location has been set" forState:normal];
    location = coordintes;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    location = userLocation.coordinate;
}
- (IBAction)ownerButtonAction:(id)sender {
    if (_ownerSwitch.isOn){
        [_rentingSwitch setOn:NO];
    }else{
        [_rentingSwitch setOn:YES];
    }
}
- (IBAction)rentingSwitchAction:(id)sender {
    if (_rentingSwitch.isOn){
        [_ownerSwitch setOn:NO];
    }else{
        [_ownerSwitch setOn:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    location = newLocation.coordinate;
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:
                islocationEnable = NO;
                
                break;
            case kCLAuthorizationStatusRestricted:
                islocationEnable = NO;
                
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                islocationEnable = YES;
                
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                islocationEnable = YES;
                
                break;
            case kCLAuthorizationStatusNotDetermined:
                islocationEnable = NO;
                
                break;
            default:
                break;
        }
    }
}

- (IBAction)blockSwitchAction:(id)sender {
    if (_blockAvailableSwitch.isOn){
        [_spaceForRegularCarSwitch setOn:YES];
        [_ruleSwitch setOn:NO];
    }else{
        [_spaceForRegularCarSwitch setOn:NO];
        [_ruleSwitch setOn:NO];
    }
}
- (IBAction)spaceButtonAction:(id)sender {
    [_blockAvailableSwitch setOn:YES animated:YES];
}
- (IBAction)rulesSwitchAction:(id)sender {
    [_blockAvailableSwitch setOn:YES animated:YES];
}

- (IBAction)uploadImageBurronAction:(id)sender {
}

- (IBAction)addressOnMap:(id)sender {
    GoogleMapVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoogleMapVC"];
    hvc.delegate = self;
    [self.navigationController pushViewController:hvc animated:YES];
}
- (IBAction)submitButtonAction:(id)sender {
    if (!islocationEnable){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please allow location services." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_addressTextField.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_ownerSwitch.isOn){
        isOwner = @"true";
    }else{
        isOwner = @"false";
    }
    if (_rentingSwitch.isOn){
        Rented = @"true";
    }else{
        Rented = @"false";
    }
    if (_sharingSwitch.isOn){
        Sharing = @"true";
    }else{
        Sharing = @"false";
    }
    if (_sharingSwitch.isOn){
        if (_sharingCommentTextField.text.length == 0){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter sharing detail." closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
    }
    if (_blockAvailableSwitch.isOn){
        blockAvailable = @"true";
        if (_spaceForRegularCarSwitch.isOn){
            SpaceAvailableForRegularCar = @"true";
        }else{
            SpaceAvailableForRegularCar = @"false";
        }
        if (_spaceForRegularCarSwitch.isOn == NO){
            if (_regularCarCommentTextField.text.length == 0){
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showWarning:self title:@"Alert" subTitle:@"Palease specify about space." closeButtonTitle:@"OK" duration:0.0f];
                return;
            }
        }
        if (_ruleSwitch.isOn){
            ParkingRule = @"true";
        }else{
            ParkingRule = @"false";
        }
        if (_ruleSwitch.isOn){
            if (_rulesTextField.text.length == 0){
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showWarning:self title:@"Alert" subTitle:@"Palease specify rules." closeButtonTitle:@"OK" duration:0.0f];
                return;
            }else{
                blockAvailable = @"true";
                [self webService];
            }
        }else{
            blockAvailable = @"true";
            [self webService];
        }
    }
    else{
        blockAvailable = @"false";
        [self webService];
    }
    
}





-(void)webService{
    [SVProgressHUD show];
    NSDictionary *dict = @{@"Owner": [NSString stringWithFormat:@"%@",isOwner],
                           @"Rented": [NSString stringWithFormat:@"%@",Rented],
                           @"Sharing": [NSString stringWithFormat:@"%@",Sharing],
                           @"Comment": _sharingCommentTextField.text,
                           @"AvailableBlock": [NSString stringWithFormat:@"%@",blockAvailable],
                           @"SpaceAvailableForRegularCar":[NSString stringWithFormat:@"%@",SpaceAvailableForRegularCar] ,
                           @"CommentForSpace": _sharingCommentTextField.text,
                           @"ParkingRule": [NSString stringWithFormat:@"%@",ParkingRule],
                           @"Rule": _rulesTextField.text,
                           @"Latitude": [NSString stringWithFormat:@"%f",location.latitude],
                           @"Longitude": [NSString stringWithFormat:@"%f",location.longitude],
                           @"Address": _addressTextField.text,
                           @"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]
                           };
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SaveDriwayinfo";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSDictionary *jsonDict = responseObject;
               [SVProgressHUD dismiss];
               if ([jsonDict[@"Success"] boolValue]){
                   MapViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                   [self.navigationController pushViewController:hvc animated:YES];
                   
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

@end
