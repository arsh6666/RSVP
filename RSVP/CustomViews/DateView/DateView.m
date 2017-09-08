//
//  DateView.m
//  RSVP
//
//  Created by Arshdeep Singh on 02/09/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "DateView.h"

@implementation DateView
- (IBAction)btnSubmit:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SubmitEXP" object:nil userInfo:nil ];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
