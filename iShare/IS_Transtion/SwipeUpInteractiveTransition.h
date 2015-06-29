//
//  SwipeUpInteractiveTransition.h
//  VCTransitionDemo
//
//  Created by 王 巍 on 13-10-13.
//  Copyright (c) 2013年 王 巍. All rights reserved.
//

typedef NS_ENUM(NSInteger, InteractiveTransitionDirection) {
    
    DirectionUpToDown,
    DirectionLeftToRight,
    
};


#import <UIKit/UIKit.h>

@interface SwipeUpInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interacting;
- (void)wireToViewController:(UIViewController*)viewController;
@end
