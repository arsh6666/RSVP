//
//  ueSession.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ueSession : NSObject {
	NSString *sessionkey;
	NSString *challenge;
	
	NSString *swkey;
	NSString *sourcepin;
	NSString *sourcekey;
    NSString *host;
}

@property (nonatomic, retain) NSString *swkey;
@property (nonatomic, retain) NSString *sourcepin;
@property (nonatomic, retain) NSString *sourcekey;

@property (nonatomic, retain) NSString *host;

-(void) openSession:(NSString *)softwarekey;
-(void) authenticateSession:(NSString *)username  withPassword:(NSString *)password;
-(void) registerSoftware:(NSString *) softwareName;

-(NSString *) rawurlencode:(NSString *)rawdata;
-(NSString *) rawurldecode:(NSString *)rawdata;

-(NSString *) postToURL:(NSString *)url data:(NSString *)requestBody;
-(NSString *) generateHandshake;

@end
