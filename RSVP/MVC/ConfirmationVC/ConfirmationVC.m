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
}

@end

@implementation ConfirmationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmationButton:(id)sender {

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
- (IBAction)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)paymentSucceeded:(CreateTransactionResponse *)response{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showSuccess:self title:@"Alert" subTitle:[NSString stringWithFormat:@"%@",response.responseReasonText] closeButtonTitle:@"Ok" duration:0.0f];
    [alert alertIsDismissed:^{
        [self webService];
    }];
    
}
-(void)emvPaymentSucceeded:(AnetEMVTransactionResponse *)response{

}

-(void)requestFailed:(AuthNetResponse *)response{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@",response.responseReasonText] closeButtonTitle:@"OK" duration:0.0f];
}

- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response {
    token = response.sessionToken;
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
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
    lineItem.itemPrice = @"10";
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
};


-(void)webService{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSDictionary *dict = @{@"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"ToUserId": _markerData[@"UserId"],
                           @"Amount": @10};
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SavePayment";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [SVProgressHUD dismiss];
               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
               NSDictionary *jsonDict = responseObject;
               if ([jsonDict[@"Success"] boolValue]){
                   
               }else{
                  
               }
               AgreementVC *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"AgreementVC"];
               VC.markerData = _markerData;
               [self.navigationController pushViewController:VC animated:YES];
               NSLog(@"%@",responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [SVProgressHUD dismiss];
               NSLog(@"%@",error);
           }];
    
}

@end
