//
//  ueJsonToken.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ueJsonToken : NSObject{
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *pin;

-(id) initWithSourceKey:(NSString *)sourcekey pin:(NSString *)sourcepin;

-(NSString *) generateJSONHash:(NSString *)url;
+(NSString *) md5:(NSString *) str;

@end
