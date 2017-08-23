//
//  EditProfileVC.m
//  RSVP
//
//  Created by Maninder Singh on 21/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *qucikPayMail;
@property (strong, nonatomic) IBOutlet UITextField *zellemail;
@property (strong, nonatomic) IBOutlet UITextField *address;

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMyDetail];
    // Do any additional setup after loading the view.
}

-(void)setUpMyDetail{
    _firstName.text = _myProfileDetail[@"FirstName"];
    _lastName.text = _myProfileDetail[@"LastName"];
    _nickName.text = _myProfileDetail[@"NickName"];
    _email.text = _myProfileDetail[@"Email"];
        _qucikPayMail.text = _myProfileDetail[@"ChaseQuickpayEmail"];
}
- (IBAction)backButtonACtion:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButtonAction:(id)sender {
}
- (IBAction)editCardDetailButton:(id)sender {
    VehicalDetail *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VehicalDetail"];
    vc.userDetailFromEdited = _myProfileDetail;
    vc.isEditProfile = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)editCardDetail:(id)sender {
    PaymentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVC"];
    vc.isEditProfile = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
