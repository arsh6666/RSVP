//
//  BidderVC.h
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidderVC : UIViewController<UITableViewDataSource,UITabBarDelegate>
@property NSString *drivewayID;
@property BOOL isMyDriveway;
@end
