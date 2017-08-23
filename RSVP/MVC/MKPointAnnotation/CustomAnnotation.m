//
//  CustomAnnotation.m
//  RSVP
//
//  Created by Maninder Singh on 13/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation markerDict:(NSDictionary *)markerDict{
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:nil];
    
    self.markerDict = markerDict;
    // Callout settings - if you want a callout bubble
    self.canShowCallout = YES;
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //driveway = 1
    //block = 2
    //steet = 3
    NSString *ParkingType = markerDict[@"ParkingType"];
    if ([ParkingType  isEqual: @"Driway"]){
        self.image = [UIImage imageNamed:@"bluemarker"];
    }
    if ([ParkingType  isEqual: @"Block"]){
        self.image = [UIImage imageNamed:@"blackmarker"];
    }else{
        self.image = [UIImage imageNamed:@"map-marker"];
    }
    return self;

}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}


@end
