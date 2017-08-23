//
//  StreetParkingVC.m
//  RSVP
//
//  Created by Maninder Singh on 15/08/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "StreetParkingVC.h"
#import "MVPlaceSearchTextField.h"

@interface StreetParkingVC ()<PlaceSearchTextFieldDelegate>
@property (strong, nonatomic) IBOutlet MVPlaceSearchTextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *stateTextField;

@end

@implementation StreetParkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    self.addressTextField.placeSearchDelegate = self;
    self.addressTextField.strApiKey= @"AIzaSyAT4NNoOQrBYgaUBqLsJmDaw1CnfkOe4CY";
    self.addressTextField.superViewOfList= self.view;  // View, on which Autocompletion list should be appeared.
    self.addressTextField.autoCompleteShouldHideOnSelection= YES;
    self.addressTextField.maximumNumberOfAutoCompleteRows= 5;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.addressTextField.autoCompleteRegularFontName =  @"HelveticaNeue-Bold";
    self.addressTextField.autoCompleteBoldFontName = @"HelveticaNeue";
    self.addressTextField.autoCompleteTableCornerRadius=0.0;
    self.addressTextField.autoCompleteRowHeight=35;
    self.addressTextField.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    self.addressTextField.autoCompleteFontSize=14;
    self.addressTextField.autoCompleteTableBorderWidth=1.0;
    self.addressTextField.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=YES;
    self.addressTextField.autoCompleteShouldHideOnSelection=YES;
    self.addressTextField.autoCompleteShouldHideClosingKeyboard=YES;
    self.addressTextField.autoCompleteShouldSelectOnExactMatchAutomatically = YES;
    self.addressTextField.autoCompleteTableFrame = CGRectMake(20,150, self.addressTextField.frame.size.width, 300.0);
}


#pragma mark - Place search Textfield Delegates

-(void)placeSearch:(MVPlaceSearchTextField *)textField ResponseForSelectedPlace:(GMSPlace *)responseDict{
   // location = responseDict.coordinate;
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
}


@end
