//
//  ParkInVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ParkInVC.h"

@interface ParkInVC ()
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *sunFrom;
@property (strong, nonatomic) IBOutlet UILabel *monFropm;
@property (strong, nonatomic) IBOutlet UILabel *tueFrom;

@property (strong, nonatomic) IBOutlet UILabel *wedFrom;
@property (strong, nonatomic) IBOutlet UILabel *thruFrom;
@property (strong, nonatomic) IBOutlet UILabel *friFrom;
@property (strong, nonatomic) IBOutlet UILabel *satFrom;
@property (strong, nonatomic) IBOutlet UILabel *sunto;
@property (strong, nonatomic) IBOutlet UILabel *monTo;
@property (strong, nonatomic) IBOutlet UILabel *tueTo;
@property (strong, nonatomic) IBOutlet UILabel *wedTo;
@property (strong, nonatomic) IBOutlet UILabel *ThrTo;
@property (strong, nonatomic) IBOutlet UILabel *FriTo;
@property (strong, nonatomic) IBOutlet UILabel *SatTo;
@property (strong, nonatomic) IBOutlet UIButton *sun;
@property (strong, nonatomic) IBOutlet UIButton *mon;
@property (strong, nonatomic) IBOutlet UIButton *tue;
@property (strong, nonatomic) IBOutlet UIButton *wed;
@property (strong, nonatomic) IBOutlet UIButton *thrus;
@property (strong, nonatomic) IBOutlet UIButton *fri;
@property (strong, nonatomic) IBOutlet UIButton *Sat;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerFrom;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerTo;
@property NSString *buttonSelected;
@end

@implementation ParkInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [_pickerView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneButtonAction:(id)sender {
    [_pickerView setHidden:YES];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm a"]; //24hr time format
    NSString *from = [outputFormatter stringFromDate:_pickerFrom.date];
    NSString *To = [outputFormatter stringFromDate:_pickerTo.date];
    if ([_buttonSelected  isEqual: @"sunday"]){
        _sunFrom.text = from;
        _sunto.text = To;
    }
    if ([_buttonSelected  isEqual: @"monday"]){
        _monFropm.text = from;
        _monTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"tuesday"]){
        _tueFrom.text = from;
        _tueTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"wednessday"]){
        _wedFrom.text = from;
        _wedTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"thrusday"]){
        _thruFrom.text = from;
        _ThrTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"friday"]){
        _friFrom.text = from;
        _FriTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"saturday"]){
        _satFrom.text = from;
        _SatTo.text = To;
    }
    
}
- (IBAction)editButtonAction:(id)sender {
    [_pickerView setHidden:NO];
    if ([sender tag] == 1){
        _buttonSelected = @"sunday";
    }
    if ([sender tag] == 2){
        _buttonSelected = @"monday";
    }
    if ([sender tag] == 3){
        _buttonSelected = @"tuesday";
    }
    if ([sender tag] == 4){
        _buttonSelected = @"wednessday";
    }
    if ([sender tag] == 5){
        _buttonSelected = @"thrusday";
    }
    if ([sender tag] == 6){
        _buttonSelected = @"friday";
    }
    if ([sender tag] == 7){
        _buttonSelected = @"saturday";
    }
    

}
- (IBAction)submitButtonAction:(id)sender {
    [self WebService];
}
-(void)WebService{
    
    NSArray *days = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    NSArray *startTime = [NSArray arrayWithObjects:_sunFrom.text,_monFropm.text,_tueFrom.text,_wedFrom.text,_thruFrom.text,_friFrom.text,_satFrom.text, nil];
    NSArray *endTime = [NSArray arrayWithObjects:_sunto.text,_monTo.text,_tueTo.text,_wedTo.text,_ThrTo.text,_FriTo.text,_SatTo.text, nil];
    
    
    [SVProgressHUD show];
    NSDictionary *dict = @{@"DriwayId":_drivewarData[@"DriwayId"],
                           @"UserId": [NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"Day":days,
                           @"StartTime": startTime,
                           @"EndTime": endTime};
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SaveParking";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [SVProgressHUD dismiss];
               NSDictionary *jsonDict = responseObject;
               if ([jsonDict[@"Success"] boolValue]){
                  
                   SCLAlertView *alert = [[SCLAlertView alloc] init];
                   [alert showWarning:self title:@"Alert" subTitle: @"Preferences Saved successfully" closeButtonTitle:@"OK" duration:0.0f];
                   
               }else{
                   SCLAlertView *alert = [[SCLAlertView alloc] init];
                   [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@", jsonDict[@"Message"]] closeButtonTitle:@"OK" duration:0.0f];
               }
               NSLog(@"%@",responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [SVProgressHUD dismiss];
               NSLog(@"%@",error);
           }];
    
}

@end
