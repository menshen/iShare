//
//  IS_EditChooseController.h
//  iShare
//
//  Created by wusonghe on 15/4/7.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_CollectionViewController.h"
#import "IS_EditShowModel.h"

@protocol IS_EditChooseControllerDelegate <NSObject>

- (void)IS_EditChooseControllerDidSelect:(id)result;

@end

@interface IS_EditChooseController : IS_CollectionViewController
/**
 *  @brief  模板类型
 */
@property (assign,nonatomic)IS_TemplateStyle tempateStyle;
@property (weak,nonatomic)id<IS_EditChooseControllerDelegate> delegate;
@end
