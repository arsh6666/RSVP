//
//  ScheduleVC.m
//  RSVP
//
//  Created by Maninder Singh on 18/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ScheduleVC.h"

@interface ScheduleVC (){
    NSArray *scheduleArray;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabelForVC;
@property (strong, nonatomic) IBOutlet UITableView *scheduleTable;

@end

@implementation ScheduleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *newString = [NSString stringWithFormat:@"Schedule for %@",_day];
    _titleLabelForVC.text = newString;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self WebService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addButtonAction:(id)sender {
    ParkInVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ParkInVC"];
    vc.day = _day;
    vc.typeOfParking = _typeOfParking;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return scheduleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *ScheduleData = scheduleArray[indexPath.row];
    cell.fromLabel.text = [NSString stringWithFormat:@"%@",ScheduleData[@"StartTime"]];
    cell.toLabel.text = [NSString stringWithFormat:@"%@",ScheduleData[@"EndTime"]];
    if ([ScheduleData[@"Enable"] boolValue]){
        cell.yesNoLabel.text = @"Yes";
    }else{
        cell.yesNoLabel.text = @"No";    
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkInVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ParkInVC"];
    vc.scheduleDict = scheduleArray[indexPath.row];
    vc.EditBool = YES;
    vc.day = _day;
    vc.typeOfParking = _typeOfParking;
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)WebService{
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
    NSString *url=[NSString stringWithFormat:@"http://rsvp.rootflyinfo.com/api/Values/GetScheduleList?UserId=%@&Day=%@&Type=%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],IntDay,IntParkingType];
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        NSDictionary *jsonDict = responseObject;
        if ([jsonDict[@"Success"] boolValue]){
            scheduleArray = [[NSArray alloc]init];
            scheduleArray = jsonDict[@"ScheduleList"];
            [_scheduleTable reloadData];
        }else{
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle: @"No Schedules available." closeButtonTitle:@"OK" duration:0.0f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
     
}
     
     @end
