//
//  CustomUI.h
//
//
//  Created by USAePay on 4/24/14.
//  Copyright (c) 2014 USAePay. All rights reserved.
//
//  Purpose: Creates/Initialize all the UI that is required by credit card form

#ifdef __IPHONE_6_0
#define ALIGN_LEFT NSTextAlignmentLeft
#define ALIGN_RIGHT NSTextAlignmentRight
#define ALIGN_CENTER NSTextAlignmentCenter
#define LINE_TRUNCATE NSLineBreakByTruncatingTail
#else
#define ALIGN_LEFT UITextAlignmentLeft
#define ALIGN_LEFT UITextAlignmentRight
#define ALIGN_CENTER UITextAlignmentCenter
#define LINE_TRUNCATE UILineBreakModeTailTruncation

#endif

#import <UIKit/UIKit.h>

@interface CustomUI : UIView

@property(nonatomic) id delegate;

/*
 * This is the total value that will be use as the total charge amount
 */
@property(nonatomic, retain) NSString *totalChargeAmount;

/*
 *Sets the screen width and height
 */
@property(nonatomic)CGFloat screenWidth;
@property(nonatomic)CGFloat screenHeight;

/*
 * This is the background view of the credit card form
 * Modify this to change the background color of the view
 */
@property(nonatomic, retain)UIView *customBackgroundView;

/*
 * This is the title background for the total amount
 * Modify this to change the background color for title bar
 */
@property(nonatomic, retain)UIView *customTitlebarBgView;

/*
 * Sets the total amount to charge the user
 * The default value is 0.00
 */
@property(nonatomic, retain)NSString *totalAmount;

/*
 * This is not required
 * Sets the invoice value for this transaction
 * The default invoice value is 1234
 */
@property(nonatomic, retain)NSString *invoiceNumber;

/*
 * You can change the loading indicator color or size
 */
@property(nonatomic, retain)UIActivityIndicatorView *ccLoadingIndicator;

/*
 *UIScrollview
 */
@property(nonatomic, retain) UIScrollView *ccScrollBackground;

/*
 * UILabels
 */
@property(nonatomic, retain)UILabel *acceptLabel;
@property(nonatomic, retain)UILabel *cardHolderNameLabel;
@property(nonatomic, retain)UILabel *cardNumLabel;
@property(nonatomic, retain)UILabel *cardExpLabel;
@property(nonatomic, retain)UILabel *cardCVVLabel;
@property(nonatomic, retain)UILabel *avsStreeLabel;
@property(nonatomic, retain)UILabel *avsZipLabel;
@property(nonatomic, retain)UILabel *totalAmountTitleLabel;
@property(nonatomic, retain)UILabel *totalPriceLabel;

/*
 *UIButton
 */
@property(nonatomic, retain)UIButton *cancelBtn;
@property(nonatomic, retain)UIButton *payBtn;
@property(nonatomic, retain)UIButton *topLineBtn;

/*
 *UIImage
 */
@property(nonatomic, retain)UIImage *amexImg;
@property(nonatomic, retain)UIImage *visaImg;
@property(nonatomic, retain)UIImage *masterImg;
@property(nonatomic, retain)UIImage *discoveryImg;
@property(nonatomic, retain)UIImage *jcbImg;

/*
 * UIImageView
 */
@property(nonatomic, retain)UIImageView *amexImgView;
@property(nonatomic, retain)UIImageView *visaImgView;
@property(nonatomic, retain)UIImageView *masterImgView;
@property(nonatomic, retain)UIImageView *discoveryImgView;
@property(nonatomic, retain)UIImageView *jcbImgView;

/*
 * UITextField
 */
@property(nonatomic, retain)UITextField *cardHolderNameTxtField;
@property(nonatomic, retain)UITextField *cardNumTxtField;
@property(nonatomic, retain)UITextField *cardExpTxtField;
@property(nonatomic, retain)UITextField *cardCVVTxtField;
@property(nonatomic, retain)UITextField *totalAmountField;
@property(nonatomic, retain)UITextField *avsAddressField;
@property(nonatomic, retain)UITextField *avsZipField;

/*
 * UIToolbar & barbutton items
 */
@property(nonatomic, retain)UIToolbar *keyboardToolbar;
@property(nonatomic, retain)UIBarButtonItem *previousBtn;
@property(nonatomic, retain)UIBarButtonItem *nextBtn;
@property(nonatomic, retain)UIBarButtonItem *extraSpace;
@property(nonatomic, retain)UIBarButtonItem *doneBtn;

/*
 * Gets the screen size of the device
 */
@property(nonatomic)CGSize screenSize;

/*
 * Call this method to initialize the custom view
 */
-(void)ccViewInitialize :(BOOL)isIPhoneView;

/*
 * Delegate methods for toobar buttons such as previous, next, and done
 */
-(void)previousField;
-(void)nextField;
-(void)doneClicked;

@end
