//
//  ueConnection.h
//  USAePayLibrary
//
//  Created by USAePay on 4/29/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

typedef enum : NSInteger {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;

@interface ueConnection : NSObject

/*
 * Returns true if there is internet
 * Returns false if there is no internet connectivity
 */
+(BOOL)isConnected;

/*
 * Use to check the reachability of a host
 */
+(instancetype)reachabilityWithHostName:(NSString *)hostName;

-(NetworkStatus)currentReachabilityStatus;

-(BOOL)connectionRequired;

@end
