//
//  ParkInVC.h
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkInVC : UIViewController

@property BOOL EditBool;
@property NSDictionary *scheduleDict;
@property NSString *day;
@property NSString *typeOfParking;
@property NSString *toLabel;
@property NSString *fromLabel;
@property NSString *enableDisable;

@end
