//
//  CreditCardView.h
//  
//
//  Created by USAePay on 4/18/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//
//  Purpose: Handles all the event for credit card field form
// 

#import <UIKit/UIKit.h>
#import "CustomUI.h"

@class uesoapTransactionResponse;

@interface CreditCardView : UIView

@property(nonatomic) id delegate;

/*
 * Classes
 */
@property(nonatomic, retain)CustomUI *customUI;


/*
 * This method returns the iphone view for credit card form
 * It will automaitcally deteremine the current device orientation
 * Then returns the correct view base on the orientation
 */
-(UIView *)getIPhoneView;

/*
 * This method returns the iPad view for credit card form
 * It will automaitcally deteremine the current device orientation
 * Then returns the correct view base on the orientation
 */
-(UIView *)getIPadView;

/*
 * This is the delegate method for the cancel button
 * You have to handle removing the veiw from the superview
 */
-(void)cancelBtnClickedDelegate;

/*
 * This delegate method gets call when transaction is completed
 * The method returns uesoapTransactionResponse object
 * Look at uesoapTransactionResponse class to get all its property
 */
-(void)transactionCompleted :(uesoapTransactionResponse *)response;

@end
