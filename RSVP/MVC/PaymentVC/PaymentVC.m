//
//  PaymentVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "PaymentVC.h"

@interface PaymentVC (){
    NSDate* currentDate;
    NSDateComponents* dateComponents;
    NSDate* threeYearsAgo;
    NTMonthYearPicker *picker;
    KLCPopup *popup;
}
@property (strong, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UITextField *expriyDate;
@property (strong, nonatomic) IBOutlet UITextField *billingzip;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UITextField *cvvTextField;
- (IBAction)expireButton:(id)sender;

@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetSubmit:) name:@"SubmitEXP" object:nil ];
    
    currentDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 7]; //One week from now
    
    dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -70;
    
    threeYearsAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    // Do any additional setup after loading the view.
}
    
    -(IBAction)GetSubmit:(id)sender{
        [self updateLabel];
        [popup dismiss:YES];
    }

-(void)viewWillAppear:(BOOL)animated
{
    if (_isEditProfile)
    {
        _cardNumber.text = [NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"cardNumber"]];
        _expriyDate.text = [NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"exipryDate"]];
        _billingzip.text = [NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"billingZip"]];
        _cvvTextField.text = [NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"cvv"]];
        [_nextButton setTitle:@"Save" forState:normal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextButtonAction:(id)sender
{
    if (_isEditProfile)
    {
        [NSUserDefaults.standardUserDefaults setObject:_cardNumber.text forKey:@"cardNumber"];
        [NSUserDefaults.standardUserDefaults setObject:_expriyDate.text forKey:@"exipryDate"];
        [NSUserDefaults.standardUserDefaults setObject:_billingzip.text forKey:@"billingZip"];
        [NSUserDefaults.standardUserDefaults setObject:_cvvTextField.text forKey:@"cvv"];
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert showSuccess:self title:@"Alert" subTitle:@"your credit card has been successfully" closeButtonTitle:@"OK" duration:0.0f];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_cardNumber.text.length == 0){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter your card number." closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
        if (_cardNumber.text.length < 15){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid card number." closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
        if (_expriyDate.text.length == 0){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter expiration date." closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
        if (_cvvTextField.text.length == 0){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter cvv number." closeButtonTitle:@"OK" duration:0.0f];
            return;
        }if (_cvvTextField.text.length < 3){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter valid cvv number." closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
        if (_billingzip.text.length == 0){
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle:@"Please enter billing zip." closeButtonTitle:@"OK" duration:0.0f];
            return;
        }
        else{
            [NSUserDefaults.standardUserDefaults setObject:_cardNumber.text forKey:@"cardNumber"];
            [NSUserDefaults.standardUserDefaults setObject:_expriyDate.text forKey:@"exipryDate"];
            [NSUserDefaults.standardUserDefaults setObject:_cvvTextField.text forKey:@"cvv"];
            [NSUserDefaults.standardUserDefaults setObject:_billingzip.text forKey:@"billingZip"];
            BillingDetailVC *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BillingDetailVC"];
            //VC.userDetail = _userDetail;
            VC.userCardDetail = _userCarDetail;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}


- (IBAction)expireButton:(id)sender
{
   
    DateView *dateView = [[[NSBundle mainBundle] loadNibNamed:@"DateView" owner:self options:nil] objectAtIndex:0];
    dateView.layer.cornerRadius = 5.0f;
    dateView.clipsToBounds = YES;
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.frame = CGRectMake(0.0, 0.0, 300.0, 250.0);
    
    picker = [[NTMonthYearPicker alloc] init];
    
    [picker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    // Set mode to month + year
    // This is optional; default is month + year
    picker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
    
    // Set minimum date to January 2000
    // This is optional; default is no min date
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:2000];
    picker.minimumDate = [cal dateFromComponents:comps];
    
    [comps setDay:0];
    [comps setMonth:-1];
    [comps setYear:0];
    
    picker.date = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
    picker.frame = CGRectMake(0.0, 0.0, 300.0, 200.0);
    
    [dateView addSubview:picker];
    
    popup = [KLCPopup popupWithContentView:dateView];
    [popup show];

}
    
- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer
{
   // [self updateLabel];
}
    
    
- (void)updateLabel {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    if( picker.datePickerMode == NTMonthYearPickerModeMonthAndYear ) {
        [df setDateFormat:@"MM/yyyy"];
    } else {
        [df setDateFormat:@"yyyy"];
    }
    
    NSString *dateStr = [df stringFromDate:picker.date];
    self.expriyDate.text = dateStr;
   NSLog(@"Selected: %@", dateStr);
}
@end
