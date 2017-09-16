//
//  StreetAgreementPageVC.m
//  RSVP
//
//  Created by Arshdeep Singh on 03/09/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "StreetAgreementPageVC.h"

@interface StreetAgreementPageVC ()<MFMailComposeViewControllerDelegate>{
    NSDictionary *sellerProfile;
}
    
    @property (strong, nonatomic) IBOutlet UILabel *lblCenter;
    @property (strong, nonatomic) IBOutlet UILabel *lblBNickName;
    @property (strong, nonatomic) IBOutlet UILabel *lblSNickName;
    @property (strong, nonatomic) IBOutlet UILabel *lbl_B_Detail;
    @property (strong, nonatomic) IBOutlet UILabel *lbl_S_Detail;
    @property (strong, nonatomic) IBOutlet UILabel *lblPhone;
    @property (strong, nonatomic) IBOutlet UILabel *lbl_S_Phone;
    @property (strong, nonatomic) IBOutlet UILabel *lblTimer;
    @property (strong, nonatomic) IBOutlet UILabel *lbl;
    
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
- (IBAction)btnComplaint:(id)sender;

@end

@implementation StreetAgreementPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Seller Detail %@",self.markerData);
    
    self.lblAddress.text = [self.markerData valueForKey:@"AproveAddress"];
    
    NSLog(@"UserDetail %@",self.UserProfile);
    
    [self GetUserProfile];
    
    // Do any additional setup after loading the view.
}

    -(void)GetUserProfile{
        
        [SVProgressHUD show];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        NSString *URL = [NSString stringWithFormat:@"%@?UserId=%@",GetProfile,[self.markerData valueForKey:@"UserId"]];
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager1 GET: URL parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
                  NSDictionary *jsonDict = responseObject;
                [SVProgressHUD dismiss];
                  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                  
                  if ([jsonDict[@"Success"] boolValue]){
                      
                      sellerProfile = responseObject;
                      [self UpdateView];

                      
                  }
                  else
                  {
                      SCLAlertView *alert = [[SCLAlertView alloc] init];
                      [alert showWarning:self title:@"Alert" subTitle: @"Currently no bid available." closeButtonTitle:@"OK" duration:0.0f];
                  }
                  NSLog(@"%@",responseObject);
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  [SVProgressHUD dismiss];
                  NSLog(@"%@",error);
              }];
        
        
        
    }
    
-(void)UpdateView
{
    self.lblBNickName.text = [self.UserProfile valueForKey:@"NickName"];
    self.lblSNickName.text = [sellerProfile valueForKey:@"NickName"];
    
    NSDictionary *BuyerCar = [self.UserProfile valueForKey:@"Car"];
    NSDictionary *sellerCar = [sellerProfile valueForKey:@"Car"];
    
    self.lbl_B_Detail.text = [NSString stringWithFormat:@"I Drive a %@ %@ %@ %@ Plate : %@",[BuyerCar valueForKey:@"Color"],[BuyerCar valueForKey:@"Brand"],[BuyerCar valueForKey:@"Model"],[BuyerCar valueForKey:@"Class"],[BuyerCar valueForKey:@"Plate"]];
    
    self.lbl_S_Detail.text = [NSString stringWithFormat:@"I Drive a %@ %@ %@ %@ Plate : %@",[sellerCar valueForKey:@"Color"],[sellerCar valueForKey:@"Brand"],[sellerCar valueForKey:@"Model"],[sellerCar valueForKey:@"Class"],[sellerCar valueForKey:@"Plate"]];
    
    self.lblPhone.text =[NSString stringWithFormat:@"My Phone number %@", [self.UserProfile valueForKey:@"PhoneNumber"]];
    self.lbl_S_Phone.text =[NSString stringWithFormat:@"My Phone number %@", [sellerProfile valueForKey:@"PhoneNumber"]];
    
    
        
}
    - (IBAction)backButton:(id)sender {
        [self.sideMenuViewController presentLeftMenuViewController];
    }

    
    - (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
    {
        switch (result)
        {
            case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            default:
            break;
        }
        
        // Close the Mail Interface
        [self dismissViewControllerAnimated:YES completion:NULL];
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnComplaint:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"issues with this transaction";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@rsvpny.co"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}
@end
