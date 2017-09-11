//
//  ConfirmationVC.m
//  RSVP
//
//  Created by Maninder Singh on 25/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ConfirmationVC.h"

@interface ConfirmationVC ()<AuthNetDelegate>{
    NSString *token;
    NSString *uniqueIdentifier;
    NSInteger walletBalance;
    NSDictionary *userProfile;
}
    @property (strong, nonatomic) IBOutlet UILabel *lbl30min;

@end

@implementation ConfirmationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_Price isEqualToString:@"1"]) {
        _lbl30min.hidden = YES;
    }
    
    NSLog(@"%@",_markerData);
    
    [self GetUserProfile];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmationButton:(id)sender {
    
    if (walletBalance > 10) {
        
        [self webService ];
        
    }
    else
    {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please remember to add funds to your wallet" closeButtonTitle:@"OK" duration:0.0f];
    }
}
    
- (IBAction)cancelButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)webService
{
    NSInteger idID;
    NSInteger typeID;
    NSLog(@"%@",_markerData);
    
    if ([_markerData[@"ParkingType"]  isEqual: @"Driway"])
    {
        typeID = 1;
    }
    else if ([_markerData[@"ParkingType"]  isEqual: @"Block"])
    {
        typeID = 2;
        
    }
    else{
        typeID = 3;
    }
    
    if ([self.Price isEqualToString:@"1"])
    {
        idID = [_markerData[@"StreetId"]integerValue];
    }
    else
    {
        idID = [_markerData[@"DriwayId"]integerValue];
    }
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSDictionary *dict = @{@"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"ToUserId": _markerData[@"UserId"],
                           @"Amount": self.Price,
                           @"ParkingType":[NSNumber numberWithInteger:typeID],
                           @"ParkingId": [NSNumber numberWithInteger:idID]
                           };
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SavePayment";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [SVProgressHUD dismiss];
               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
               NSDictionary *jsonDict = responseObject;
               if ([jsonDict[@"Success"] boolValue] == true){
                   
                   if (![_Price isEqualToString:@"1"])
                   {
                       AgreementVC *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"AgreementVC"];
                       VC.markerData = _markerData;
                       VC.UserProfile = userProfile;
                       [self.navigationController pushViewController:VC animated:YES];
                       
                   }
                   else
                   {
                       StreetAgreementPageVC *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"StreetAgreementPageVC"];
                       VC.markerData = _markerData;
                       VC.UserProfile = userProfile;
                       [self.navigationController pushViewController:VC animated:YES];
                       
                   }

                   
               }else{
                  
               }
               
                NSLog(@"%@",responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
               [SVProgressHUD dismiss];
               NSLog(@"%@",error);
           }];
    
}
    
-(void)GetUserProfile
{
    
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetProfile?UserId=";
    NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]]];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URLToHit parameters:nil progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *jsonDict = responseObject;
              userProfile = responseObject;
              
              [SVProgressHUD dismiss];
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              
              if ([jsonDict[@"Success"] boolValue]){
                  
                  walletBalance = [[responseObject valueForKey:@"WalletBalance"]integerValue];
                  
                }
              else
              {
                  SCLAlertView *alert = [[SCLAlertView alloc] init];
                  [alert showWarning:self title:@"Alert" subTitle: @"Currently no bid available." closeButtonTitle:@"OK" duration:0.0f];
              }
              NSLog(@"%@",responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [SVProgressHUD dismiss];
              NSLog(@"%@",error);
          }];
    

    
}

@end
