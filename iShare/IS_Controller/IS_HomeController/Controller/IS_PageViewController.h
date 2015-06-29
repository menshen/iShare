//
//  IS_PageViewController.h
//  iShare
//
//  Created by wusonghe on 15/3/30.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "SH_PageViewController.h"
#import "IS_CategoryView.h"

@interface IS_PageViewController : SH_PageViewController
/**
 *  显示title集合的容器
 */
@property (nonatomic, strong) IS_CategoryView *categoryView;
@end
