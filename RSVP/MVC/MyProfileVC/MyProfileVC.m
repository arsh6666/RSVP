//
//  MyProfileVC.m
//  RSVP
//
//  Created by Maninder Singh on 15/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "MyProfileVC.h"

@interface MyProfileVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary *myDetail;
    NSMutableArray *sendArray,*recivedArray;
    NSString *token;
    NSString *uniqueIdentifier;
    NSString *amounts;
    NSDateFormatter *formate;
    
}

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property(nonatomic, retain)CreditCardPayment *ccPayment;

- (IBAction)btnAddBalance:(id)sender;

@end

@implementation MyProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self webService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editProfileButton:(id)sender {
    EditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    vc.myProfileDetail = myDetail;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setUpMyProfile
{
    _nameLabel.text = myDetail[@"FirstName"];
    _emailLabel.text = myDetail[@"Email"];
    _totalBalanceLabel.text = [NSString stringWithFormat:@"$ %ld",[[myDetail valueForKey:@"WalletBalance"]integerValue]];
}

- (IBAction)menuButtonAction:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (IBAction)segmentAction:(id)sender {
    [_historyTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segment.selectedSegmentIndex == 0)
    {
        return sendArray.count;
    }
    else
    {
        return recivedArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    
    MyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyProfileCell"];
    
        formate = [[NSDateFormatter alloc]init];
        [formate setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        formate.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
        
    if (_segment.selectedSegmentIndex == 0)
    {
        
        
        NSString *dateSTR = [[sendArray valueForKey:@"Date"]objectAtIndex:indexPath.row];
        NSDate *date = [formate dateFromString:dateSTR];
        [formate setTimeZone:[NSTimeZone systemTimeZone]];
        NSString *finalDate = [formate stringFromDate:date];
        
        
        cell.leftLabel.text =[NSString stringWithFormat:@"%@ \n %@", [[sendArray valueForKey:@"Address"]objectAtIndex:indexPath.row],finalDate];
        cell.rightLabel.text = [NSString stringWithFormat:@"$ %@", [[sendArray valueForKey:@"Amount"]objectAtIndex:indexPath.row]];
    }
    else
    {
        
        
        NSString *dateSTR = [[recivedArray valueForKey:@"Date"]objectAtIndex:indexPath.row];
        NSDate *date = [formate dateFromString:dateSTR];
        [formate setTimeZone:[NSTimeZone systemTimeZone]];
        NSString *finalDate = [formate stringFromDate:date];

        cell.leftLabel.text =[NSString stringWithFormat:@"%@ \n %@", [[recivedArray valueForKey:@"Address"]objectAtIndex:indexPath.row],finalDate];
        cell.rightLabel.text = [NSString stringWithFormat:@"$ %@", [[recivedArray valueForKey:@"Amount"]objectAtIndex:indexPath.row]];
        
    }
    return cell;

}


-(void)webService
{
    [SVProgressHUD show];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSString *URL = [NSString stringWithFormat:@"%@?UserId=%@",GetProfile,[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]];
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URL parameters:nil progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *jsonDict = responseObject;
              [SVProgressHUD dismiss];
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];

              if ([jsonDict[@"Success"] boolValue]){
                  
                  myDetail = jsonDict;
                  if ([myDetail valueForKey:@"PaymentSend"] == [NSNull null]) {
                      sendArray = [NSMutableArray new];
                  }
                  else
                  {
                      sendArray = [myDetail valueForKey:@"PaymentSend"];
                  }
                  
                  
                  if ([myDetail valueForKey:@"PaymentRecive"] == [NSNull null]) {
                      recivedArray = [NSMutableArray new];
                  }
                  else
                  {
                      recivedArray = [myDetail valueForKey:@"PaymentRecive"];
                  }
                  [self.historyTableView reloadData];
                  
                  [self setUpMyProfile];
              }
              else
              {
                  SCLAlertView *alert = [[SCLAlertView alloc] init];
                  [alert showWarning:self title:@"Alert" subTitle: @"Currently no bid available." closeButtonTitle:@"OK" duration:0.0f];
              }
              NSLog(@"%@",responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [SVProgressHUD dismiss];
              NSLog(@"%@",error);
          }];
    
}
- (IBAction)btnAddBalance:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Funds" message:@"Choose amount of funds you'd want to keep in your RSVP Wallet. These funds can always be returned to you upon request" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField addTarget:self action:@selector(AddFunds:) forControlEvents:UIControlEventEditingChanged];
         [textField addTarget:self action:@selector(StartAddFunds:) forControlEvents:UIControlEventEditingDidBegin];
        textField.placeholder = @"Amount";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alert.textFields;
        UITextField * namefield = textfields[0];
       
        
        amounts = [namefield.text stringByReplacingOccurrencesOfString:@"$ " withString:@""];
        
        if (![amounts isEqualToString:@"$ "])
        {
            
        NSLog(@"%@",namefield.text);
        
        [SVProgressHUD show];
        
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
            Constants *shareManager = [Constants sharedManager];
            
            /*
             * This are the required information, which need to initialize
             * Before doing any transactions
             */
            shareManager.isProduction = true;
            shareManager.sourceKey = USAePaySourceKey;
            shareManager.pinNum = USAePayPin;
            
            /*
             * Before we call the process payment method,
             * We need to set the required values in credit card payment class
             */
            
            
            
            NSString *cardNumber = [NSUserDefaults.standardUserDefaults objectForKey:@"cardNumber"];
            NSString *cvv = [NSUserDefaults.standardUserDefaults objectForKey:@"cvv"];
            NSString *billingZip = [NSUserDefaults.standardUserDefaults objectForKey:@"billingZip"];
            NSString *expire = [NSUserDefaults.standardUserDefaults objectForKey:@"exipryDate"];
            
            NSString *expireDate = [expire stringByReplacingOccurrencesOfString:@"/" withString:@""];
            
            _ccPayment = [[CreditCardPayment alloc]init];
            _ccPayment.delegate = self;
            
            _ccPayment.creditCardHolderName = myDetail[@"FirstName"];
            _ccPayment.creditCardNumber = cardNumber;
            _ccPayment.creditCardExpDate = expireDate;
            _ccPayment.creditCardCVV = cvv ;
            _ccPayment.creditCardAvsStreet = @"123";
            _ccPayment.creditCardAvsZip = billingZip;
            _ccPayment.creditCardChargeAmount = amounts;
            
            [_ccPayment processCCPayment];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

}
    
-(IBAction)AddFunds:(UITextField *)sender
{
    if ([sender.text length]==1)
    {
        sender.text = @"$ ";
    }
    else
    {
       sender.text = sender.text;
    }
}
    
-(IBAction)StartAddFunds:(UITextField *)sender
{
    sender.text = @"$ ";
}



-(void)finishProcessingPayment :(uesoapTransactionResponse *)response
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSLog(@"%@",response.Error);
    [SVProgressHUD dismiss];
    
    if ([response.Result isEqualToString:@"Approved"]) {
       
        /*
         * Use an alert to display the payment result status
         */
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        [alert showSuccess:self title:@"Alert" subTitle:[NSString stringWithFormat:@"%@",response.Result] closeButtonTitle:@"Ok" duration:0.0f];
        [alert alertIsDismissed:^{
            [self AddFundMethod];
        }];

        
    }
    else
    {
        [alert showError:self title:@"Alert" subTitle:response.Error closeButtonTitle:@"Ok" duration:1.0f];
    }
    
    
}

-(void)AddFundMethod
{
    
    [SVProgressHUD show];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSDictionary *dict = @{
                           @"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"Amount": amounts
                           };
    
    
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:AddFund parameters:dict progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [SVProgressHUD dismiss];
               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
               NSDictionary *jsonDict = responseObject;
               if ([jsonDict[@"Success"] boolValue]){
                   
                   SCLAlertView *alert = [[SCLAlertView alloc] init];
                   [alert showSuccess:self title:@"Alert" subTitle:[NSString stringWithFormat:@" Funds Added in wallet Successfully"] closeButtonTitle:@"Ok" duration:0.0f];
                   [alert alertIsDismissed:^{
                       [self webService];
                   }];
                   
               }else{
                   
               }
               NSLog(@"%@",responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [SVProgressHUD dismiss];
               NSLog(@"%@",error);
           }];
    
}


@end
