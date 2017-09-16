//
//  Constants.h
//  USAePayLibrary
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//  

#import <Foundation/Foundation.h>

#define REGEX_FOR_INTEGERS  @"^([+-]?)(?:|0|[1-9]\\d*)?$"

@interface Constants : NSObject

+(id)sharedManager;

/*
 * Change the boolean base on the environment
 * Set it to "true" when using production
 * Set it to "false" when using sand box environment
 */

@property(nonatomic) BOOL isProduction;

/*
 * Changes this to the source key and pin that you created
 */
@property(nonatomic, retain) NSString *sourceKey;
@property(nonatomic, retain) NSString *pinNum;

@end
