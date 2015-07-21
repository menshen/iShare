//
//  IS_MineCaseHeaderView.h
//  iShare
//
//  Created by wusonghe on 15/3/24.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_MiniHeaderView_ID @"IS_MiniHeaderView"
@interface IS_MiniHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView  *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end
