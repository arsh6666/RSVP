//
//  MyBlockList.m
//  RSVP
//
//  Created by Maninder Singh on 17/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "MyBlockList.h"

@interface MyBlockList (){
    NSMutableArray *myblocks;

}

@property (strong, nonatomic) IBOutlet UITableView *myblockTbale;
@end

@implementation MyBlockList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self getMyDrivayList];

    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)manuButtonAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];

}
- (IBAction)addBlocksAction:(id)sender {
    DriveWayInfoVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DriveWayInfoVC"];
    [self.navigationController pushViewController:hvc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myblocks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyDrivewayListcell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *biderName = myblocks[indexPath.row];
    cell.Address.text = biderName[@"Address"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BlockVC *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BlockVC"];
    hvc.myblockData = myblocks[indexPath.row];
    [self.navigationController pushViewController:hvc animated:YES];
}

-(void)getMyDrivayList{
    [SVProgressHUD show];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetDriwayinfoList?UserId=";
    NSString *UrlToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]]];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET:UrlToHit parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = responseObject;
        [SVProgressHUD dismiss];
        if ([jsonDict[@"Success"] boolValue])
        {
            myblocks = [[NSMutableArray alloc]init];
            
            NSMutableArray *mydrivewaylist = jsonDict[@"DriwayinfoList"];
            
            for (NSInteger i = 0; i < mydrivewaylist.count; i++) {
                
                NSDictionary *mydict = mydrivewaylist[i];
                BOOL isBlockavailable = mydict[@"AvailableBlock"];
                
                if (isBlockavailable){
                    [myblocks addObject:mydrivewaylist[i]];
                }
            }
   
            
        }
        [_myblockTbale reloadData];

        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}

@end
