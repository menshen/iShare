//
//  IS_ActionSheet.h
//  iShare
//
//  Created by wusonghe on 15/3/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IS_ActionSheet : UIView
typedef void(^IS_ActonSheetBlock)(id result);
@property (copy,nonatomic)IS_ActonSheetBlock actonSheetBlock;
@property (strong,nonatomic)UIViewController * rootController;
@property (strong,nonatomic)UIWindow * actionSheetWindow;
@property (strong,nonatomic)UIWindow * oldKeyWindow;

- (void)showActionSheetAtView:(UIView *)view
                     actonSheetBlock:(IS_ActonSheetBlock)actonSheetBlock;

#pragma mark - 显示
- (void)setupActionSheet;
- (void)dismissActionSheet;
@end
