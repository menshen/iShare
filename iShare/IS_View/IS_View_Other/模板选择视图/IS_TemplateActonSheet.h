//
//  IS_TemplateActonSheet.h
//  iShare
//
//  Created by wusonghe on 15/3/24.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CollectionView.h"
typedef void(^IS_ActonSheetBlock)(id result);

@interface IS_TemplateActonSheet : IS_CollectionView
@property (copy,nonatomic)IS_ActonSheetBlock actonSheetBlock;
- (void)showAnimationAtContainerView:(UIView *)containerView
                     actonSheetBlock:(IS_ActonSheetBlock)actonSheetBlock;

@end
