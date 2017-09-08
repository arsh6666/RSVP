//
//  SessionTableViewCell.h
//  RSVP
//
//  Created by Arshdeep Singh on 02/09/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell
    @property (strong, nonatomic) IBOutlet UIButton *btnCancel;
    @property (strong, nonatomic) IBOutlet UILabel *lblName;

@end
