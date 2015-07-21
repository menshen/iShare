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
#import "iShare_Marco.h"




@interface IS_PageViewController()<IS_CategoryViewDelegate>
@end

@implementation IS_PageViewController
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
      //  self.automaticallyAdjustsScrollViewInsets = NO;
        [self setup];
        


    }
    return self;
}
#define IS_CategoryView_H 40


- (void)setupCategoryView{
    
    self.categoryView = [[IS_CategoryView alloc]initWithFrame:CGRectMake(0, IS_NAV_BAR_HEIGHT, ScreenWidth, IS_CategoryView_H)];
    self.categoryView.itemTitles = self.titles;
    self.categoryView.ca_delegate =self;
    [self.categoryView  updateData];
//    [self.view insertSubview:self.categoryView aboveSubview:self.centerContainerView];
    [self.centerContainerView insertSubview:self.categoryView atIndex:0];
    self.paggingScrollView.y+=IS_CategoryView_H+IS_NAV_BAR_HEIGHT;
//    self.paggingScrollView.height-=IS_CategoryView_H;


}
- (void)setup{
    


    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *actionTypes = ACTIONTYPE_ARRAY;
    [actionTypes enumerateObjectsUsingBlock:^(NSString *actionType, NSUInteger idx, BOOL *stop) {
        IS_HomeController *homeController = [[IS_HomeController alloc] init];
        homeController.actionType = actionType;
        [viewControllers addObject:homeController];
    }];
    self.viewControllers = viewControllers;
    self.titles = ACTION_TYPE_NAME_ARRAY;
    self.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
        NSLog(@"cuurentPage : %ld on title : %@", (long)cuurentPage, title);
    };

    [self reloadData];
    
    
    [self setupCategoryView];


    
}//    self.categoryView.currentItemIndex = currentPage;
- (void)setCurrentPage:(NSInteger)currentPage {

    [super setCurrentPage:currentPage];
    [self.categoryView setCurrentItemIndex:currentPage];
    
}
-(void)itemDidSelectedWithIndex:(NSInteger)index{
    
    CGPoint contentOffset = CGPointMake(index* CGRectGetWidth(self.paggingScrollView.frame), 0);
    [self.paggingScrollView setContentOffset:contentOffset animated:YES];
    
    //    [self setCurrentPage:index];
}

@end
