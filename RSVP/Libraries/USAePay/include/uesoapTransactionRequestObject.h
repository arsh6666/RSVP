//
//  uesoapTransactionRequestObject.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class uesoapTransactionDetail;
@class uesoapCreditCardData;
@class uesoapCheckData;
@class uesoapAddress;
@class uesoapRecurring;

@interface uesoapTransactionRequestObject : NSObject {

	NSString *Command;
	BOOL IgnoreDuplicate;
	NSString *AuthCode;
	NSString *RefNum;
	NSString *AccountHolder;
	uesoapTransactionDetail *Details;
	uesoapCreditCardData *CreditCardData;
	uesoapCheckData *CheckData;
	NSString *ClientIP;
	NSString *CustomerID;
	uesoapAddress *BillingAddress;
	uesoapAddress *ShippingAddress;	
	BOOL CustReceipt;	
	NSString *CustReceiptName;
	NSString *Software;
	uesoapRecurring *RecurringBilling;
	NSString *Location;
	NSString *LineItemData;
    NSString *CustomFieldsData;
	
}

@property (readwrite, retain) NSString *Command;
@property (readwrite, nonatomic) BOOL IgnoreDuplicate;
@property (readwrite, retain) NSString *AuthCode;
@property (readwrite, retain) NSString *RefNum;
@property (readwrite, retain) NSString *AccountHolder;
@property (readwrite, retain) uesoapTransactionDetail *Details;
@property (readwrite, retain) uesoapCreditCardData *CreditCardData;
@property (readwrite, retain) uesoapCheckData *CheckData;
@property (readwrite, retain) NSString *ClientIP;
@property (readwrite, retain) NSString *CustomerID;
@property (readwrite, retain) uesoapAddress *BillingAddress;
@property (readwrite, retain) uesoapAddress *ShippingAddress;
@property (readwrite, nonatomic) BOOL CustReceipt;
@property (readwrite, retain) NSString *CustReceiptName;
@property (readwrite, retain) NSString *Software;
@property (readwrite, retain) NSString *Location;
@property (readwrite, retain) uesoapRecurring *RecurringBilling;
@property (readwrite, retain) NSString *LineItemData;
@property (readwrite, retain) NSString *CustomFieldsData;

@end
