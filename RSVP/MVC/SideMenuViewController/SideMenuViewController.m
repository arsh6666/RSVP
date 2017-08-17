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
    
//    if (appDelegate().isLogin == YES) {
//        array = [NSMutableArray arrayWithObjects:@"",@"My Profile",@"Looking for Parking",@"Park in my Driveway",@"Block my Driveway",@"I'm parked on the street",@"Logout", nil];
//    }
//    else{
    array = [NSMutableArray arrayWithObjects:@"My Profile",@"Looking for Parking",@"Park in my Driveway",@"Block my Driveway",@"I'm parked on the street",@"Logout", nil];
   // }
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
        
        MyProfileVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileVC"];
        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
        [self.sideMenuViewController setContentViewController:MainNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    
    if (indexPath.row == 1) {
        
        MapViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
        [self.sideMenuViewController setContentViewController:MainNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    
    if (indexPath.row == 2) {
        
        MyDrivewayList *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyDrivewayList"];
        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:vc];
        [self.sideMenuViewController setContentViewController:MainNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    
    if (indexPath.row == 3) {
        
        MyBlockList *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyBlockList"];
        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
        [self.sideMenuViewController setContentViewController:MainNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    if (indexPath.row == 4) {
        
        StreetParkingVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StreetParkingVC"];
        UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
        [self.sideMenuViewController setContentViewController:MainNav animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        
    }
    if (indexPath.row == 5) {
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"isLogin"];
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
