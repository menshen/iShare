//
//  IS_HomeHeaderView.h
//  iShare
//
//  Created by wusonghe on 15/3/23.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IS_CaseShowView.h"
#define IS_CaseHotShowView_ID @"IS_CaseHotShowView"

typedef void(^IS_HomeHeaderViewScrollStateAction)(id result);
typedef void(^DidSelectBlock)(id result);

@interface IS_CaseHotShowView : UICollectionReusableView<IS_CollectionViewDelegate>
@property (copy,nonatomic)IS_HomeHeaderViewScrollStateAction scrollStateAction;
@property (copy,nonatomic)NSString * actionType;
@property (copy,nonatomic)IS_CaseShowView *showView;//活动滚动视图


- (void)setupScrollStateAction:(IS_HomeHeaderViewScrollStateAction)scrollStateAction;

@property (copy,nonatomic)DidSelectBlock  didSelectBlock;
- (void)addActionWithSelectBlock:(DidSelectBlock)didSelectBlock;
@end
