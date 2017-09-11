//
//  MyProfileVC.m
//  RSVP
//
//  Created by Maninder Singh on 15/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "MyProfileVC.h"

@interface MyProfileVC ()<UITableViewDataSource,UITableViewDelegate,AuthNetDelegate>{
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
-(void)webService{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/GetProfile?UserId=";
    NSString *URLToHit = [url stringByAppendingString:[NSString stringWithFormat:@"%@",[NSUserDefaults.standardUserDefaults objectForKey:@"userId"]]];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 GET: URLToHit parameters:nil progress:nil
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
        
        [AuthNet authNetWithEnvironment:ENV_TEST];
        MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = @"maninderbindra1991";
        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = @"Iphone_5s";
        mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = uniqueIdentifier;
        AuthNet *an = [AuthNet getInstance];
        [an setDelegate:self];
        [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
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

-(void)paymentSucceeded:(CreateTransactionResponse *)response
{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showSuccess:self title:@"Alert" subTitle:[NSString stringWithFormat:@"%@",response.responseReasonText] closeButtonTitle:@"Ok" duration:0.0f];
    [alert alertIsDismissed:^{
        [self webService2];
    }];
    
}
-(void)emvPaymentSucceeded:(AnetEMVTransactionResponse *)response{
    
}

-(void)requestFailed:(AuthNetResponse *)response{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showWarning:self title:@"Alert" subTitle: [NSString stringWithFormat:@"%@",response.responseReasonText] closeButtonTitle:@"OK" duration:0.0f];
}

- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response {
    token = response.sessionToken;
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    CreditCardType *creditCardType = [CreditCardType creditCardType];
    creditCardType.cardNumber = [NSUserDefaults.standardUserDefaults objectForKey:@"cardNumber"];
    creditCardType.cardCode = [NSUserDefaults.standardUserDefaults objectForKey:@"cvv"];
    creditCardType.expirationDate = [NSUserDefaults.standardUserDefaults objectForKey:@"exipryDate"];
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = creditCardType;
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = @"0";
    extendedAmountTypeTax.name = @"Tax";
    
    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeShipping.amount = @"0";
    extendedAmountTypeShipping.name = @"Shipping";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"block";
    lineItem.itemDescription = @"address";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = amounts ;
    lineItem.itemID = @"1";
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = lineItem.itemPrice;
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    requestType.shipping = extendedAmountTypeShipping;
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.transactionType = AUTH_CAPTURE;
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = uniqueIdentifier;
    request.anetApiRequest.merchantAuthentication.sessionToken = token;
    
    AuthNet *an1 = [AuthNet getInstance];
    [an1 setDelegate:self];
    [an1 purchaseWithRequest:request];
};


-(void)webService2{
    [SVProgressHUD show];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSDictionary *dict = @{
                           @"UserId":[NSUserDefaults.standardUserDefaults objectForKey:@"userId"],
                           @"Amount": amounts
                           };
    NSString *url=@"http://rsvp.rootflyinfo.com/api/Values/AddFund";
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager1 POST:url parameters:dict progress:nil
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
