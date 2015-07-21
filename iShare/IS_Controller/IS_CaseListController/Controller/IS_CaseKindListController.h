//
//  IS_CaseKindViewController.h
//  iShare
//
//  Created by wusonghe on 15/5/28.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CollectionViewController.h"
#import "IS_KindBanner.h"
#import "IS_CaseBanneScrollView.h"



@interface IS_CaseKindListController : IS_CollectionViewController
/**
 *  @brief  分类类型
 */
@property (nonatomic,strong)NSString * actionType;

/**
 *  @brief  列表类型
 */
@property (assign,nonatomic)CaseBannerType listType;

/**
 *  @brief  头部
 */
@property (strong,nonatomic)IS_KindBanner * kindBanner;

/**
 *  @brief  滚动视图
 */
@property (strong,nonatomic)IS_CaseBanneScrollView * caseBanneScrollView;


@property (strong,nonatomic)IS_TopicModel * topicModel;



@end
