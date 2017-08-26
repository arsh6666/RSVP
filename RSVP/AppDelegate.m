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
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error) {
                                  NSLog(@"request authorization succeeded!");
                                  //[self showAlert];
                              }
                          }];

    
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"isLogin"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mapNVC"];
        UIViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
        UIViewController *rightMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
      
        
        // Create side menu controller
        //
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:rightMenuViewController];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        
        // Make it a root controller
        //
        self.window.rootViewController = sideMenuViewController;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
        UIViewController *leftMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
        UIViewController *rightMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        
        
        // Create side menu controller
        //
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:rightMenuViewController];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        
        // Make it a root controller
        //
        self.window.rootViewController = sideMenuViewController;
    }
   
    
    // Override point for customization after application launch.
    return YES;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{

}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //[self takeActionWithLocalNotification:response.notification];
}

-(void)showAlert {
    UIAlertController *objAlertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"show an alert!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action) {
                                       NSLog(@"Ok clicked!");
                                   }];
    [objAlertController addAction:cancelAction];
    
    
    [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] presentViewController:objAlertController animated:YES completion:^{
        
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
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
