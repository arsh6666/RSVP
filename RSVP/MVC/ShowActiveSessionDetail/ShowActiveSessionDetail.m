//
//  ShowActiveSessionDetail.m
//  RSVP
//
//  Created by Arshdeep Singh on 05/09/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ShowActiveSessionDetail.h"

@interface ShowActiveSessionDetail (){
    
    NSDictionary *profile;
    NSDictionary *Userprofile;
     NSTimer *timer;
    int currMinute;
    int currSeconds;
    
    NSString *buyerID;
    NSString *sellerID;
    NSString *UserID;
    
}
@property (strong, nonatomic) IBOutlet UILabel *txtLBL;
    
@property (strong, nonatomic) IBOutlet UILabel *lbl_B_Name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_B_Details;
@property (strong, nonatomic) IBOutlet UILabel *lbl_B_PhoneNumber;
    
    @property (strong, nonatomic) IBOutlet UILabel *lbl_S_Name;
    @property (strong, nonatomic) IBOutlet UILabel *lbl_s_Details;
    @property (strong, nonatomic) IBOutlet UILabel *lbl_s_PhoneNumber;
    
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
    @property (strong, nonatomic) IBOutlet AsyncImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
    
- (IBAction)btnBack:(id)sender;
    

@end

@implementation ShowActiveSessionDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtLBL.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    NSLog(@"%@",self.dict);
    
    UserID = [NSUserDefaults.standardUserDefaults objectForKey:@"userId"];
    sellerID = [self.dict valueForKey:@"UserId"];
    buyerID = [self.dict valueForKey:@"ByerId"];
    
    currMinute=30;
    currSeconds=60;
    
    
    self.lblTime.hidden = YES;
    
    if ([[self.dict valueForKey:@"ParkingType"]isEqual: @"Driway"]||[[self.dict valueForKey:@"ParkingType"]isEqual: @"Block"])
    {
        self.lblTime.hidden = NO;
        self.lblAddress.text = [self.dict valueForKey:@"Address"];
        
    }
    else
    {
        self.lblAddress.text = [self.dict valueForKey:@"AproveAddress"];
    }
    
    [self GetSellerUserProfile];
    
    // Do any additional setup after loading the view.
}

    -(void)viewUpdate
    {
        
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        NSString *date = [self.dict valueForKey:@"TimeRem"];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"HH:mm:ss.SSS";
        NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:outputTimeZone];
        NSDate *datStartDate = [dateFormatter dateFromString:date];

        
        int minutes;
        int Second;

       NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:datStartDate];
        

        minutes = (int)[components minute];
        Second = (int)[components second];
        
        currMinute = minutes;
        currSeconds = Second;
        
        if (currMinute <= 0)
        {
            [timer invalidate];
            currMinute = 30;
            currSeconds = 00;
        }
        
        
        [_lblTime setText:[NSString stringWithFormat:@"Time : %02d: %02d",currMinute,currSeconds]];
        
        if (self.lblTime.hidden == NO)
        {
  
            if ([buyerID isEqualToString:UserID])
            {
                self.txtLBL.hidden = NO;
                self.lbl_S_Name.text = nil;
                self.lbl_s_Details.text = nil;
                self.lbl_s_PhoneNumber.text = nil;
                self.lbl_B_Name.text = nil;
                self.lbl_B_Details.text = nil;
                self.lbl_B_PhoneNumber.text = nil;
                
                
            }
            else if ([UserID isEqualToString:sellerID])
            {
                self.txtLBL.hidden = YES;
                self.lbl_S_Name.text = nil;
                self.lbl_s_Details.text = nil;
                self.lbl_s_PhoneNumber.text = nil;
                [self BuyerDetail];
            }
        }
        else{
            [self SellerDetail];
            [self BuyerDetail];
        }
    }

