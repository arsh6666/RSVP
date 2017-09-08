//
//  DriveWayInfoVC.m
//  RSVP
//
//  Created by Maninder Singh on 10/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//
#import "MVPlaceSearchTextField.h"
#import "DriveWayInfoVC.h"

@interface DriveWayInfoVC ()<MKMapViewDelegate,CLLocationManagerDelegate,PlaceSearchTextFieldDelegate,UIImagePickerControllerDelegate,CLImageEditorDelegate,UINavigationControllerDelegate>{
    CLLocationCoordinate2D location;
    NSString *isOwner;
    NSString *Rented;
    NSString *Sharing;
    NSString *AvailableBlock;
    NSString *SpaceAvailableForRegularCar;
    NSString *ParkingRule;
    NSString *blockAvailable;
    BOOL islocationEnable;
    UIImage *imageUpload;
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
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
    @property (strong, nonatomic) IBOutlet UIImageView *imgDrrivey;

- (IBAction)btnBack:(id)sender;

@end

@implementation DriveWayInfoVC
CLLocationManager *locationManager1;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnBack.hidden = YES;
    
    if (_isDrivayEdit == YES)
    {
        self.btnBack.hidden = NO;
    }
    
    locationManager1 = [[CLLocationManager alloc] init];
    locationManager1.delegate = self;
    [locationManager1 requestAlwaysAuthorization];
    [locationManager1 startUpdatingLocation];
    
    self.addressTextField.placeSearchDelegate= self;
    self.addressTextField.strApiKey= @"AIzaSyAT4NNoOQrBYgaUBqLsJmDaw1CnfkOe4CY";
   
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
    self.addressTextField.autoCompleteShouldHideClosingKeyboard=YES;
    self.addressTextField.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    self.addressTextField.autoCompleteTableFrame = CGRectMake(20,self.addressTextField.frame.origin.y+50, self.addressTextField.frame.size.width, 300.0);
    
    if (_isDrivayEdit == YES)  {
        [self DriveWayInfoMethod];
    }
  
}

-(void)DriveWayInfoMethod
{
    NSDictionary *DriveWayDict = _myProfileDetail[@"Driwayinfo"];
    self.txtSpotName.text = [DriveWayDict valueForKey:@"Name"] ;
    self.addressTextField.text = [DriveWayDict valueForKey:@"Address"] ;
    self.blockAvailableSwitch.on = [[DriveWayDict valueForKey:@"AvailableBlock"]boolValue] ;
    self.ownerSwitch.on = [[DriveWayDict valueForKey:@"Owner"]boolValue];
    self.rentingSwitch.on = [[DriveWayDict valueForKey:@"Rented"]boolValue];
    self.sharingSwitch.on = [[DriveWayDict valueForKey:@"Sharing"]boolValue];
    self.spaceForRegularCarSwitch.on = [[DriveWayDict valueForKey:@"SpaceAvailableForRegularCar"]boolValue];
    self.ruleSwitch.on = [[DriveWayDict valueForKey:@"ParkingRule"]boolValue];
    
    
    if (DriveWayDict[@"Comment"] != [NSNull null]){
       self.regularCarCommentTextField = [DriveWayDict valueForKey:@"Comment"];
    }
    if (DriveWayDict[@"CommentForSpace"] != [NSNull null]){
        self.sharingCommentTextField.text = [DriveWayDict valueForKey:@"CommentForSpace"] ;
    }
    if (DriveWayDict[@"Rule"] != [NSNull null]){
        self.rulesTextField.text = [DriveWayDict valueForKey:@"Rule"];
    }

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
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

    
#pragma mark- UIImageController delegate
    
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        //You can retrieve the actual UIImage
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
        editor.delegate = self;
        
        [picker pushViewController:editor animated:YES];
        
    }
    
#pragma mark- CLImageEditor delegate
    
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
    {
        imageUpload = image;
        self.imgDrrivey.image = image;
        [editor dismissViewControllerAnimated:YES completion:nil];
       
        
    }
    
-(void)SaveImageMethod:(UIImage*)Image{
    [SVProgressHUD show];
        
    NSDictionary *dict = @{
                            @"Type": [NSNumber numberWithInteger:1],
                            @"Images":[NSArray arrayWithObject:[Utils encodeToBase64String:Image]],
                            @"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]
                               };
        
        NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/UploadImages";
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager1 POST:url parameters:dict progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *jsonDict = responseObject;
                   [SVProgressHUD dismiss];
                   if ([jsonDict[@"Success"] boolValue]){
                       
                       SCLAlertView *alert = [[SCLAlertView alloc] init];
                       [alert showSuccess:@"Alert" subTitle:[responseObject valueForKey:@"Message"] closeButtonTitle:@"Ok" duration:0.0f];
                   }
                   else
                   {
                       SCLAlertView *alert = [[SCLAlertView alloc] init];
                       [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@", jsonDict[@"Message"]] closeButtonTitle:@"OK" duration:0.0f];
                   }
                   NSLog(@"%@",responseObject);
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [SVProgressHUD dismiss];
                   NSLog(@"%@",error);
               }];

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
    NSLog(@"%@",self.addressTextField.text);
    if (_addressTextField.text.length == 0 ){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (self.txtSpotName.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Spot Name." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (!_isDrivayEdit) {
        
        if (imageUpload == nil)
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please add image" closeButtonTitle:@"OK" duration:0.0f];
        }
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





-(void)webService
    {
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
               if ([jsonDict[@"Success"] boolValue])
               {
                   if (imageUpload != nil) {
                   [self SaveImageMethod:imageUpload];
                   }
                   if (_isDrivayEdit)
                   {
                       SCLAlertView *alert = [[SCLAlertView alloc] init];
                       [alert showSuccess:self title:@"Alert" subTitle:@"Update Sucessfully" closeButtonTitle:@"OK" duration:0.0f];
                       
                   }
                   else
                   {
                   MapViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                   [self.navigationController pushViewController:hvc animated:YES];
                   }
                   
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

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
