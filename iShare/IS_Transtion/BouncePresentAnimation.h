//
//  BouncePresentAnimation.h
//  VCTransitionDemo
//
//  Created by 王 巍 on 13-10-13.
//  Copyright (c) 2013年 王 巍. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BouncetransitionMode) {
    PresentMode,
    DismissMode,
};

@interface BouncePresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign,nonatomic)BouncetransitionMode transitionMode;

@end
