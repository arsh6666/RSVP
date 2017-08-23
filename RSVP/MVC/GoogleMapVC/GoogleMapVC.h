//
//  GoogleMapVC.h
//  RSVP
//
//  Created by Maninder Singh on 22/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getCordsDelegates<NSObject>
-(void) getCordinates : (CLLocationCoordinate2D)coordintes;
@end

@interface GoogleMapVC : UIViewController
@property(nonatomic,assign)id delegate;
@end
