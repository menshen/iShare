//
//  BouncePresentAnimation.m
//  VCTransitionDemo
//
//  Created by 王 巍 on 13-10-13.
//  Copyright (c) 2013年 王 巍. All rights reserved.
//

#import "BouncePresentAnimation.h"
#import "POPSpringAnimation.h"

@implementation BouncePresentAnimation
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .65;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView *containerView = [transitionContext containerView];

    
    
    UIView * presentedControllerView = nil;
    if (IOS7) {
        UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        presentedControllerView = toVC.view;

    }else{
          presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];

    }
    CGPoint  originalCenter = presentedControllerView.center;

    presentedControllerView.center = CGPointMake(ScreenWidth/2, ScreenHeight);
    [containerView addSubview:presentedControllerView];
    
    // 2. Set init frame for toVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    presentedControllerView.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height-30);
//
    // 3. Add toVC's view to containerView
//    [containerView addSubview:toVC.view];

    
     NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         
                         toVC.view.transform = CGAffineTransformIdentity;
                         presentedControllerView.center = originalCenter;
                         presentedControllerView.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         // 5. Tell context that we completed.
                         [transitionContext completeTransition:YES];
                     }];
}
@end
