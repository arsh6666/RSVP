//
//  MyDrivewayList.m
//  RSVP
//
//  Created by Maninder Singh on 16/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "MyDrivewayList.h"

@interface MyDrivewayList()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *WeekDays;
}
@property (strong, nonatomic) IBOutlet UITableView *drivewayListTableView;
@property (strong, nonatomic) IBOutlet UILabel *setTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchED;
- (IBAction)switchED:(id)sender;

@end

@implementation MyDrivewayList

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL status = [[NSUserDefaults standardUserDefaults]boolForKey:@"DriveyStatus"];
    
    [_switchED setOn: YES];
    
    if ( status == NO) {
        [_switchED setOn: NO];
        
    }
   
    if([_typeOfParking isEqualToString: @"Driveway"]){
        _setTitleLabel.text = @"Park in my Driveway";
    }
    else{
        _setTitleLabel.text = @"Block my Driveway";
    }
   
    WeekDays = [NSMutableArray arrayWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuButtonAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return WeekDays.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDrivewayListcell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.Address.text = WeekDays[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleVC"];
    vc.day = WeekDays[indexPath.row];
    vc.typeOfParking = _typeOfParking;
    [self.navigationController pushViewController:vc animated:YES];
}




- (IBAction)switchED:(UISwitch *)sender
{
    
    NSInteger IntParkingType = 0;
    
    if([_typeOfParking isEqualToString:@"Driveway"])
    {
        IntParkingType = 1;
    }
    if([_typeOfParking isEqualToString:@"Block"]){
        IntParkingType = 2;
    }
    if([_typeOfParking isEqualToString:@"Street"]){
        IntParkingType = 3;
    }
    
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           @"Enable": [NSNumber numberWithBool:sender.isOn],
                           @"ParkingType": [NSNumber numberWithInteger:IntParkingType],
                           @"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]
                           };
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:EnableDisableDriway parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
               NSDictionary *jsonDict = responseObject;
               [SVProgressHUD dismiss];
         
                SCLAlertView *alert = [[SCLAlertView alloc] init];
               if ([jsonDict[@"Success"] boolValue]){
                   NSString *str;
                   if (sender.isOn == YES) {
                       
                       str = [NSString stringWithFormat:@"%@ Enabled successfully",_typeOfParking];
                   }else{
                        str = [NSString stringWithFormat:@"%@ Disabled successfully",_typeOfParking];
                   }
                   [[NSUserDefaults standardUserDefaults]setBool:sender.isOn forKey:@"DriveyStatus"];
                  [alert showWarning:self title:@"Alert" subTitle:str closeButtonTitle:@"OK" duration:0.0f];
                   
               }else{
                   
                   [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@", jsonDict[@"Message"]] closeButtonTitle:@"OK" duration:0.0f];
               }
               NSLog(@"%@",responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [SVProgressHUD dismiss];
               NSLog(@"%@",error);
           }];
    
}
@end
