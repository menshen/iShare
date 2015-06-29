//
//  IS_HomeLoginController.m
//  iShare
//
//  Created by wusonghe on 15/4/7.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_HomeLoginController.h"
#import "WXApi.h"
#import "IS_LoginController.h"
#import "IS_RegisterViewController.h"

@interface IS_HomeLoginController ()

@end

@implementation IS_HomeLoginController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)phoneLogin:(id)sender {
    
    IS_LoginController * loginVC = [[IS_LoginController alloc]init];
    
//    ADTransition * animation = [[ADModernPushTransition alloc] initWithDuration:.2 orientation:3 sourceRect:self.view.frame];
//    ADTransitioningDelegate * transitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:animation];
//    loginVC.transitioningDelegate = transitioningDelegate;
    
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (IBAction)registerAction:(id)sender {
    IS_RegisterViewController * registerVC = [[IS_RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

#pragma mark - 微信登陆
- (IBAction)wechatAction:(id)sender {
    
    [self sendAuthRequest];

}
#define WX_SCOPE @"snsapi_userinfo,snsapi_base"

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope =WX_SCOPE;
    req.state = @"9999" ;
    [WXApi sendReq:req];
}
- (IBAction)closeAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showViewController:(UIViewController *)vc sender:(id)sender{
    
}

@end
