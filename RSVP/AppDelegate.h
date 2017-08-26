//
//  AppDelegate.h
//  RSVP
//
//  Created by Arshdeep Singh on 28/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) BOOL isLogin;

AppDelegate *appDelegate(void);
@end

