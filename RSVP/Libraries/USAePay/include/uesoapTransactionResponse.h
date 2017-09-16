//
//  uesoapTransactionResponse.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uesoapObject.h"
@class CurrencyAmount;

@interface uesoapTransactionResponse : uesoapObject {

	
	int RefNum;		// Transaction Reference Number
	int BatchRefNum;		// 	Batch Reference Number assigned by Gateway.
	int BatchNum;		// 	Batch Sequence Number
	NSString *Result;		// 	Transaction Result (Approved, Declined, Error, etc)
	NSString *ResultCode;		// 	Single character result code (A, D, or E)
	NSString *AuthCode;		// 	Authorization Code
	NSString *AvsResultCode;		// 	AVS Result Code (1-3 characters)
	NSString *AvsResult;		// 	Text Description of AvsResultCode
	NSString *CardCodeResultCode;		// 	Card Code (CVV2) Verification Result Code (1 character)
	NSString *CardCodeResult;		// 	Text Description of Card Code Result
	int ErrorCode;		// 	Error Code (if transaction resulted in error)
	int CustNum;		// 	System assigned CustNum of stored customer record if one was used or created
	NSString *Error;		// 	Text Description of Error Code
	NSString *AcsUrl;		// 	ACS Url for Verified by Visa or Mastercard Secure Code.
	NSString *Payload;		// 	Payload for Verified by Visa or Mastercard Secure Code.
	NSString *VpasResultCode;		// 	Vpas Result Code.
	BOOL 	isDuplicate;		// 	If true, a duplicate transaction was detected and the response data returned is from original transaction.
	CurrencyAmount 	*ConvertedAmount;		// 	Transaction amount converted to new currency.
	NSString *ConvertedAmountCurrency ;		//	Currency code for new currency.
	CurrencyAmount 	*ConversionRate;		// 	Rate used to convert transaction amount.
	NSString *Status;		// 	Description of transaction status
	NSString *StatusCode;		//
    CurrencyAmount *authAmount; // Amount that was authorized. Could be less that Amount requested if AllowPartialAuth was true
}

@property (readwrite, nonatomic) int RefNum;
@property (readwrite, nonatomic) int BatchRefNum;
@property (readwrite, nonatomic) int BatchNum;
@property (readwrite, retain) NSString *Result;
@property (readwrite, retain) NSString *ResultCode;
@property (readwrite, retain) NSString *AuthCode;
@property (readwrite, retain) NSString *AvsResultCode;
@property (readwrite, retain) NSString *AvsResult;
@property (readwrite, retain) NSString *RemainBalance;
@property (readwrite, retain) NSString *CardCodeResultCode;
@property (readwrite, retain) NSString *CardCodeResult;
@property (readwrite, nonatomic) int ErrorCode;
@property (readwrite, nonatomic) int CustNum;
@property (readwrite, retain) NSString *Error;
@property (readwrite, retain) NSString *AcsUrl;
@property (readwrite, retain) NSString *Payload;
@property (readwrite, retain) NSString *VpasResultCode;
@property (readwrite, nonatomic) BOOL 	isDuplicate;
@property (readwrite, retain) CurrencyAmount 	*ConvertedAmount;
@property (readwrite, retain) NSString *ConvertedAmountCurrency;
@property (readwrite, retain) CurrencyAmount 	*ConversionRate;
@property (readwrite, retain) NSString *Status;
@property (readwrite, retain) NSString *StatusCode;
@property (readwrite, retain) CurrencyAmount *authAmount;

-(id) initWithXML:(NSString *)string;
	
@end
