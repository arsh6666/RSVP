//
//  CarMakeVC.m
//  RSVP
//
//  Created by Maninder Singh on 13/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "CarMakeVC.h"


@interface CarMakeVC (){
    NSArray *carModelDictArray;
}
@property (strong, nonatomic) IBOutlet UITableView *carModelTableView;


@end

@implementation CarMakeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self webService];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return carModelDictArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarMakeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *carDict = carModelDictArray[indexPath.row];
    cell.carMakeLabel.text = carDict[@"BrandName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *carDict = carModelDictArray[indexPath.row];
    [_delegate sendDataToVehicleVC:carDict];
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)webService{
    [SVProgressHUD show];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetBrandList";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = responseObject;
        [SVProgressHUD dismiss];
        if ([jsonDict[@"Success"] boolValue]){
           carModelDictArray = jsonDict[@"BrandList"];
            [_carModelTableView reloadData];
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
