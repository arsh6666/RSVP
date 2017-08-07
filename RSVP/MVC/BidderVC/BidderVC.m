//
//  BidderVC.m
//  RSVP
//
//  Created by Maninder Singh on 07/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "BidderVC.h"

@interface BidderVC ()

@end

@implementation BidderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BidderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.userImageView.image = [UIImage imageNamed:@"man"];
    cell.userNameLabel.text = @"Bunny";
    cell.userCostLabel.text = @"$100";
    return cell;
}
- (IBAction)menuButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
