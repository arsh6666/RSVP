//
//  LoginViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 29/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginButtonAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    if (_emailTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter email address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (![Utils isValidEmail:_emailTextField.text]){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid email address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_passwordTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter password." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_passwordTextField.text.length < 8){
        [alert showWarning:self title:@"Alert" subTitle:@"Password should contain minimum 8 characters." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }else{
        [self webService];
    }
}


-(void)webService{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           @"DeviceToken":appDelegate().deviceToken,
                           @"UserName":_emailTextField.text,
                           @"Password": _passwordTextField.text
                           };
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:login parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
               NSDictionary *jsonDict = responseObject;
               [SVProgressHUD dismiss];
               if ([jsonDict[@"Success"] boolValue]){
                   
                   [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%@",jsonDict[@"Id"]] forKey:@"userId"];
                   [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"isLogin"];
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
