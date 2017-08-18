//
//  MyDrivewayList.h
//  RSVP
//
//  Created by Maninder Singh on 16/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDrivewayList : UIViewController
@property NSString *typeOfParking;
@property (strong, nonatomic) IBOutlet UITableView *adressTableView;

@end
