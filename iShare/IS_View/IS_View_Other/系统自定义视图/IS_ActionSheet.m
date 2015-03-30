//
//  IS_ActionSheet.m
//  iShare
//
//  Created by wusonghe on 15/3/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_ActionSheet.h"

@interface IS_ActionSheet()<UIGestureRecognizerDelegate>

@end

@implementation IS_ActionSheet
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupActionSheet];
    }
    return self;
}

- (void)showActionSheetAtView:(UIView *)view
              actonSheetBlock:(IS_ActonSheetBlock)actonSheetBlock{
    
    self.actonSheetBlock = actonSheetBlock;
    UIView * contain_v =  [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [contain_v addSubview:self];
}
#pragma mark - 初始化
- (void)setupActionSheet{
    
    self.backgroundColor = Color(0, 0, 0, 0.6);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissActionSheet)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
   
    /*!
     *  显示变化的视图
     */
  
}
#pragma mark - 关闭
- (void)dismissActionSheet{
    
    /*!
     *  关闭变化的视图
     */
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]&&[touch.view isEqual:self]){
        return YES;
    }
    return NO;
}
@end
