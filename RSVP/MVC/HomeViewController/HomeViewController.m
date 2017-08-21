//
//  HomeViewController.m
//  RSVP
//
//  Created by Arshdeep Singh on 29/07/17.
//  Copyright © 2017 Arshdeep Singh. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController (){
    UIWebView *webView;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    [self.sideMenuViewController setPanFromEdge:NO];
    [self.sideMenuViewController setPanGestureEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuButtonAction:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}
- (IBAction)openTermsButtonAction:(id)sender {
     webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-50,20, 50, 30)];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closewebView:) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:close];
    [webView bringSubviewToFront:close];
    NSURL *targetURL = [[NSBundle mainBundle] URLForResource:@"RSVP terms-conditions-pdf-english" withExtension:@"pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}
- (IBAction)openPolicyButton:(id)sender {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIButton *close = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-50,20, 50, 30)];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closewebView:) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:close];
    [webView bringSubviewToFront:close];
    NSURL *targetURL = [[NSBundle mainBundle] URLForResource:@"Privacy-Policy-pdf-english" withExtension:@"pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

-(IBAction)closewebView:(id)sender{
    [webView removeFromSuperview];
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
