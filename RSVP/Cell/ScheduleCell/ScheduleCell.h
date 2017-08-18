//
//  ScheduleCell.h
//  RSVP
//
//  Created by Maninder Singh on 18/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UILabel *yesNoLabel;

@end
