//
//  uesoapTransactionDetail.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uesoapObject.h"

@class CurrencyAmount;

@interface uesoapTransactionDetail : uesoapObject {
	

	NSString *Invoice;
	NSString *PONum;
	NSString *OrderID;
	NSString *Clerk;
	NSString *CheckNum;
	NSString *Terminal;
	NSString *Table;
	NSString *Description;
	NSString *Comments;
	int 	Currency;
	CurrencyAmount 	*Tip;
	BOOL 	NonTax;
    BOOL AllowPartialAuth;
	CurrencyAmount 	*Shipping;
	CurrencyAmount 	*Discount;
	CurrencyAmount 	*Subtotal;
	
}

@property (readwrite, retain) NSString *Invoice;
@property (readwrite, retain) NSString *PONum;
@property (readwrite, retain) NSString *OrderID;
@property (readwrite, retain) NSString *Clerk;
@property (readwrite, retain) NSString *CheckNum;
@property (readwrite, retain) NSString *Terminal;
@property (readwrite, retain) NSString *Table;
@property (readwrite, retain) NSString *Description;
@property (readwrite, retain) NSString *Comments;
@property (nonatomic, retain) NSString *amountOwe;
@property (nonatomic, retain) NSString *taxAmount;
@property (readwrite, nonatomic) int 	Currency;
@property (readwrite, retain) CurrencyAmount 	*Tip;
@property (readwrite, nonatomic) BOOL 	NonTax;
@property (readwrite, nonatomic) BOOL AllowPartialAuth;
@property (readwrite, retain) CurrencyAmount 	*Shipping;
@property (readwrite, retain) CurrencyAmount 	*Discount;
@property (readwrite, retain) CurrencyAmount 	*Subtotal;

-(NSString *) getXML;
-(id) initWithXML:(NSString *)string;

@end
