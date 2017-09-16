//
//  ParkInVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ParkInVC.h"

@interface ParkInVC (){
    NSDateFormatter *outputFormatter;
}
@property (strong, nonatomic) IBOutlet UISwitch *enableDisableSwitch;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *sunFrom;
@property (strong, nonatomic) IBOutlet UILabel *sunto;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerFrom;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerTo;
@property NSString *buttonSelected;
@end

@implementation ParkInVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"hh:mm a"];
    
    if (self.EditBool == YES)
    {

        NSLog(@"%@",self.scheduleDict);
        
        [self.enableDisableSwitch setOn:[[NSNumber numberWithInteger:[[self.scheduleDict valueForKey:@"Enable"]integerValue]]boolValue]];
        NSString *toString = [self.scheduleDict valueForKey:@"EndTime"];
        NSString *fromStr = [self.scheduleDict valueForKey:@"StartTime"];
        self.sunto.text = toString;
        self.sunFrom.text = fromStr;
        
        NSDate *fromDate = [outputFormatter dateFromString:fromStr];
        outputFormatter.timeZone = [NSTimeZone systemTimeZone];
        NSDate *ToDate = [outputFormatter dateFromString:toString];
        
        self.pickerTo.date = ToDate;
        self.pickerFrom.date = fromDate;
    
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_pickerFrom addTarget:self  action:@selector(DateChange:)
         forControlEvents:UIControlEventValueChanged];
    [_pickerTo addTarget:self  action:@selector(DateChange:)
          forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)DateChange:(id)sender {
  
    
    NSString *from = [outputFormatter stringFromDate:_pickerFrom.date];
    NSString *To = [outputFormatter stringFromDate:_pickerTo.date];
    
    NSDate *s = [outputFormatter dateFromString:from];
    NSDate *e = [outputFormatter dateFromString:To];

    NSComparisonResult result = [s compare:e];
//    if(result == NSOrderedDescending)
//    {
//        SCLAlertView *alert = [[SCLAlertView alloc] init];
//        [alert showWarning:self title:@"Alert" subTitle: @"Start time cannot be greater then end time." closeButtonTitle:@"OK" duration:0.0f];
//    }
    _sunFrom.text = from;
    _sunto.text = To;
    
}

- (IBAction)submitButtonAction:(id)sender
{
    if (_EditBool == YES) {
        
        [self EditSchedule];
    }
    else
    {
        [self WebService];
    }
}
    
-(void)WebService{
    NSString *IntDay = [[NSString alloc]init];
    
    if ([_day isEqualToString:@"Monday"]){
        IntDay = @"1";
    }
    else if ([_day isEqualToString:@"Tuesday"]){
        IntDay = @"2";
    }
    else if ([_day isEqualToString:@"Wednesday"]){
        IntDay = @"3";
    }
    else if ([_day isEqualToString:@"Thursday"]){
        IntDay = @"4";
    }
    else if ([_day isEqualToString:@"Friday"]){
        IntDay = @"5";
    }
    else if ([_day isEqualToString:@"Saturday"]){
        IntDay = @"6";
    }
    else if ([_day isEqualToString:@"Sunday"])
    {
        IntDay = @"7";
    }
    
    NSArray *days = [NSArray arrayWithObjects:IntDay, nil];
    NSArray *startTime = [NSArray arrayWithObjects:_sunFrom.text, nil];
    NSArray *endTime = [NSArray arrayWithObjects:_sunto.text, nil];
    
    [SVProgressHUD show];
    
    //driveway = 1
    //block = 2
    //steet = 3
    
    NSString *IntParkingType;
    if([_typeOfParking isEqualToString:@"Driveway"]){
        IntParkingType = @"1";
    }
    if([_typeOfParking isEqualToString:@"Block"]){
        IntParkingType = @"2";
    }
    if([_typeOfParking isEqualToString:@"Street"]){
        IntParkingType = @"3";
    }
    
    
    NSString *isEnable;
    if (_enableDisableSwitch.isOn){
        isEnable = @"true";
    }else{
        isEnable = @"false";
    }
    
    
    
    NSDictionary *dict = @{
                           @"Enable":isEnable,
                           @"UserId": [NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"Day":days,
                           @"StartTime": startTime,
                           @"EndTime": endTime,
                           @"Type":IntParkingType
                           };
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:SaveSchedule parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [SVProgressHUD dismiss];
               NSDictionary *jsonDict = responseObject;
               if ([jsonDict[@"Success"] boolValue]){
                   [self.navigationController popViewControllerAnimated:YES];
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
    
-(void)EditSchedule
{
        
        
        NSString *IntDay = [[NSString alloc]init];
        if ([_day isEqualToString:@"Monday"]){
            IntDay = @"1";
        }
        if ([_day isEqualToString:@"Tuesday"]){
            IntDay = @"2";
        }
        if ([_day isEqualToString:@"Wednesday"]){
            IntDay = @"3";
        }
        if ([_day isEqualToString:@"Thursday"]){
            IntDay = @"4";
        }
        if ([_day isEqualToString:@"Friday"]){
            IntDay = @"5";
        }
        if ([_day isEqualToString:@"Saturday"]){
            IntDay = @"6";
        }
        if ([_day isEqualToString:@"Sunday"]){
            IntDay = @"7";
        }
        NSArray *days = [NSArray arrayWithObjects:IntDay, nil];
        NSArray *startTime = [NSArray arrayWithObjects:_sunFrom.text, nil];
        NSArray *endTime = [NSArray arrayWithObjects:_sunto.text, nil];
        
        [SVProgressHUD show];
        
        //driveway = 1
        //block = 2
        //steet = 3
        
        NSString *IntParkingType;
        if([_typeOfParking isEqualToString:@"Driveway"]){
            IntParkingType = @"1";
        }
        if([_typeOfParking isEqualToString:@"Block"]){
            IntParkingType = @"2";
        }
        if([_typeOfParking isEqualToString:@"Street"]){
            IntParkingType = @"3";
        }
        
        
        NSString *isEnable;
        if (_enableDisableSwitch.isOn){
            isEnable = @"true";
        }else{
            isEnable = @"false";
        }
        
        
        
        NSDictionary *dict = @{
                               @"Enable":isEnable,
                               @"ScheduleId": [self.scheduleDict valueForKey:@"ScheduleId"],
                               @"Day":days,
                               @"StartTime": startTime,
                               @"EndTime": endTime,
                               @"Type":IntParkingType
                               };
        
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager1 POST:UpdateSchedule parameters:dict progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [SVProgressHUD dismiss];
                   NSDictionary *jsonDict = responseObject;
                   if ([jsonDict[@"Success"] boolValue]){
                       [self.navigationController popViewControllerAnimated:YES];
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
