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

@end

@implementation MyDrivewayList

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *frontLabel = @"Park in my ";
    NSString *newString = [frontLabel stringByAppendingString:[NSString stringWithFormat:@"%@",_typeOfParking]];
    _setTitleLabel.text = newString;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScheduleVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleVC"];
    vc.day = WeekDays[indexPath.row];
    vc.typeOfParking = _typeOfParking;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
