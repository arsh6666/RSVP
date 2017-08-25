//
//  ConfirmationVC.m
//  RSVP
//
//  Created by Maninder Singh on 25/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ConfirmationVC.h"
#import <AnetEMVSdk/AnetEMVSdk.h>
@interface ConfirmationVC ()<AuthNetDelegate>{
    NSString *token;
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
    [AuthNet authNetWithEnvironment:ENV_TEST];
    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = @"maninderbindra1991";
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = @"Iphone_5s";
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = @"2345234523453425";
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
    
    
   
    
}
- (IBAction)cancelButton:(id)sender {
}
- (IBAction)menuButton:(id)sender {
}


-(void)paymentSucceeded:(CreateTransactionResponse *)response{

}
-(void)emvPaymentSucceeded:(AnetEMVTransactionResponse *)response{

}

-(void)requestFailed:(AuthNetResponse *)response{

}

- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response {
    token = response.sessionToken;
    
    CreditCardType *creditCardType = [CreditCardType creditCardType];
    creditCardType.cardNumber = @"4111111111111111";
    creditCardType.cardCode = @"100";
    creditCardType.expirationDate = @"1222";
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = creditCardType;
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"AuthCaptureProduct";
    lineItem.itemDescription = @"AuthCaptureProductDescription";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = @"20";
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
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = @"2345234523453425";
    request.anetApiRequest.merchantAuthentication.sessionToken = token;
    
    AuthNet *an1 = [AuthNet getInstance];
    [an1 setDelegate:self];
    [an1 purchaseWithRequest:request];
};


@end
