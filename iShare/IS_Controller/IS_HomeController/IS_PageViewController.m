//
//  IS_PageViewController.m
//  iShare
//
//  Created by wusonghe on 15/3/30.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_PageViewController.h"
#import "IS_HomeController.h"
#import "IS_CategoryView.h"

@implementation IS_PageViewController{
    IS_CategoryView * _categoryView;

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
//        [self setupCategoryView];
        [self setup];

    }
    return self;
}

- (void)setup{

    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *titles = @[@"1", @"2", @"3", @"4", @"5"];
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        IS_HomeController *tableViewController = [[IS_HomeController alloc] init];
     
        tableViewController.title = title;
        [viewControllers addObject:tableViewController];
    }];
    [titles enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop) {
        
    }];
    self.viewControllers = viewControllers;
    
    self.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
        NSLog(@"cuurentPage : %ld on title : %@", (long)cuurentPage, title);
    };
    
    [self reloadData];
    
}

@end
