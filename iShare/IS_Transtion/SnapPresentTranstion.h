//
//  SnapPresentTranstion.h
//  iShare
//
//  Created by wusonghe on 15/6/1.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

typedef NS_ENUM(NSInteger, TransitionMode){
    Present,
    Dismiss
};

#import <Foundation/Foundation.h>


@protocol SnapPresentTranstionDelegate <NSObject>

- (UIView *)getHeaderView;
//- (UIView *)getHeaderViewCopy;

@end

@interface SnapPresentTranstion : NSObject<UIViewControllerAnimatedTransitioning>

@property (strong,nonatomic)UIView * toView;
@property (strong,nonatomic)UIView * fromView;

@property (assign,nonatomic)CGRect  headerFromFrame;
@property (assign,nonatomic)CGRect  headerToFrame;

@property (nonatomic, assign) NSTimeInterval duration;

@property (assign,nonatomic)TransitionMode transitionMode;

@property (assign,nonatomic)id<SnapPresentTranstionDelegate> delegate;



@end
