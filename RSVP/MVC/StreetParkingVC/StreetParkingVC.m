//
//  StreetParkingVC.m
//  RSVP
//
//  Created by Maninder Singh on 15/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "StreetParkingVC.h"
#import "MVPlaceSearchTextField.h"

@interface StreetParkingVC ()<PlaceSearchTextFieldDelegate>{
    CLLocationCoordinate2D location;

}
@property (strong, nonatomic) IBOutlet MVPlaceSearchTextField *aproxAddress;

@property (strong, nonatomic) IBOutlet UITextField *stateTextField;
@property (strong, nonatomic) IBOutlet MVPlaceSearchTextField *pprovedAddress;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollVew;

@end

@implementation StreetParkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.aproxAddress.placeSearchDelegate = self;
    self.aproxAddress.strApiKey= GooglePlaceAPI;
    self.aproxAddress.superViewOfList= self.scrollVew;  // View, on which Autocompletion list should be appeared.
    self.aproxAddress.autoCompleteShouldHideOnSelection= YES;
    self.aproxAddress.maximumNumberOfAutoCompleteRows= 5;

    

    self.pprovedAddress.placeSearchDelegate = self;
    self.pprovedAddress.strApiKey= GooglePlaceAPI;
    self.pprovedAddress.superViewOfList= self.scrollVew;  // View, on which Autocompletion list should be appeared.
    self.pprovedAddress.autoCompleteShouldHideOnSelection= YES;
    self.pprovedAddress.maximumNumberOfAutoCompleteRows= 5;
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.aproxAddress.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    self.aproxAddress.autoCompleteBoldFontName = @"HelveticaNeue";
    self.aproxAddress.autoCompleteTableCornerRadius=0.0;
    self.aproxAddress.autoCompleteRowHeight=35;
    self.aproxAddress.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    self.aproxAddress.autoCompleteFontSize=14;
    self.aproxAddress.autoCompleteTableBorderWidth=1.0;
    self.aproxAddress.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    self.aproxAddress.autoCompleteShouldHideOnSelection=YES;
    self.aproxAddress.autoCompleteShouldHideClosingKeyboard=YES;
    self.aproxAddress.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    self.aproxAddress.autoCompleteTableFrame = CGRectMake(20,self.aproxAddress.frame.origin.y+self.aproxAddress.frame.size.height+20, self.aproxAddress.frame.size.width, 300.0);
    
    
    self.pprovedAddress.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    self.pprovedAddress.autoCompleteBoldFontName = @"HelveticaNeue";
    self.pprovedAddress.autoCompleteTableCornerRadius=0.0;
    self.pprovedAddress.autoCompleteRowHeight=35;
    self.pprovedAddress.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    self.pprovedAddress.autoCompleteFontSize=14;
    self.pprovedAddress.autoCompleteTableBorderWidth=1.0;
    self.pprovedAddress.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    self.pprovedAddress.autoCompleteShouldHideOnSelection=YES;
    self.pprovedAddress.autoCompleteShouldHideClosingKeyboard=YES;
    self.pprovedAddress.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    self.pprovedAddress.autoCompleteTableFrame = CGRectMake(20,self.pprovedAddress.frame.origin.y+self.pprovedAddress.frame.size.height+20, self.pprovedAddress.frame.size.width, 300.0);;
    

}


#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField *)textField ResponseForSelectedPlace:(GMSPlace *)responseDict
{
    if (textField == self.aproxAddress)
    {
        location = responseDict.coordinate;
    }
    
    [self.view endEditing:YES];
    
    NSLog(@"SELECTED ADDRESS :%@",responseDict);
}

-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField{
    
}

-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField{
    
}

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index{
    if(index%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sideMenuButtonAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)submitButtonAction:(id)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];

    if (_aproxAddress.text.length == 0)
    {
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Approximate address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    if (_pprovedAddress.text.length == 0)
    {
        [alert showWarning:self title:@"Alert" subTitle:@"Please enter Aprroved Address." closeButtonTitle:@"OK" duration:0.0f];
        return;
    }
    else{
        [self getUserProfile];
    }

}

-(void)addStreet{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           @"Name":[NSUserDefaults.standardUserDefaults objectForKey:@"myName"],
                           @"Latitude":[NSString stringWithFormat:@"%f",location.latitude],
                           @"Longitude":[NSString stringWithFormat:@"%f",location.longitude],
                           @"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"Address":_aproxAddress.text,
                           @"City":@"",
                           @"ApproveAddress":_pprovedAddress.text,
                           };
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:SaveStreet parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = responseObject;
        [SVProgressHUD dismiss];
        if ([jsonDict[@"Success"] boolValue])
        {
            [NSUserDefaults.standardUserDefaults setObject:jsonDict[@"StreetId"] forKey:@"myStreetId"];
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"Alert" subTitle: @"your spot has successfully posted please watch active sessions to see when someone grabbed your spot" closeButtonTitle:@"OK" duration:0.0f];
            MapViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            UINavigationController *MainNav= [[UINavigationController alloc]initWithRootViewController:hvc];
            [self.sideMenuViewController setContentViewController:MainNav animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
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

-(void)getUserProfile
{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSString *URLToHit = [NSString stringWithFormat:@"%@?UserId=%@",GetProfile,[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]];
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URLToHit parameters:nil progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *jsonDict = responseObject;
              [SVProgressHUD dismiss];
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              
              if ([jsonDict[@"Success"] boolValue]){
                  [NSUserDefaults.standardUserDefaults setObject:jsonDict[@"FirstName"] forKey:@"myName"];
                  [self addStreet];
              }else{
                  
              }
              NSLog(@"%@",responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [SVProgressHUD dismiss];
              NSLog(@"%@",error);
          }];
    
}




@end
