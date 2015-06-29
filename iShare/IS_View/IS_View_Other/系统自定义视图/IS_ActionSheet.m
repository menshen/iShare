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
-(UIViewController *)rootController{
    
    if (!_rootController) {
        _rootController = [[UIViewController alloc]init];
    }
    return _rootController;
}
-(UIWindow *)actionSheetWindow{
    
    if (!_actionSheetWindow) {
        _actionSheetWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionSheetWindow.windowLevel = UIWindowLevelStatusBar + [UIApplication sharedApplication].windows.count;
        _actionSheetWindow.userInteractionEnabled =YES;

    }
    return _actionSheetWindow;
}
- (void)showActionSheetAtView:(UIView *)view
              actonSheetBlock:(IS_ActonSheetBlock)actonSheetBlock{
    
    self.actonSheetBlock = actonSheetBlock;
    
//
    
    if (view) {
        [view addSubview:self];

    }else{
        UIView * contain_v =  [UIApplication sharedApplication].keyWindow.rootViewController.view;
        [contain_v addSubview:self];
    }
 

//    [self.actionSheetWindow addSubview:self];
//    [self.actionSheetWindow makeKeyAndVisible];

}
#pragma mark - 初始化
- (void)setupActionSheet{
    
    self.backgroundColor = Color(0, 0, 0, 0.5);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissActionSheet)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
   
    /*!
     *  显示变化的视图
     */
  
}
#pragma mark - 关闭
- (void)dismissActionSheet{
    
  
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]&&[touch.view isEqual:self]){
        return YES;
    }
    return NO;
}
@end
