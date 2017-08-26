//
//  RatingVC.m
//  RSVP
//
//  Created by Maninder Singh on 26/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "RatingVC.h"

@interface RatingVC (){
}
@property (strong, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@end

@implementation RatingVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitButton:(id)sender {
    [self webService];
}
- (IBAction)backButton:(id)sender {
    
    MapViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
    [self.sideMenuViewController setContentViewController:MainNav animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

-(void)webService{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    NSDictionary *dict = @{@"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"ToUserId": _toUserId,
                           @"Review": [NSString stringWithFormat:@"%f",_ratingView.value]};
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/SaveReview";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [SVProgressHUD dismiss];
               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
               NSDictionary *jsonDict = responseObject;
               if ([jsonDict[@"Success"] boolValue]){
                   
                   MapViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
                   [self.navigationController pushViewController:hvc animated:YES];
                   
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
