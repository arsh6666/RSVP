//
//  BillingDetailVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "BillingDetailVC.h"

@interface BillingDetailVC ()
@property (strong, nonatomic) IBOutlet UITextField *qickpayemail;
@property (strong, nonatomic) IBOutlet UITextField *zellemail;
@property (strong, nonatomic) IBOutlet UITextField *monthlyChecks;

@end

@implementation BillingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonAction:(id)sender {
    if (_qickpayemail.text.length == 0 && _zellemail.text.length == 0 && _monthlyChecks.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter one of the textfield." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }else{
        [self webService];
    }
    
}

-(void)webService{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSDictionary *dict = @{@"FirstName":_userDetail[@"FirstName"],
                           @"LastName": _userDetail[@"LastName"],
                           @"Email":_userDetail[@"Email"],
                           @"Password": _userDetail[@"Password"],
                           @"NickName": _userDetail[@"NickName"],
                           @"ChaseQuickpayEmail":_qickpayemail.text,
                           @"PhoneNumber":@"9876543210",
                           @"ZelleEmail":_zellemail.text,
                           @"AddressMonthly":_monthlyChecks.text};
    
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Account/Register";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [SVProgressHUD dismiss];
               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
               NSDictionary *jsonDict = responseObject;
               if ([jsonDict[@"Success"] boolValue]){
                   [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%@",jsonDict[@"Id"]] forKey:@"userId"];
                   [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"isLogin"];
                   [self webServiceCardDetail];
                   
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

-(void)webServiceCardDetail{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    NSDictionary *dict = @{@"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"Brand":_userCardDetail[@"Brand"],
                           @"Model": _userCardDetail[@"Model"],
                           @"Color":_userCardDetail[@"Color"],
                           @"Class":_userCardDetail[@"Class"],
                           @"Plate":_userCardDetail[@"Plate"],
                           @"State":_userCardDetail[@"State"]};
        NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SaveCar";
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager1 POST:url parameters:dict progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *jsonDict = responseObject;
                   [SVProgressHUD dismiss];
                   [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                   if ([jsonDict[@"Success"] boolValue]){
                       if (_drivewayToRentSwitch.isOn){
                           DriveWayInfoVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DriveWayInfoVC"];
                           [self.navigationController pushViewController:hvc animated:YES];
                       }else{
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
@end
