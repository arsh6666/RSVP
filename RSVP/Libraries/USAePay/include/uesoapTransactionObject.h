//
//  uesoapTransactionObject.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uesoapObject.h"

@class uesoapTransactionResponse;
@class uesoapCheckTrace;
@class uesoapTransactionDetail;
@class uesoapCreditCardData;
@class uesoapAddress;

@interface uesoapTransactionObject : uesoapObject {
	
	
	NSString *Status; //Status of specified transaction.
	uesoapTransactionResponse *Response; //Gateway response details, includes AuthCode etc.
	NSString *TransactionType; //Type of transaction. (Sale, Credit, Void, AuthOnly, etc.)
	uesoapCheckTrace *CheckTrace; //Tracking data for check transactions. Includes tracking number, effective posting date, date processed, date settled, date returned and bank notes.
	NSString *DateTime; //Date/time transaction was originally submitted.
	NSString *AccountHolder; //Name of the account holder.
	uesoapTransactionDetail 	*Details; //Transaction details. (amount, invoice number, clerk, description, currency, etc.)
	uesoapCreditCardData 	*CreditCardData; //Credit card specific data. (card type, number, expiration date, etc.)

	NSString *User; //The username of the person who processed this transaction.
	NSString *Source; //The name of the source key that this transaction was processed under.
	NSString *ServerIP; //IP Address of the server that submitted the transaction to the gateway.
	NSString *ClientIP; //IP Address of client (if passed on from the server).
	NSString *CustomerID; //Customer ID
	uesoapAddress 	*BillingAddress; //Billing Address
	uesoapAddress 	*ShippingAddress; //Shipping Address
	//FieldValue 	CustomFields 	Array of custom transaction fields 
	
}

@property (readwrite, retain) NSString *Status;
@property (readwrite, retain) uesoapTransactionResponse *Response;
@property (readwrite, retain) NSString *TransactionType;
@property (readwrite, retain) uesoapCheckTrace *CheckTrace;
@property (readwrite, retain) NSString *DateTime;
@property (readwrite, retain) NSString *AccountHolder;
@property (readwrite, retain) uesoapTransactionDetail *Details;
@property (readwrite, retain) uesoapCreditCardData *CreditCardData;
@property (readwrite, retain) NSString *User;
@property (readwrite, retain) NSString *Source;
@property (readwrite, retain) NSString *ServerIP;
@property (readwrite, retain) NSString *ClientIP;
@property (readwrite, retain) NSString *CustomerID;
@property (readwrite, retain) uesoapAddress *BillingAddress;
@property (readwrite, retain) uesoapAddress *ShippingAddress;

-(id) initWithXML:(NSString *)string;


@end
