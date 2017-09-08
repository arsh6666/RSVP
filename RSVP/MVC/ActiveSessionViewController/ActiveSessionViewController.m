//
//  ActiveSessionViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 02/09/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "ActiveSessionViewController.h"

@interface ActiveSessionViewController (){
    NSMutableArray *sessionArray;
    NSTimer *timer;
    NSInteger idID;
    NSInteger typeID;
   
}

    @property (strong, nonatomic) IBOutlet UITableView *tblSession;
@end

@implementation ActiveSessionViewController

- (void)viewDidLoad
    {
    [super viewDidLoad];
        
    timer=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    
    
    // Do any additional setup after loading the view.
}
    
    -(void)viewWillAppear:(BOOL)animated{
        self.navigationController.navigationBarHidden = YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ACTIVEBOOL"];
        [self webService];
    }
    
    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return sessionArray.count;
    }
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
    cell.btnCancel.tag = indexPath.row;
    
    if ([[[sessionArray valueForKey:@"ParkingType"]objectAtIndex:indexPath.row]isEqual: @"Driway"]||[[[sessionArray valueForKey:@"ParkingType"]objectAtIndex:indexPath.row]isEqual: @"Block"])
    {
        
        cell.lblName.text = [sessionArray valueForKey:@"Address"][indexPath.row];
        
        
        
    }
    else
    {
         cell.lblName.text = [sessionArray valueForKey:@"UserName"][indexPath.row];
    }

   
    [cell.btnCancel addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        ShowActiveSessionDetail *sasd = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowActiveSessionDetail"];
        sasd.dict =[sessionArray objectAtIndex:indexPath.row];
    [self presentViewController:sasd animated:YES completion:nil];
 
 
}
    
    -(IBAction)buttonCancel:(UIButton *)sender
{
    
    
    if ([[[sessionArray valueForKey:@"ParkingType"]objectAtIndex:sender.tag]isEqual: @"Driway"]||[[[sessionArray valueForKey:@"ParkingType"]objectAtIndex:sender.tag]isEqual: @"Block"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Sure you want Cancel your driveway before 30 min?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *Ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
            if ([[[sessionArray valueForKey:@"ParkingType"]objectAtIndex:sender.tag]isEqual: @"Driway"])
            {
                typeID = 1;
                
            }
            else if([[[sessionArray valueForKey:@"ParkingType"]objectAtIndex:sender.tag]isEqual: @"Block"]){
                
                typeID = 2;
                
            }
            
            idID = [[[sessionArray valueForKey:@"DriwayId"]objectAtIndex:sender.tag]integerValue ];
            [self CancelSessionMethod:idID parkingTypeID:typeID];
 
        }];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *alert){
            
        }];
        
        [alert addAction:Cancel];
        [alert addAction:Ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
            typeID = 3;
            idID = [[[sessionArray valueForKey:@"StreetId"]objectAtIndex:sender.tag]integerValue ];
            [self CancelSessionMethod:idID parkingTypeID:typeID];
    
    }

}

-(void)CancelSessionMethod :(NSInteger )parkingID  parkingTypeID:(NSInteger)parkingTypeID{
    
    [SVProgressHUD show];

    NSDictionary *dict = @{
                           @"ParkingId": [NSNumber numberWithInteger:parkingID],
                           @"ParkingType": [NSNumber numberWithInteger:parkingTypeID],
                           @"ActiveSession": [NSNumber numberWithBool:false]
                           };
    
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/ActiveDeactiveSession";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSDictionary *jsonDict = responseObject;
               [SVProgressHUD dismiss];
               
               if ([jsonDict[@"Success"] boolValue])
               {
                   
                   [self webService];
                   [Utils okAlert:@"Alert" message:@"Session Canceled successfully"];
                   
               }
               else
               {
                   [self.tblSession reloadData];
                   [Utils okAlert:@"Alert" message:@"No Active Session"];
                   
               }
               
               NSLog(@"%@",responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [SVProgressHUD dismiss];
               NSLog(@"%@",error);
               
               
           }];

    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ACTIVEBOOL"];
    
}
    - (IBAction)menuButtonAction:(id)sender {
        [self.sideMenuViewController presentLeftMenuViewController];
        
    }
-(void)timerFired
    {
        BOOL RecallBool = [[NSUserDefaults standardUserDefaults]boolForKey:@"ACTIVEBOOL"];
        if (RecallBool == NO)
        {
            [timer invalidate];
            timer = nil;
            return;
        }
    
        [self webService ];
    
    }
    -(void)webService
    {
        [SVProgressHUD show];
        NSString *url=[NSString stringWithFormat:@"http://rsvp.rootflyinfo.com/api/Values/GetActiveDriwayinfoList?UserId=%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]];
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager1 GET:url parameters:Nil progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
                   NSDictionary *jsonDict = responseObject;
                   [SVProgressHUD dismiss];
         
                   sessionArray = [NSMutableArray new];
                   if ([jsonDict[@"Success"] boolValue])
                   {
                    
                       [sessionArray addObjectsFromArray:[responseObject valueForKey:@"DriwayinfoList"]];
                       [sessionArray addObjectsFromArray:[responseObject valueForKey:@"StreetList"]];
                       
                   }
                   else
                   {
//                       [Utils okAlert:@"Alert" message:@"No Active Session"];
                   }
                  [self.tblSession reloadData];
                   NSLog(@"%@",responseObject);
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [SVProgressHUD dismiss];
                   NSLog(@"%@",error);
               }];
        
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
