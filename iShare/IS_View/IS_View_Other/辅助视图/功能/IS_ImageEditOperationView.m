

@interface WindowViewController : UIViewController
@end
#import "IS_ImageEditOperationView.h"

@interface IS_ImageEditOperationView()
@property (nonatomic, strong) UIWindow *overlayWindow;

@end

@implementation IS_ImageEditOperationView


#pragma mark Lazy views

- (UIWindow *)overlayWindow;
{
    if(_overlayWindow == nil) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
//        _overlayWindow.rootViewController = [[WindowViewController alloc] init];
        _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
        _overlayWindow.rootViewController.wantsFullScreenLayout = YES;
#endif
//        [self updateWindowTransform];
//        [self updateTopBarFrameWithStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    }
    return _overlayWindow;
}
@end
