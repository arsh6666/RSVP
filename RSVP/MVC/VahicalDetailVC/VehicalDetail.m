//
//  VehicalDetail.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "VehicalDetail.h"

@interface VehicalDetail (){
    NSDictionary *dataDict;
}
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UITextField *carMakeTextField;
@property (strong, nonatomic) IBOutlet UITextField *modelTextfield;
@property (strong, nonatomic) IBOutlet UITextField *coloTextField;
@property (strong, nonatomic) IBOutlet UITextField *classTextField;
@property (strong, nonatomic) IBOutlet UITextField *plateTextField;
@property (strong, nonatomic) IBOutlet UIButton *carMakeButton;
@property (strong, nonatomic) IBOutlet UITextField *StateTextField;
@end

@implementation VehicalDetail


- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    if(_isEditProfile){
        [self userDataFromEdited];
        
    }

}

-(void)userDataFromEdited{
    NSDictionary *carData = _userDetailFromEdited[@"Car"];
    _carMakeTextField.text = carData[@"Brand"];
    _modelTextfield.text = carData[@"Model"];
    _coloTextField.text = carData[@"Color"];
    _classTextField.text = carData[@"Class"];
    _plateTextField.text = carData[@"Plate"];
    _StateTextField.text = carData[@"State"];
    [_nextButton setTitle:@"Save" forState: normal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    if (_carMakeTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter car make." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_modelTextfield.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter car model." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_coloTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter color of the car." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_classTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter class of the car." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_plateTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter car plate number." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_StateTextField.text.length == 0){
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter state." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }else{
        [self webService];
    }
    
}


-(void)sendDataToVehicleVC:(NSDictionary *)Dict{
    [_carMakeButton setTitle:Dict[@"BrandName"] forState:normal];
    dataDict = Dict;
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webService{
    NSDictionary *dict = @{
                           @"Brand":_carMakeTextField.text,
                           @"Model": _modelTextfield.text,
                           @"Color":_coloTextField.text,
                           @"Class":_classTextField.text,
                           @"Plate":_plateTextField.text,
                           @"State":_StateTextField.text
                           };
    PaymentVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVC"];
    hvc.userDetail = _userDetail;
    hvc.userCarDetail = dict;
    [self.navigationController pushViewController:hvc animated:YES];
    //    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SaveCar";
    //    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    //    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    [manager1 POST:url parameters:dict progress:nil
    //           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //               NSDictionary *jsonDict = responseObject;
    //               [SVProgressHUD dismiss];
    //               if ([jsonDict[@"Success"] boolValue]){
    //                   PaymentVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVC"];
    //                   [self.navigationController pushViewController:hvc animated:YES];
    //               }else{
    //                   SCLAlertView *alert = [[SCLAlertView alloc] init];
    //                   [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@", jsonDict[@"Message"]] closeButtonTitle:@"OK" duration:0.0f];
    //               }
    //               NSLog(@"%@",responseObject);
    //           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //               [SVProgressHUD dismiss];
    //               NSLog(@"%@",error);
    //           }];
    
}



@end
