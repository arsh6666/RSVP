//
//  EditProfileVC.m
//  RSVP
//
//  Created by Maninder Singh on 21/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *qucikPayMail;
@property (strong, nonatomic) IBOutlet UITextField *zellemail;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMyDetail];
    // Do any additional setup after loading the view.
}

-(void)setUpMyDetail
{
   // NSLog(@"%@",self.myProfileDetail);
    _firstName.text = _myProfileDetail[@"FirstName"];
    _lastName.text = _myProfileDetail[@"LastName"];
    _nickName.text = _myProfileDetail[@"NickName"];
    _email.text = _myProfileDetail[@"Email"];
    _phoneNumber.text = _myProfileDetail[@"PhoneNumber"];
    NSDictionary *cardDict = _myProfileDetail[@"Car"];
    
    if (cardDict[@"ZailleMail"] != [NSNull null]){
        _zellemail.text = cardDict[@"ZailleMail"];
    }
    if (cardDict[@"ChaseQuickpayEmail"] != [NSNull null]){
        _qucikPayMail.text = cardDict[@"ChaseQuickpayEmail"];
    }
    if (cardDict[@"AddressMonthly"] != [NSNull null]){
        _address.text = cardDict[@"AddressMonthly"];
    }
}

- (IBAction)backButtonACtion:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButtonAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    if (_firstName.text.length == 0)
    {
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter first name." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_lastName.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Last name." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_nickName.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Nick name." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if(_phoneNumber.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Phone Number." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if(_phoneNumber.text.length < 10){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid Phone Number." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_email.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter email address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (![Utils isValidEmail:_email.text]){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid email address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }else{
        [self saveEditProfile];
        
    }
}



- (IBAction)editCardDetailButton:(id)sender
{
//    VehicalDetail *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VehicalDetail"];
//    vc.userDetailFromEdited = _myProfileDetail;
//    vc.zellemail = _zellemail.text;
//    vc.address = _address.text;
//    vc.quckpay = _qucikPayMail.text;
//    vc.isEditProfile = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}


-(void)saveEditProfile
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           @"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"FirstName":_firstName.text,
                           @"LastName": _lastName.text,
                           @"NickName": _nickName.text,
                           @"PhoneNumber":_phoneNumber.text
                           };
   
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:EditProfile parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSDictionary *jsonDict = responseObject;
               [SVProgressHUD dismiss];
               if ([jsonDict[@"Success"] boolValue]){
                   [self updatecarDetail];
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

-(void)updatecarDetail
{
    [SVProgressHUD show];
    NSDictionary *cardDict = _myProfileDetail[@"Car"];

    NSDictionary *dict = @{@"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"Brand":cardDict[@"Brand"],
                           @"Model":cardDict[@"Model"],
                           @"Color":cardDict[@"Color"],
                           @"Class":cardDict[@"Class"],
                           @"Plate":cardDict[@"Plate"],
                           @"ZelleEmail":_zellemail.text,
                           @"ChaseQuickpayEmail":_qucikPayMail.text,
                           @"AddressMonthly":_address.text,
                           @"State":cardDict[@"State"]};
    
    
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SaveCar";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 PUT:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = responseObject;
        [SVProgressHUD dismiss];
        if ([jsonDict[@"Success"] boolValue]){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle: @"Save Successfully" closeButtonTitle:@"OK" duration:0.0f];
        }else{
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@", jsonDict[@"Message"]] closeButtonTitle:@"OK" duration:0.0f];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        NSLog(@"%ld",(long)[response statusCode]);
        NSData *dict2 = [error.userInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:dict2 options:0 error:NULL];
    
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

@end
