//
//  CarMakeVC.h
//  RSVP
//
//  Created by Maninder Singh on 13/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol senddataProtocol <NSObject>

-(void)sendDataToVehicleVC:(NSDictionary *)Dict; //I am thinking my data is NSArray, you can use another object for store your information.

@end

@interface CarMakeVC : UIViewController<UITableViewDataSource,UITabBarDelegate>
@property(nonatomic,assign)id delegate;

@end