-(void)BuyerDetail{
    
    NSDictionary *sellerCar = [Userprofile valueForKey:@"Car"];
    
    self.lbl_B_Name.text = [Userprofile valueForKey:@"FirstName"];
    self.lbl_B_Details.text = [NSString stringWithFormat:@"I Drive a %@ %@ %@ Plate : %@",[sellerCar valueForKey:@"Color"],[sellerCar valueForKey:@"Brand"],[sellerCar valueForKey:@"Class"],[sellerCar valueForKey:@"Plate"]];
    
    self.lbl_B_PhoneNumber.text =[NSString stringWithFormat:@"My Phone number %@", [Userprofile valueForKey:@"PhoneNumber"]];
    
}
-(void)SellerDetail{
    
    NSDictionary *BuyerCar = [profile valueForKey:@"Car"];
    
    self.lbl_S_Name.text = [profile valueForKey:@"FirstName"];
    self.lbl_s_Details.text = [NSString stringWithFormat:@"I Drive a %@ %@ %@ Plate : %@",[BuyerCar valueForKey:@"Color"],[BuyerCar valueForKey:@"Brand"],[BuyerCar valueForKey:@"Class"],[BuyerCar valueForKey:@"Plate"]];
    self.lbl_s_PhoneNumber.text =[NSString stringWithFormat:@"My Phone number %@",  [profile valueForKey:@"PhoneNumber"]];
}

-(void)GetUserProfile
{
        
      //  [SVProgressHUD show];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetProfile?UserId=";
        
        
        NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[self.dict valueForKey:@"ByerId"]]];
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager1 GET: URLToHit parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             //NSDictionary *jsonDict = responseObject;
             [SVProgressHUD dismiss];
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             
//             if ([jsonDict[@"Success"] boolValue]){
//                 
                 Userprofile = responseObject;
                [self viewUpdate];
             
             if (_lblTime.hidden == NO)
             {
                 [self GetUserImages];
             }
 //            }
 //            else
 //            {
// //                SCLAlertView *alert = [[SCLAlertView alloc] init];
//                 [alert showWarning:self title:@"Alert" subTitle: @"Currently no bid available." closeButtonTitle:@"OK" duration:0.0f];
 //            }
             NSLog(@"%@",responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD dismiss];
             NSLog(@"%@",error);
         }];
        
        
        
    }
    
    -(void)GetSellerUserProfile{
        
        [SVProgressHUD show];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetProfile?UserId=";
        NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[self.dict valueForKey:@"UserId"]]];
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager1 GET: URLToHit parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSDictionary *jsonDict = responseObject;
            // [SVProgressHUD dismiss];
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             
             //             if ([jsonDict[@"Success"] boolValue]){
             //
             profile = responseObject;
             [self GetUserProfile];
             
             //            }
             //            else
             //            {
             // //                SCLAlertView *alert = [[SCLAlertView alloc] init];
             //                 [alert showWarning:self title:@"Alert" subTitle: @"Currently no bid available." closeButtonTitle:@"OK" duration:0.0f];
             //            }
             NSLog(@"%@",responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD dismiss];
             NSLog(@"%@",error);
         }];
        
        
        
    }

    -(void)GetUserImages{
        
       // [SVProgressHUD show];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetDriwayImageList?DriwayId=";
        NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[self.dict valueForKey:@"DriwayId"]]];
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager1 GET: URLToHit parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             NSDictionary *jsonDict = responseObject;
             [SVProgressHUD dismiss];
            if ([jsonDict[@"Success"] boolValue]){
                
           
             NSMutableArray *imageArray = [responseObject valueForKey:@"ImageList"];
             NSString *urlString = [NSString stringWithFormat:@"http://rsvp.rootflyinfo.com%@",[[imageArray valueForKey:@"Path"]objectAtIndex:0]];
            self.img.imageURL = [NSURL URLWithString:urlString];
            }
                         NSLog(@"%@",responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD dismiss];
             NSLog(@"%@",error);
         }];
        
        
        
    }
    

-(IBAction)timerFired:(id)sender
    {
        if(currMinute <= 30)
        {
        
            if(currSeconds==0)
            {
                currMinute-=1;
                currSeconds=59;
            }
            else if(currSeconds>0)
            {
                currSeconds-=1;
            }
            if(currMinute>-1)
            {
                [_lblTime setText:[NSString stringWithFormat:@"Time : %02d: %02d",currMinute,currSeconds]];
            }
        
        }
        else
        {
            [timer invalidate];
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

- (IBAction)btnBack:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
