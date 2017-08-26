//
//  VehicalDetail.h
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

//NSString *carModelId;
@interface VehicalDetail : UIViewController
@property NSDictionary *userDetail;
@property(nonatomic) NSString *carModelId;
@property(nonatomic) NSString *carModelName;
@property BOOL isEditProfile;
@property NSDictionary *userDetailFromEdited;
@property NSString *zellemail;
@property NSString *quckpay;
@property NSString *address;

@end
