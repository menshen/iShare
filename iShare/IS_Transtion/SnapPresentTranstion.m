
#import "SnapPresentTranstion.h"

@implementation SnapPresentTranstion
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .45;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 1. Get controllers from transition context
    //0.获取
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * fromView = fromViewController.view;
    UIView * toView = toViewController.view;
    UIView *containerView = [transitionContext containerView];
    // Prepare header
    UIView * headerTo = _toView;
    UIView * headerFrom = _fromView;
    
    CGFloat duration = [self transitionDuration:transitionContext];


    //1.刷新
    
    [fromView setNeedsLayout];
    [fromView layoutIfNeeded];
    [toView setNeedsLayout];
    [toView layoutIfNeeded];
    
    
    //2.得到相应坐标+属性
    CGFloat alpha = 0.1;
    CGAffineTransform offScreenBottom = CGAffineTransformMakeTranslation(0, containerView.height);
     if (self.transitionMode == Present) {
         self.headerFromFrame = [headerFrom.superview convertRect:headerFrom.frame toView:nil];
         self.headerToFrame =[toViewController.view convertRect:headerTo.frame toView:nil];//CGRectMake(0,0,ScreenWidth, 200);//
         //CGRectMake(0,0,ScreenWidth, 200);//[headerTo.superview convertRect:headerTo.frame toView:nil];//  headerTo.superview!.convertRect(headerTo.frame, toView: nil)

//;////
     }else{
         
//         self.headerFromFrame = [headerFrom.superview convertRect:headerFrom.frame toView:nil];
//         self.headerToFrame = CGRectMake(0,0,ScreenWidth, 250+10);//[headerTo.superview convertRect:headerTo.frame toView:nil];//         headerTo.superview!.convertRect(headerTo.frame, toView: nil)
     }
    
    headerFrom.alpha = 0;
    headerTo.alpha = 0;
    UIView * headerIntermediate = [headerFrom snapshotViewAfterScreenUpdates:NO];
    headerIntermediate.frame = self.transitionMode == Present ? self.headerFromFrame : self.headerToFrame;

    //3.添加视图
    if (self.transitionMode==Present) {
        toView.transform = offScreenBottom;
        
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        [containerView addSubview:headerIntermediate];
    } else {
        toView.alpha = alpha;
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        [containerView addSubview:headerIntermediate];
    }
    
    
    
   

    //4.动;
//    headerIntermediate.transform =CGAffineTransformMakeScale(0.8, 0.8);
//    toView.transform =headerIntermediate.transform;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
        if (self.transitionMode==Present) {
            
            fromView.alpha = alpha;
            toView.transform = CGAffineTransformIdentity;
            headerIntermediate.transform = CGAffineTransformIdentity;
            headerIntermediate.frame = self.headerToFrame;
            
        }else{
            fromView.transform = offScreenBottom;
            toView.alpha = 1.0;
            headerIntermediate.frame = self.headerFromFrame;
        }
        
        
    } completion:^(BOOL finished) {
        
        [headerIntermediate removeFromSuperview];

        headerTo.alpha = 1;
        headerFrom.alpha = 1;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
   
  
}
@end
