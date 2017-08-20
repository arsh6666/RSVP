//
//  SignUpViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 29/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "SignUpViewController.h"
@interface SignUpViewController (){
    UIWebView *webView;
}
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxButton;

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.checkBoxButton setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkBoxButtonAction:(id)sender {
    if ([self.checkBoxButton.imageView.image isEqual:[UIImage imageNamed:@"box"]])
        [self.checkBoxButton setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    else
        [self.checkBoxButton setImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
    
}
- (IBAction)termButtonACtion:(id)sender {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-50,20, 50, 30)];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closewebView:) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:close];
    [webView bringSubviewToFront:close];
    NSURL *targetURL = [[NSBundle mainBundle] URLForResource:@"RSVP terms-conditions-pdf-english" withExtension:@"pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

-(IBAction)closewebView:(id)sender{
    [webView removeFromSuperview];
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signUpButtonAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    if (_firstNameTextField.text.length == 0)
    {
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter first name." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_lastNameTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Last name." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_nickNameTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Nick name." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_emailTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter email address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (![self validateEmailWithString:_emailTextField.text]){
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
    }
    if (_confirmTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter re-type password." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (![_passwordTextField.text isEqualToString: _confirmTextField.text]){
        [alert showWarning:self title:@"Alert" subTitle:@"Enter password do not matched." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if ([self.checkBoxButton.imageView.image isEqual:[UIImage imageNamed:@"box"]]){
        [alert showWarning:self title:@"Alert" subTitle:@"Please check terms and condition's to proceed." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    else{
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
    NSDictionary *dict = @{@"FirstName":_firstNameTextField.text,
                           @"LastName": _lastNameTextField.text,
                           @"Email":_emailTextField.text,
                           @"Password": _passwordTextField.text,
                           @"NickName": _nickNameTextField.text,
                           @"PhoneNumber":@"1234567890"};
    VehicalDetail *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"VehicalDetail"];
    hvc.userDetail = dict;
    [self.navigationController pushViewController:hvc animated:YES];
    //    NSString *url=@"http://rsvp.rootflyinfo.com/api/Account/Register";
    //    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    //    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    [manager1 POST:url parameters:dict progress:nil
    //           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //               [SVProgressHUD dismiss];
    //        NSDictionary *jsonDict = responseObject;
    //               if ([jsonDict[@"Success"] boolValue]){
    //                   [NSUserDefaults.standardUserDefaults setObject:[NSString stringWithFormat:@"%@",jsonDict[@"Id"]] forKey:@"userId"];
    //                   [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"isLogin"];
    //                   VehicalDetail *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"VehicalDetail"];
    //                   [self.navigationController pushViewController:hvc animated:YES];
    //
    //               }else{
    //                   SCLAlertView *alert = [[SCLAlertView alloc] init];
    //                   [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@", jsonDict[@"Message"]] closeButtonTitle:@"OK" duration:0.0f];
    //               }
    //        NSLog(@"%@",responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        [SVProgressHUD dismiss];
    //        NSLog(@"%@",error);
    //    }];
    //
}

@end
