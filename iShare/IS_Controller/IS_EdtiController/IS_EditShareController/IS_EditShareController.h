//
//  IS_EditShareController.h
//  iShare
//
//  Created by wusonghe on 15/4/15.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IS_CaseModel.h"

@interface IS_EditShareController : UIViewController
@property (strong,nonatomic)IS_CaseModel  * caseModel;
@property (copy,nonatomic)CompleteResultBlock completeResultBlock;
- (instancetype)initWithCompleteBlock:(CompleteResultBlock)completeResultBlock;
@end
