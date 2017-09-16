//
//  uesoapObject.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface uesoapObject : NSObject {

}

-(NSString *) parseTag:(NSString *)tagname xmlData:(NSString *) xml;
-(NSString *)xmlEntities:(NSString *)instr;
+ (NSString *)htmlEntityDecode:(NSString *)instr;

@end
