//
//  AppDelegate.m
//  RSVP
//
//  Created by Arshdeep Singh on 28/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "AppDelegate.h"
#import "DEMORootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GMSServices provideAPIKey:@"AIzaSyAT4NNoOQrBYgaUBqLsJmDaw1CnfkOe4CY"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyAT4NNoOQrBYgaUBqLsJmDaw1CnfkOe4CY"];
    [[SingleLineTextField appearance] setLineDisabledColor:[UIColor cyanColor]];
    [[SingleLineTextField appearance] setLineNormalColor:[UIColor grayColor]];
    [[SingleLineTextField appearance] setLineSelectedColor:[UIColor whiteColor]];
    [[SingleLineTextField appearance] setInputPlaceHolderColor:[UIColor whiteColor]];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
    
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
   

#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
#endif
    
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
//                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                              if (!error) {
//                                  NSLog(@"request authorization succeeded!");
//                                  //[self showAlert];
//                              }
//                          }];

    
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"isLogin"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mapNVC"];
        UIViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
       
        
        // Create side menu controller
        //
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        
        // Make it a root controller
        //
        self.window.rootViewController = sideMenuViewController;
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
        UIViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
        
        
        // Create side menu controller
        //
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        
        // Make it a root controller
        //
        self.window.rootViewController = sideMenuViewController;
    }
   
    
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    appDelegate().deviceToken = token;
    NSLog(@"content---%@", token);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@",err);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSDictionary *dict = [userInfo valueForKey:@"aps"];
    
    if(application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notification" message:[dict valueForKey:@"messageText"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification" message:<#(nullable NSString *)#> preferredStyle:<#(UIAlertControllerStyle)#>]
        
  //      [Utils okAlert:@"Notification" message:[dict valueForKey:@"messageText"]];
        //app is currently active, can update badges count here
        
    }
    else if(application.applicationState == UIApplicationStateBackground){
        
        //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
        
    }
    else if(application.applicationState == UIApplicationStateInactive){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ActiveSessionViewController *hvc = [storyboard instantiateViewControllerWithIdentifier:@"ActiveSessionViewController"];
        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
        
        UIViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
        
        
        // Create side menu controller
        //
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:MainNav
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:nil];
        
        // Make it a root controller
        //
        self.window.rootViewController = sideMenuViewController;

        
    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
//    UIApplicationState state = [uiapplicationst sharedApplication];
//    if(application.applicationState == UIApplicationStateActive) {
//        
//        [Utils okAlert:@"Notification" message:[dict valueForKey:@"messageText"]];
//        //app is currently active, can update badges count here
//        
//    }
//    else if(application.applicationState == UIApplicationStateBackground){
//        
//        //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
//        
//    }
//    else if(application.applicationState == UIApplicationStateInactive){
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        ActiveSessionViewController *hvc = [storyboard instantiateViewControllerWithIdentifier:@"ActiveSessionViewController"];
//        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
//        
//        UIViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
//        
//        
//        // Create side menu controller
//        //
//        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:MainNav
//                                                                        leftMenuViewController:leftMenuViewController
//                                                                       rightMenuViewController:nil];
//        
//        // Make it a root controller
//        //
//        self.window.rootViewController = sideMenuViewController;
//        
//        
//    }

    //[self takeActionWithLocalNotification:response.notification];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


AppDelegate *appDelegate (void)
{
    return [[UIApplication sharedApplication]delegate];
}

@end
