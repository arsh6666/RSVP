//
//  MyProfileVC.m
//  RSVP
//
//  Created by Maninder Singh on 15/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "MyProfileVC.h"

@interface MyProfileVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSDictionary *myDetail;
}
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@end

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self webService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editProfileButton:(id)sender {
    EditProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    vc.myProfileDetail = myDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setUpMyProfile{
    _nameLabel.text = myDetail[@"FirstName"];
    _emailLabel.text = myDetail[@"Email"];
}
- (IBAction)menuButtonAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)segmentAction:(id)sender {
    [_historyTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyProfileCell"];
    if (_segment.selectedSegmentIndex == 0){
        cell.leftLabel.text = @"New York City";
        cell.rightLabel.text = @"$14";
    }else{
        cell.leftLabel.text = @"Micky";
        cell.rightLabel.text = @"$24";
    }
    return cell;

}
-(void)webService{
    [SVProgressHUD show];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetProfile?UserId=";
    NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]]];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URLToHit parameters:nil progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *jsonDict = responseObject;
              [SVProgressHUD dismiss];
              if ([jsonDict[@"Success"] boolValue]){
                  myDetail = jsonDict;
                  [self setUpMyProfile];
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
