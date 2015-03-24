//
//  IS_ShareMenuController.m
//  iShare
//
//  Created by 伍松和 on 15/3/19.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_ShareMenuController.h"
#import "IS_LoadingView.h"
#import "KVNProgress.h"

@interface IS_ShareMenuController ()
@property (strong ,nonatomic)IS_LoadingView * loadingView;
@end

@implementation IS_ShareMenuController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBaseKVNProgressUI];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    //1.
   // [self setupLoadingView];
    
    //2.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KVNProgress showProgress:0.10f
                   parameters:@{KVNProgressViewParameterStatus: @"Loading with progress...",
                                KVNProgressViewParameterFullScreen: @(YES)}];
    
    [self updateProgress];
    
    dispatch_main_after(2.7f, ^{
        [KVNProgress updateStatus:@"You can change to a multiline status text dynamically!"];
    });
    dispatch_main_after(5.5f, ^{
        [self showSuccess];
    });
    

}
- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 75.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
}


- (void)setupCustomKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor lightGrayColor];
    [KVNProgress appearance].statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    
    
    
    [KVNProgress appearance].backgroundFillColor = [UIColor greenColor];
    [KVNProgress appearance].backgroundTintColor = [UIColor blackColor];
    [KVNProgress appearance].successColor = [UIColor whiteColor];
    [KVNProgress appearance].errorColor = [UIColor whiteColor];
    [KVNProgress appearance].circleSize = 110.0f;
    [KVNProgress appearance].lineWidth = 1.0f;
}
#pragma mark - 加载视图
- (void)setupLoadingView{

    [self setupCustomKVNProgressUI];
    
    [self showProgress];

}
- (void)showProgress
{
//    [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: @"Success",
//    KVNProgressViewParameterFullScreen: @(YES)}];
   // [KVNProgress showSuccessWithStatus:@"Loading..."];


   
    
}

- (IBAction)showSuccess
{
    if ([self isFullScreen]) {
        [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: @"Success",
                                                 KVNProgressViewParameterFullScreen: @(YES)}];
    } else {
        [KVNProgress showSuccessWithStatus:@"Success"];
    }
}
#pragma mark - Helper

- (void)updateProgress
{
    dispatch_main_after(2.0f, ^{
        [KVNProgress updateProgress:0.3f
                           animated:YES];
    });
    dispatch_main_after(2.5f, ^{
        [KVNProgress updateProgress:0.5f
                           animated:YES];
    });
    dispatch_main_after(2.8f, ^{
        [KVNProgress updateProgress:0.6f
                           animated:YES];
    });
    dispatch_main_after(3.7f, ^{
        [KVNProgress updateProgress:0.93f
                           animated:YES];
    });
    dispatch_main_after(5.0f, ^{
        [KVNProgress updateProgress:1.0f
                           animated:YES];
    });
}

- (BOOL)isFullScreen
{
    return YES;
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

//-(void)showLoading{
//    
//    [_loadingView showLoading];
//    [UIView animateWithDuration:.2 animations:^{
//        _loadingView.y = 0;
//    }];
//}
//- (void)hideLoading{
//    [UIView animateWithDuration:.2 animations:^{
//        _loadingView.y = -ScreenHeight;
//
//    } completion:^(BOOL finished) {
//        [_loadingView hideLoading];
//
//    }];
//  
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
