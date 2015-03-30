//
//  IS_PopView.h
//  iShare
//
//  Created by 伍松和 on 15/3/16.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "CMPopTipView.h"

typedef void(^IS_PopViewBtnAction)(id result);

@interface IS_EditPopView : CMPopTipView
@property (copy,nonatomic)IS_PopViewBtnAction popViewBtnAction;
-(instancetype)initWithFrame:(CGRect)frame
            popViewBtnAction:(IS_PopViewBtnAction)popViewBtnAction;

@end
