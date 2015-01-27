//
//  IS_NavigationController.m
//  iShare
//
//  Created by 伍松和 on 15/1/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_NavigationController.h"

@implementation IS_NavigationController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
//    if (self.viewControllers.count) {
//        viewController.hidesBottomBarWhenPushed = YES;
//        
//    }
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count) {
        [viewController navigationItem].backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:NULL];}
    
}
@end
