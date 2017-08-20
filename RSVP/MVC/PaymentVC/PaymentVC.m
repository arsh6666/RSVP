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

@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonAction:(id)sender {
    
    if (_cardNumber.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter your card number." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_expriyDate.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter expiration date." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_billingzip.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter billing zip." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }else{
        [NSUserDefaults.standardUserDefaults setObject:_cardNumber.text forKey:@"cardNumber"];
        [NSUserDefaults.standardUserDefaults setObject:_expriyDate.text forKey:@"exipryDate"];
        [NSUserDefaults.standardUserDefaults setObject:_billingzip.text forKey:@"billingZip"];
        BillingDetailVC *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BillingDetailVC"];
        VC.userDetail = _userDetail;
        VC.userCardDetail = _userCarDetail;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
