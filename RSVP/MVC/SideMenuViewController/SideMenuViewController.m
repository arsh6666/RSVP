//
//  SideMenuViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 29/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "SideMenuViewController.h"
#import "RESideMenu.h"

@interface SideMenuViewController (){
    
    NSMutableArray *array;
    
}
@property (strong, nonatomic) IBOutlet UITableView *lblTable;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (appDelegate().isLogin == YES) {
        array = [NSMutableArray arrayWithObjects:@"",@"My Profile",@"Looking for Parking",@"Park Driveway",@"Block Driveway",@"Parked On Street",@"Logout", nil];
    }
    else{
    array = [NSMutableArray arrayWithObjects:@"Login/Sign Up",@"Looking for Parking",@"Park Driveway",@"Block Driveway",@"Parked On Street", nil];
    }
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SideMenuTableViewCell *smtc = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    smtc.lblName.text = [array objectAtIndex:indexPath.row];
    return smtc;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HomeViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
        [self.sideMenuViewController setContentViewController:MainNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
