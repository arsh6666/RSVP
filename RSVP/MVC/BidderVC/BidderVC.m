//
//  BidderVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "BidderVC.h"

@interface BidderVC (){
    NSArray *bidder;
}
@property (strong, nonatomic) IBOutlet UIButton *rewardedButton;
@property (strong, nonatomic) IBOutlet UILabel *topLabelInfo;
@property (strong, nonatomic) IBOutlet UITableView *bidderTable;
@property (strong, nonatomic) IBOutlet UIButton *bidButton;

@end

@implementation BidderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self webService];
    if (_isMyDriveway){
        [_rewardedButton setHidden:NO];
        [_bidButton setHidden:YES];
    }else{
        [_rewardedButton setHidden:YES];
        [_bidButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bidButtonAction:(id)sender {
    BidVC *bidVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidVC"];
    bidVC.drivewayID = _drivewayID;
    [self.navigationController pushViewController:bidVC animated:YES];
}
- (IBAction)rewardedButtonAction:(id)sender {
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bidder.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BidderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.userImageView.image = [UIImage imageNamed:@"man"];
    NSDictionary *biderName = bidder[indexPath.row];
    cell.userNameLabel.text = biderName[@"FirstName"];
    cell.userCostLabel.text = [NSString stringWithFormat:@"%@",biderName[@"Amount"]];
    return cell;
}


- (IBAction)menuButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webService{
    [SVProgressHUD show];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetDriwayBidList?DriwayId=";
    NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",_drivewayID]];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URLToHit parameters:nil progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSDictionary *jsonDict = responseObject;
               [SVProgressHUD dismiss];
               if ([jsonDict[@"Success"] boolValue]){
                   bidder = jsonDict[@"DriwayBidList"];
                   [_bidderTable reloadData];
               }else{
                   SCLAlertView *alert = [[SCLAlertView alloc] init];
                   [alert showWarning:self title:@"Alert" subTitle: @"Currently no bid available." closeButtonTitle:@"OK" duration:0.0f];
               }
               NSLog(@"%@",responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [SVProgressHUD dismiss];
               NSLog(@"%@",error);
           }];
    
}


@end
