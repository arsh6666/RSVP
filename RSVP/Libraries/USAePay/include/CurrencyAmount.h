//
//  CurrencyAmount.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrencyAmount : NSObject {
	long long amount;
	unsigned int precision;
}

@property (nonatomic,readonly) long long amount;
@property (nonatomic,readonly) unsigned int precision;

-(NSString *)toString;
-(NSString *) toCurrencyString;
-(id)initWithString:(NSString *)string;
-(id)initWithAmount:(long long)intamount precision: (unsigned int)intprecision;
+(id)currencyamountWithString:(NSString *)string;


-(void)setPrecision:(unsigned int)newprecision;
-(CurrencyAmount *)add:(CurrencyAmount *)b;
-(CurrencyAmount *)addInt:(int)i;
-(CurrencyAmount *)sub:(CurrencyAmount *)b;
-(CurrencyAmount *)subInt:(int)i;
-(CurrencyAmount *)multiply:(CurrencyAmount *)b;
-(CurrencyAmount *)multiplyByInt:(int)i;
-(CurrencyAmount *)divide:(CurrencyAmount *)b;
-(CurrencyAmount *)divideByInt:(int)i;

-(NSString *)debugDump;

@end
