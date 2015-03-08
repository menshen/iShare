//
//  IS_SenceController.m
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_WebContentController.h"

@interface IS_WebContentController ()

@end

@implementation IS_WebContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loadingBarTintColor=IS_SYSTEM_COLOR;
    self.buttonTintColor=IS_SYSTEM_COLOR;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"分享" themeColor:IS_SYSTEM_COLOR target:self action:@selector(jumpToShare:)];

    
}
-(void)jumpToShare:(id)item{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
