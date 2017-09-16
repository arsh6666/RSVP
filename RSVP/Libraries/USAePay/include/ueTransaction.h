//
//  ueTransaction.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ueTransaction : NSObject {
	NSString *transid;
	NSString *type;
	NSString *status;
	NSString *response;
	NSString *reason;
	NSString *errorcode;
	NSString *created;
	NSString *batchid;
	NSString *authcode;
	
	NSString *invoice;
	NSString *ponum;
	NSString *cardholder;
	NSString *cardtype;
	NSString *card4last;
	NSString *avsstreet;
	NSString *avszip;
	NSString *amount;
	NSString *tax;
	NSString *tip;
	NSString *description;
	NSString *email;

}


@property (readwrite, retain) NSString *transid;
@property (readwrite, retain) NSString *type;
@property (readwrite, retain) NSString *status;
@property (readwrite, retain) NSString *response;
@property (readwrite, retain) NSString *reason;
@property (readwrite, retain) NSString *errorcode;
@property (readwrite, retain) NSString *created;
@property (readwrite, retain) NSString *batchid;
@property (readwrite, retain) NSString *authcode;

@property (readwrite, retain) NSString *invoice;
@property (readwrite, retain) NSString *ponum;
@property (readwrite, retain) NSString *cardholder;
@property (readwrite, retain) NSString *cardtype;
@property (readwrite, retain) NSString *card4last;
@property (readwrite, retain) NSString *avsstreet;
@property (readwrite, retain) NSString *avszip;
@property (readwrite, retain) NSString *amount;
@property (readwrite, retain) NSString *tax;
@property (readwrite, retain) NSString *tip;
@property (readwrite, retain) NSString *description;
@property (readwrite, retain) NSString *email;


@end
