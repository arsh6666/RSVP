//
//  uesoapCreditCardData.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uesoapObject.h"

@interface uesoapCreditCardData : uesoapObject {
	
	NSString *CardType;
	NSString *CardNumber;
	NSString *CardExpiration;
	NSString *CardCode;
	NSString *AvsStreet;
	NSString *AvsZip;
	BOOL 	CardPresent;
	NSString *MagStripe;
	NSString *DUKPT;
	NSString *Signature;
	NSString *TermType;
	NSString *MagSupport;
	NSString *XID;
	NSString *CAVV;
	int 	ECI;
	BOOL 	InternalCardAuth;
	NSString *Pares;
}

@property (readwrite, retain) NSString *CardType;
@property (readwrite, retain) NSString *CardNumber;
@property (readwrite, retain) NSString *CardExpiration;
@property (readwrite, retain) NSString *CardCode;
@property (readwrite, retain) NSString *AvsStreet;
@property (readwrite, retain) NSString *AvsZip;
@property (readwrite, nonatomic) BOOL 	CardPresent;
@property (readwrite, retain) NSString *MagStripe;
@property (readwrite, retain) NSString *DUKPT;
@property (readwrite, retain) NSString *Signature;
@property (readwrite, retain) NSString *TermType;
@property (readwrite, retain) NSString *MagSupport;
@property (readwrite, retain) NSString *XID;
@property (readwrite, retain) NSString *CAVV;
@property (readwrite, nonatomic) int 	ECI;
@property (readwrite, nonatomic) BOOL 	InternalCardAuth;
@property (readwrite, retain) NSString *Pares ;

-(id) initWithXML:(NSString *)string;

@end
