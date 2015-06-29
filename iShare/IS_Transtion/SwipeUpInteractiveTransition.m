//
//  SwipeUpInteractiveTransition.m
//  VCTransitionDemo
//
//  Created by 王 巍 on 13-10-13.
//  Copyright (c) 2013年 王 巍. All rights reserved.
//

#import "SwipeUpInteractiveTransition.h"

@interface SwipeUpInteractiveTransition()
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIViewController *presentingVC;
@property (strong,nonatomic)UIPanGestureRecognizer * gesture;
@property (assign,nonatomic)CGFloat percentageAdjustFactor;

@end

@implementation SwipeUpInteractiveTransition
-(void)wireToViewController:(UIViewController *)viewController
{
    self.presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];

}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:_gesture];
    

}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}



- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGPoint beginLocation  = CGPointZero;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            
            self.interacting = YES;
            if (translation.y>=0) {
                [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
            }
            beginLocation  = [gestureRecognizer velocityInView:gestureRecognizer.view.superview];
         

            break;
        case UIGestureRecognizerStateChanged: {
            

            // 2. Calculate the percentage of guesture
            CGFloat fraction = translation.y / (ScreenHeight-beginLocation.y);// 460;
            fraction = fminf(fmaxf(fraction, 0.0), 1);
            self.shouldComplete = (fraction > 0.32);
            
            
//            CGFloat progress = (fraction<0.5)?fraction:(fraction-0.1);
            [self updateInteractiveTransition:fraction];
        
            if (fraction>.5) {
                [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
            }
            
//
//            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 3. Gesture over. Check if the transition should happen or not
            self.interacting = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];

            }
            
            beginLocation  = CGPointZero;
            

            break;
        }
        default:
            break;
    }
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.percentageAdjustFactor = 2.5;
    }
    return self;
}

//- (void)attachToViewController:(UIViewController*)viewController
//{
//    self.parentViewController = viewController;
//    UIScreenEdgePanGestureRecognizer *edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanRecognizer:)];
//    edgePanRecognizer.edges = UIRectEdgeLeft;
//    [self.parentViewController.view addGestureRecognizer:edgePanRecognizer];
//}
//
//- (void)handleEdgePanRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer
//{
//    NSAssert(self.parentViewController != nil, @"parent view controller was not set");
//    CGFloat progress = [recognizer translationInView:self.parentViewController.view].x / self.parentViewController.view.bounds.size.width / self.percentageAdjustFactor;
//    progress = MIN(1.0, MAX(0.0, progress));
//    switch (recognizer.state) {
//        case UIGestureRecognizerStateBegan:
//            [self.parentViewController.navigationController popViewControllerAnimated:YES];
//            break;
//        case UIGestureRecognizerStateChanged: {
//            [self updateInteractiveTransition:progress];
//            break;
//        }
//        default:
//            if ([recognizer velocityInView:self.parentViewController.view].x >= 0) {
//                [self finishInteractiveTransition];
//                [self.parentViewController.view removeGestureRecognizer:recognizer];
//            }
//            else
//                [self cancelInteractiveTransition];
//            break;
//    }
//}

@end
