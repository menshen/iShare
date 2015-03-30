//
//  IS_LoadingView.h
//  iShare
//
//  Created by 伍松和 on 15/3/13.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTSpinKitView.h"
@interface IS_LoadingView : UIView

/**
 *  加载视图
 */
@property (nonatomic,strong)RTSpinKitView * loadingView;
/**
 *  重新上传按钮
 */
@property (nonatomic,strong)UIButton * refreshBtn;

-(void)showLoading;
- (void)hideLoading;
@end
