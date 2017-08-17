//
//  CustomAnnotation.h
//  RSVP
//
//  Created by Maninder Singh on 13/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomAnnotation : MKAnnotationView

@property NSDictionary *markerDict;
@property NSInteger driwayId;
@property BOOL *owner;
@property BOOL *rented;
@property BOOL *sharing;
@property NSString *comment;
@property BOOL *AvailableBlock;
@property BOOL *SpaceAvailableForRegularCar;
@property NSString *CommentForSpace;
@property BOOL *ParkingRule;
@property NSString *Rule;
@property NSString *Latitude;
@property NSString *Longitude;


- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                             markerDict:(NSDictionary*)markerDict;

@end
