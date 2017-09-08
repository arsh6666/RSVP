//
//  EditViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 30/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()<RMPScrollingMenuBarControllerDelegate>{
    UINavigationController* naviController;
}
- (IBAction)btnBack:(id)sender;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // NSLog(@"%@",_myProfileDetail);
    
    RMPScrollingMenuBarController* menuController = [[RMPScrollingMenuBarController alloc] init];
    menuController.delegate = self;
    menuController.view.backgroundColor = [UIColor clearColor];
    menuController.menuBar.showsIndicator = YES;
    menuController.menuBar.backgroundColor = [UIColor whiteColor];
    menuController.menuBar.indicatorColor = [UIColor redColor];
    
    EditProfileVC *epv = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    epv.myProfileDetail = _myProfileDetail;

    VehicalDetail *vd = [self.storyboard instantiateViewControllerWithIdentifier:@"VehicalDetail"];
    vd.userDetailFromEdited = _myProfileDetail;
    vd.isEditProfile = YES;
    
    DriveWayInfoVC *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DriveWayInfoVC"];
    dvc.isDrivayEdit = YES;
    dvc.myProfileDetail = _myProfileDetail;
    
    
    PaymentVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVC"];
    vc.isEditProfile = YES;
    
    [menuController setViewControllers:@[epv,vd,dvc,vc]];
    menuController.containerView.backgroundColor = [UIColor clearColor];
    
    naviController = [[UINavigationController alloc] initWithRootViewController:menuController];
    [naviController setNavigationBarHidden:YES];
    naviController.view.frame = CGRectMake(0,70, self.view.frame.size.width, self.view.frame.size.height-70);
    [self.view addSubview:naviController.view];
    [self addChildViewController:naviController];
    [naviController didMoveToParentViewController:self];
    
    // Do any additional setup after loading the view.
}


#pragma mark - RMPScrollingMenuBarControllerDelegate methods

- (RMPScrollingMenuBarItem*)menuBarController:(RMPScrollingMenuBarController *)menuBarController
                           menuBarItemAtIndex:(NSInteger)index
{
    RMPScrollingMenuBarItem* item = [[RMPScrollingMenuBarItem alloc] init];
    item.width = 60;
    
    switch (index)
    {
        case 0:
            item.title = [NSString stringWithFormat:@"Profile"];
            break;
        case 1:
            item.title = [NSString stringWithFormat:@"Car"];
            break;
        case 2:
            item.title = [NSString stringWithFormat:@"Driveway"];
            break;
        case 3:
            item.title = [NSString stringWithFormat:@"Card"];
            break;
            
        default:
            break;
    }
    
    // Customize appearance of menu bar item.
    UIButton* button = item.button;
    [button setTitle:item.title forState:UIControlStateDisabled];
    [button setTitle:item.title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    return item;
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
 willSelectViewController:(UIViewController *)viewController
{
    //    NSLog(@"will select %@", viewController);
    //    viewController.view.backgroundColor = [UIColor clearColor];
    //    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
  didSelectViewController:(UIViewController *)viewController
{
    //   NSLog(@"did select %@", viewController);
}

- (void)menuBarController:(RMPScrollingMenuBarController *)menuBarController
  didCancelViewController:(UIViewController *)viewController
{
    // NSLog(@"did cancel %@", viewController);
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

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
