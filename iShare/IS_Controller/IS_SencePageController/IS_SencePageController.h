//
//  IS_SenceTemplateController.h
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

/**
 *  场景选择控制器
 */

#import "BaseViewController.h"
#import "IS_HomeController.h"
#import "IS_SceneCollectionController.h"

typedef void(^IS_SencePageDidSelectBlock)(id result);
@interface IS_SencePageController : BaseViewController
@property (assign,nonatomic)IS_SceneChooseType sceneChooseType;
#pragma mark - 展示视图
- (void)showAnimationAtContainerView:(UIView *)containerView
                            selectBlock:(IS_SencePageDidSelectBlock)selectBlock;
@property (copy,nonatomic)IS_SencePageDidSelectBlock selectBlock;
#pragma mark - 消灭视图
@end
