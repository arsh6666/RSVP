//
//  ForgotPasswordVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ForgotPasswordVC

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
- (IBAction)nextButtonAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    if (_emailTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter email address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (![self validateEmailWithString:_emailTextField.text]){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid email address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }else{
        [self webService];
    }
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)webService{
    [SVProgressHUD show];
    NSDictionary *dict = @{@"Email":_emailTextField.text};
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Account/ForgetPassword";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSDictionary *jsonDict = responseObject;
               [SVProgressHUD dismiss];
               if ([jsonDict[@"Success"] boolValue]){
                   SCLAlertView *alert = [[SCLAlertView alloc] init];
                   [alert addButton:@"OK" actionBlock:^(void) {
                       [self.navigationController popViewControllerAnimated:YES];
                   }];
                   
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
