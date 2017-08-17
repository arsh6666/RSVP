//
//  BillingDetailVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "BillingDetailVC.h"

@interface BillingDetailVC ()
@property (strong, nonatomic) IBOutlet UITextField *qickpayemail;
@property (strong, nonatomic) IBOutlet UITextField *zellemail;
@property (strong, nonatomic) IBOutlet UITextField *monthlyChecks;

@end

@implementation BillingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextButtonAction:(id)sender {
    if (_qickpayemail.text.length == 0 && _zellemail.text.length == 0 && _monthlyChecks.text.length == 0){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter one of the textfield." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }else{
        if (_drivewayToRentSwitch.isOn){
            DriveWayInfoVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DriveWayInfoVC"];
            [self.navigationController pushViewController:hvc animated:YES];
        }else{
            MapViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            [self.navigationController pushViewController:hvc animated:YES];
        }
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
