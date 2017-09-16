//
//  CreditCardPayment.h
//  USAePayLibrary
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class uesoapTransactionResponse;

@interface CreditCardPayment : NSObject

@property(nonatomic) id delegate;

/*
 * Make sure you set all these credit card information first
 * Before you call the credit card payment process
 */

@property(nonatomic, retain)NSString *creditCardNumber;
@property(nonatomic, retain)NSString *creditCardExpDate;
@property(nonatomic, retain)NSString *creditCardCVV;
@property(nonatomic, retain)NSString *creditCardHolderName;
@property(nonatomic, retain)NSString *creditCardAvsStreet;
@property(nonatomic, retain)NSString *creditCardAvsZip;
@property(nonatomic, retain)NSString *creditCardChargeAmount;
@property(nonatomic, retain)NSString *invoiceNumber;

//----------------------------//-----------------------------

/*
 * Use to determine if user is using JCB credit card or other credit cards
 * Returns true if the credit card is JCB, return false for everything else
 */
-(BOOL)isJCBCard:(NSString *)cardNumber;

/*
 * Holds the credit card payment process message
 * If the credit card couldn't process, call this to get the fail reason
 * It will display messages such as "Unable to authorize credit card",
 * "It is not a valid credit card", "no internet connection is detective", and etc..
 */
@property(nonatomic, retain)NSString *getProcessCCFailMsg;

/*
 * Call this method to verify credit card
 * Needs to pass in the credit card number as a NSString
 * The method returns true if credit card is valid
 * If the credit card is invalid, it will return false
 */
-(BOOL)verifyCreditCard:(NSString *)cardNumber;

/*
 * Call this method to verify the credit card's expiration date
 * Will get the expiration date as string values in the form of mm/yy
 * The method returns true if it's a valid expiration date
 * If the expiration date is invalid, it will return false
 */
-(BOOL)verifyExpDate:(NSString *)expDate;

/*
 * Call this method to process payment with apple pay
 * It takes in the PKPaymentToken payment data and the invoice number as parameter
 * finishProcessingPayment, will get call once the payment is finish processing
 */
-(void)processApplePay:(NSData *)tokenData :(NSString *)invoiceNum;


/*
 * Call this method to process credit card payment once you have all the required fields
 * Required fields are creditCardNumber, creditCardExpDate, creditCardCVV, creditCArdHolderName, creditCardAvsStreet, creditCardAvsZip
 */
-(void)processCCPayment;

/*
 * This delegate method gets call when the payment is finished processing
 * It will return the processing result regarding to the transaction
 * Such ass Approved, failed, error and etc..
 */
-(void)finishProcessingPayment :(uesoapTransactionResponse *)response;

@end
