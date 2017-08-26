//
//  AgreementVC.m
//  RSVP
//
//  Created by Maninder Singh on 25/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "AgreementVC.h"
#import <UserNotifications/UserNotifications.h>

@interface AgreementVC ()<AuthNetDelegate>
{
    NSTimer *timer;
    int currMinute;
    int currSeconds;NSString *token;
    NSString *uniqueIdentifier;
}
@property (strong, nonatomic) IBOutlet UILabel *sellerLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UILabel *buyerLabel;
@end

@implementation AgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    currMinute=30;
    currSeconds=00;
    [self webServiceUserDetail];
    [self start];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
   
    if (_markerData[@"Name"] != [NSNull null]){
         _sellerLabel.text = _markerData[@"Name"];
    }
    if (_markerData[@"Address"] != [NSNull null]){
        _addressLabel.text = _markerData[@"Address"];
    }

    [self setTime];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSString *timeOnDisappear = [dateFormatter stringFromDate:[NSDate date]];
    [NSUserDefaults.standardUserDefaults setObject:timeOnDisappear forKey:@"getTime"];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addMoreTime:(id)sender {
    uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [AuthNet authNetWithEnvironment:ENV_TEST];
    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = @"maninderbindra1991";
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = @"Iphone_5s";
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = uniqueIdentifier;
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
}
- (IBAction)complaintTransaction:(id)sender {
}


-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];

    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Alert";
    content.body = @"You have 5 min left, you can add more 5 min if you want.";
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1500 repeats:NO];
    
    NSString *identifier = @"UYLLocalNotification";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];


}

-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [_timeLabel setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [timer invalidate];
    }
}

-(void)paymentSucceeded:(CreateTransactionResponse *)response{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [self webService];
    [alert showSuccess:self title:@"Alert" subTitle:[NSString stringWithFormat:@"%@",response.responseReasonText] closeButtonTitle:@"Ok" duration:0.0f];
    currMinute = currMinute + 15;
    
}
-(void)emvPaymentSucceeded:(AnetEMVTransactionResponse *)response{
    
}

-(void)requestFailed:(AuthNetResponse *)response{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@",response.responseReasonText] closeButtonTitle:@"OK" duration:0.0f];
}

- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response {
    token = response.sessionToken;
    
    CreditCardType *creditCardType = [CreditCardType creditCardType];
    creditCardType.cardNumber = [NSUserDefaults.standardUserDefaults objectForKey:@"cardNumber"];
    creditCardType.cardCode = [NSUserDefaults.standardUserDefaults objectForKey:@"cvv"];
    creditCardType.expirationDate = [NSUserDefaults.standardUserDefaults objectForKey:@"exipryDate"];
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = creditCardType;
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"block";
    lineItem.itemDescription = @"address";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = @"5";
    lineItem.itemID = @"1";
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = lineItem.itemPrice;
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    requestType.shipping = extendedAmountTypeShipping;
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.transactionType = AUTH_CAPTURE;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = uniqueIdentifier;
    request.anetApiRequest.merchantAuthentication.sessionToken = token;
    
    AuthNet *an1 = [AuthNet getInstance];
    [an1 setDelegate:self];
    [an1 purchaseWithRequest:request];
}

-(void)setTime{
    NSString *getOldTime = [NSUserDefaults.standardUserDefaults objectForKey:@"getTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:getOldTime];
    NSDate *date2 = [NSDate date];
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];

}

-(void)webService{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSDictionary *dict = @{@"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"ToUserId": _markerData[@"userId"],
                           @"Amount": @5};
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SavePayment";
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
                   VehicalDetail *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"VehicalDetail"];
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

-(void)webServiceUserDetail{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetProfile?UserId=";
    NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]]];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URLToHit parameters:nil progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *jsonDict = responseObject;
              [SVProgressHUD dismiss];
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              
              if ([jsonDict[@"Success"] boolValue]){
                  _buyerLabel.text = jsonDict[@"FirstName"];
              }
              NSLog(@"%@",responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [SVProgressHUD dismiss];
              NSLog(@"%@",error);
          }];
    
}


@end
