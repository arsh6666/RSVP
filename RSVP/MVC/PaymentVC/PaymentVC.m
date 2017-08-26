//
//  PaymentVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "PaymentVC.h"

@interface PaymentVC ()
@property (strong, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UITextField *expriyDate;
@property (strong, nonatomic) IBOutlet UITextField *billingzip;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UITextField *cvvTextField;

@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    if (_isEditProfile) {
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
- (IBAction)nextButtonAction:(id)sender {
    if (_isEditProfile){
        [NSUserDefaults.standardUserDefaults setObject:_cardNumber.text forKey:@"cardNumber"];
        [NSUserDefaults.standardUserDefaults setObject:_expriyDate.text forKey:@"exipryDate"];
        [NSUserDefaults.standardUserDefaults setObject:_billingzip.text forKey:@"billingZip"];
        [NSUserDefaults.standardUserDefaults setObject:_cvvTextField.text forKey:@"cvv"];
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


@end
