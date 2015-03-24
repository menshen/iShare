//
//  IS_HomeHeaderView.h
//  iShare
//
//  Created by wusonghe on 15/3/23.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^IS_HomeHeaderViewScrollStateAction)(id result);

@interface IS_HomeHeaderView : UICollectionReusableView
@property (copy,nonatomic)IS_HomeHeaderViewScrollStateAction scrollStateAction;

- (void)setupScrollStateAction:(IS_HomeHeaderViewScrollStateAction)scrollStateAction;

@end
