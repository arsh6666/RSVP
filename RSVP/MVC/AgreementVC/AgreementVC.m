//
//  AgreementVC.m
//  RSVP
//
//  Created by Maninder Singh on 25/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "AgreementVC.h"
#import <UserNotifications/UserNotifications.h>

@interface AgreementVC ()<MWPhotoBrowserDelegate,MFMailComposeViewControllerDelegate>
{
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    NSString *token;
    NSString *uniqueIdentifier;
    NSDictionary *sellerProfile;
    NSMutableArray *photos;
    NSDictionary *jsonDictImages;
}
@property (strong, nonatomic) IBOutlet UILabel *sellerLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UILabel *buyerLabel;
@property (strong, nonatomic) IBOutlet AsyncImageView *imgSpot;
- (IBAction)btnImageView:(id)sender;

@end

@implementation AgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    currMinute=30;
    currSeconds=00;
    
    [Utils okAlert:@"Message" message:@"Your 30 min start now, Please move your car to spot"];
    
    [self webServiceUserDetail];
    [self start];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
   
    [self setTime];
}
    
-(void)UpdateView
{
    NSLog(@"Seller Detail %@",self.markerData);
    NSLog(@"UserDetail %@",self.UserProfile);
    self.buyerLabel.text = [self.UserProfile valueForKey:@"NickName"];
    self.sellerLabel.text = [sellerProfile valueForKey:@"NickName"];
    _addressLabel.text = _markerData[@"Address"];
 
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSString *timeOnDisappear = [dateFormatter stringFromDate:[NSDate date]];
    [NSUserDefaults.standardUserDefaults setObject:timeOnDisappear forKey:@"getTime"];
}

- (IBAction)backButton:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)addMoreTime:(id)sender {

}
    
- (IBAction)complaintTransaction:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"issues with this transaction";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@rsvpny.co"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}


-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Alert";
    content.body = @"You have another 5 min to move your car, Please don't be late";
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1500 repeats:NO];
    
    NSString *identifier = @"UYLLocalNotification";
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];


}

-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
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
            [_timeLabel setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [timer invalidate];
    }
}

-(void)GetUserImages
{
    
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSString *URL = [NSString stringWithFormat:@"%@?DriwayId=%@",GetDriwayImageList,[self.markerData valueForKey:@"DriwayId"]];
  
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URL parameters:nil progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         jsonDictImages = responseObject;
         [SVProgressHUD dismiss];
         if ([jsonDictImages[@"Success"] boolValue])
         {
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             
             [self UpdateView];
             NSMutableArray *imageArray = [responseObject valueForKey:@"ImageList"];
             NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,[[imageArray valueForKey:@"Path"]objectAtIndex:0]];
             self.imgSpot.backgroundColor = [UIColor grayColor];
             self.imgSpot.imageURL = [NSURL URLWithString:urlString];
             self.imgSpot.showActivityIndicator = YES;
             self.imgSpot.activityIndicatorColor = [UIColor blackColor];
         }
        
         NSLog(@"%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD dismiss];
         NSLog(@"%@",error);
     }];
    
    
    
}

-(void)setTime
{
    NSString *getOldTime = [NSUserDefaults.standardUserDefaults objectForKey:@"getTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:getOldTime];
    NSDate *date2 = [NSDate date];
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];

}


-(void)webServiceUserDetail
{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSString *URL = [NSString stringWithFormat:@"%@?UserId=%@",GetProfile,[self.markerData valueForKey:@"UserId"]];
   
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URL parameters:nil progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *jsonDict = responseObject;
             // [SVProgressHUD dismiss];
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              
              if ([jsonDict[@"Success"] boolValue])
              {
                  sellerProfile = responseObject;
                  [self GetUserImages];
              }
              NSLog(@"%@",responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [SVProgressHUD dismiss];
              NSLog(@"%@",error);
          }];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
    {
        switch (result)
        {
            case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            default:
            break;
        }
        
        // Close the Mail Interface
        [self dismissViewControllerAnimated:YES completion:NULL];
    }

- (IBAction)btnImageView:(id)sender {
    
    photos = [NSMutableArray array];
    NSMutableArray *imageArray = [jsonDictImages valueForKey:@"ImageList"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,[[imageArray valueForKey:@"Path"]objectAtIndex:0]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:urlString]]];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:1];
    
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:10];

}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count) {
        return [photos objectAtIndex:index];
    }
    return nil;
}
@end
