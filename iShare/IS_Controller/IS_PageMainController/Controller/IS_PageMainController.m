//
//  IS_PageViewController.m
//  iShare
//
//  Created by wusonghe on 15/3/30.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_PageMainController.h"
#import "IS_CategoryView.h"
#import "iShare_Marco.h"
#import "IS_SenceEditTool.h"
#import "IS_TopicViewController.h"
#import "IS_CaseKindListController.h"
#import "IS_KindListController.h"




@interface IS_PageMainController()<UINavigationControllerDelegate>
@end

@implementation IS_PageMainController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setup];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navigationController.delegate =self;

}
- (void)setup{
    


    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray *actionTypes = @[@"kind",ACTIONTYPE_ALL,@"topic"];
    NSMutableArray * actionsss = [NSMutableArray arrayWithArray:actionTypes];
    
//    [actionsss addObjectsFromArray:ACTIONTYPE_ARRAY];
    [actionsss enumerateObjectsUsingBlock:^(NSString *actionType, NSUInteger idx, BOOL *stop) {
        
        if (idx==0) {
            IS_KindListController * kindVC = [[IS_KindListController alloc]init];
            [viewControllers addObject:kindVC];
            
        }else if(idx==1){
            IS_CaseKindListController*homeController = [[IS_CaseKindListController alloc] init];
            homeController.actionType = actionType;
            homeController.listType = CaseBannerTypeNone;
            [viewControllers addObject:homeController];
            
        
            
        }else if (idx==2){
            
            IS_TopicViewController * topicVC = [[IS_TopicViewController alloc]init];
            [viewControllers addObject:topicVC];
        }
       
    }];
    self.viewControllers = viewControllers;
    self.titles = actionsss;// ACTION_TYPE_NAME_ARRAY;
        
    
    
    self.centerContainerView.y+=(IS_NAV_BAR_HEIGHT);
    self.centerContainerView.height-=(IS_TABBAR_H+IS_NAV_BAR_HEIGHT-4);
    self.paggingScrollView.frame= self.centerContainerView.bounds;
    

    [self reloadData];


    
}//    self.categoryView.currentItemIndex = currentPage;



@end
