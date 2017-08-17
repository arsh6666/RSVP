//
//  BlockVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "BlockVC.h"
#import "SideMenuViewController.h"

@interface BlockVC ()
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *sundayFrom;
@property (strong, nonatomic) IBOutlet UILabel *monFrom;
@property (strong, nonatomic) IBOutlet UILabel *tuesFrom;
@property (strong, nonatomic) IBOutlet UILabel *wedFrom;
@property (strong, nonatomic) IBOutlet UILabel *thrFrom;
@property (strong, nonatomic) IBOutlet UILabel *friFrom;
@property (strong, nonatomic) IBOutlet UILabel *SatFrom;
@property (strong, nonatomic) IBOutlet UILabel *sunTo;
@property (strong, nonatomic) IBOutlet UILabel *MonTo;
@property (strong, nonatomic) IBOutlet UILabel *tueTo;
@property (strong, nonatomic) IBOutlet UILabel *wedTo;
@property (strong, nonatomic) IBOutlet UILabel *thruTo;
@property (strong, nonatomic) IBOutlet UILabel *FriTo;
@property (strong, nonatomic) IBOutlet UILabel *satTo;
@property (strong, nonatomic) IBOutlet UIButton *sun;
@property (strong, nonatomic) IBOutlet UIButton *mon;
@property (strong, nonatomic) IBOutlet UIButton *tue;
@property (strong, nonatomic) IBOutlet UIButton *wed;
@property (strong, nonatomic) IBOutlet UIButton *thrus;
@property (strong, nonatomic) IBOutlet UIButton *fri;
@property (strong, nonatomic) IBOutlet UIButton *sat;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerFrom;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerTo;
@property NSString *buttonSelected;
@end

@implementation BlockVC

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
- (IBAction)doneButtonAction:(id)sender {
    [_pickerView setHidden:YES];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm a"]; //24hr time format
    NSString *from = [outputFormatter stringFromDate:_pickerFrom.date];
    NSString *To = [outputFormatter stringFromDate:_pickerTo.date];
    if ([_buttonSelected  isEqual: @"sunday"]){
        _sundayFrom.text = from;
        _sunTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"monday"]){
        _monFrom.text = from;
        _MonTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"tuesday"]){
        _tuesFrom.text = from;
        _tueTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"wednessday"]){
        _wedFrom.text = from;
        _wedTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"thrusday"]){
        _thrFrom.text = from;
        _thruTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"friday"]){
        _friFrom.text = from;
        _FriTo.text = To;
    }
    if ([_buttonSelected  isEqual: @"saturday"]){
        _SatFrom.text = from;
        _sunTo.text = To;
    }
    
}
- (IBAction)submitButtonAction:(id)sender {
    [self WebService];
}

-(void)WebService{

    NSArray *days = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    NSArray *startTime = [NSArray arrayWithObjects:_sundayFrom.text,_monFrom.text,_tuesFrom.text,_wedFrom.text,_thrFrom.text,_friFrom.text,_SatFrom.text, nil];
    NSArray *endTime = [NSArray arrayWithObjects:_sunTo.text,_MonTo.text,_tueTo.text,_wedTo.text,_thruTo.text,_FriTo.text,_satTo.text, nil];
    
    
    [SVProgressHUD show];
    NSDictionary *dict = @{@"DriwayId":_myblockData[@"DriwayId"],
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
                   [alert showWarning:self title:@"Alert" subTitle: @"Preference Saved successfully" closeButtonTitle:@"OK" duration:0.0f];
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
