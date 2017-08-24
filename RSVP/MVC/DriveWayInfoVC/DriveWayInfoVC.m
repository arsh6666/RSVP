//
//  DriveWayInfoVC.m
//  RSVP
//
//  Created by Maninder Singh on 10/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//
#import "MVPlaceSearchTextField.h"
#import "DriveWayInfoVC.h"

@interface DriveWayInfoVC ()<MKMapViewDelegate,CLLocationManagerDelegate,PlaceSearchTextFieldDelegate>{
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
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITextField *txtSpotName;
@property (strong, nonatomic) IBOutlet MVPlaceSearchTextField *addressTextField;
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
    
    self.addressTextField.placeSearchDelegate= self;
    self.addressTextField.strApiKey= @"AIzaSyAT4NNoOQrBYgaUBqLsJmDaw1CnfkOe4CY";
    //@"AIzaSyAT4NNoOQrBYgaUBqLsJmDaw1CnfkOe4CY";
    self.addressTextField.superViewOfList= self.contentView;  // View, on which Autocompletion list should be appeared.
    self.addressTextField.autoCompleteShouldHideOnSelection= YES;
    self.addressTextField.maximumNumberOfAutoCompleteRows= 5;
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.addressTextField.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    self.addressTextField.autoCompleteBoldFontName = @"HelveticaNeue";
    self.addressTextField.autoCompleteTableCornerRadius=0.0;
    self.addressTextField.autoCompleteRowHeight=35;
    self.addressTextField.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    self.addressTextField.autoCompleteFontSize=14;
    self.addressTextField.autoCompleteTableBorderWidth=1.0;
    self.addressTextField.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    self.addressTextField.autoCompleteShouldHideOnSelection=YES;
    self.addressTextField.autoCompleteShouldHideClosingKeyboard=YES;
    self.addressTextField.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    self.addressTextField.autoCompleteTableFrame = CGRectMake(20,95, self.addressTextField.frame.size.width, 300.0);
}


#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField *)textField ResponseForSelectedPlace:(GMSPlace *)responseDict{
    location = responseDict.coordinate;
    [self.view endEditing:YES];
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
}

-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    
}

-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (self.txtSpotName.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Spot Name." closeButtonTitle:@"OK" duration:0.0f];
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
                [alert showWarning:self title:@"Alert" subTitle:@"Please specify about space." closeButtonTitle:@"OK" duration:0.0f];
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
                [alert showWarning:self title:@"Alert" subTitle:@"Please specify rules." closeButtonTitle:@"OK" duration:0.0f];
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
    NSDictionary *dict = @{
                           @"Owner": [NSString stringWithFormat:@"%@",isOwner],
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
                           @"Name":self.txtSpotName.text,
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
