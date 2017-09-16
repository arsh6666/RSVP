//
//  uesoapGetReportResponse.h
//  USAePay
//
//  Created by USAePay on 4/17/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uesoapObject.h"

@interface uesoapGetReportResponse : uesoapObject{
    NSString *GetReportReturn;
}
@property(nonatomic, retain) NSString *GetReportReturn;
-(id) initWithXML:(NSString *)string;

@end
