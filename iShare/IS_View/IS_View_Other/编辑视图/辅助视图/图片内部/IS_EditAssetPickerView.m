//
//  IS_ImageAssetPickerView.m
//  iShare

#import "IS_EditAssetPickerView.h"


@interface IS_EditAssetPickerView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIWindow *actionsheetWindow;
@property (nonatomic, strong) UIWindow *oldKeyWindow;

/**
 *  图片选择器
 */
@property (nonatomic,strong)UIImagePickerController * imagePickerController;

@property (nonatomic,strong)UIViewController * rootController;


@end
@implementation IS_EditAssetPickerView

-(UIImagePickerController *)imagePickerController{

    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc]init];
//        _imagePickerController.editing = YES;
        _imagePickerController.delegate = self;
//        _imagePickerController.allowsEditing = YES;
//        _imagePickerController.sourceType = sourceType;
    }
    return _imagePickerController;
    
}
-(UIViewController *)rootController{
    
    if (!_rootController) {
        _rootController = [[UIViewController alloc]init];
    }
    return _rootController;
}
#pragma mark - 显示

- (void)showAnimationAtContainerView:(UIView *)containerView
                assetPickerViewBlock:(IS_ImageAssetPickerViewBlock)assetPickerViewBlock{
    
    
    self.assetPickerViewBlock = assetPickerViewBlock;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.opaque = NO;
    window.userInteractionEnabled =YES;
    window.windowLevel = UIWindowLevelStatusBar + [UIApplication sharedApplication].windows.count;
    window.rootViewController = self.rootController;
    self.actionsheetWindow = window;
    
    self.oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    [self.actionsheetWindow makeKeyAndVisible];
    
    [self layoutIfNeeded];
    
    self.rootController.view.alpha = 0;
    CGRect targetRect = self.rootController.view.frame;
    CGRect initialRect = targetRect;
    initialRect.origin.y += initialRect.size.height;
    self.rootController.view.frame = initialRect;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.rootController.view.alpha = 1;
                         self.rootController.view.frame = targetRect;
                         [self.rootController presentViewController:self.imagePickerController animated:YES completion:nil];
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self disMiss];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    if (self.assetPickerViewBlock) {
        self.assetPickerViewBlock(image);
    }
     [self disMiss];
    
}
- (void)disMiss {

//    ActionSheetViewController *viewController =(ActionSheetViewController*)self.actionsheetWindow.rootViewController;

    
    [self.actionsheetWindow removeFromSuperview];
    self.actionsheetWindow = nil;
    
    [self.oldKeyWindow makeKeyWindow];
    self.oldKeyWindow = nil;
   
    
    
    CGRect targetRect = self.rootController.view.frame;
    targetRect.origin.y += targetRect.size.height;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.rootController.view.alpha = 0;
                         self.rootController.view.frame = targetRect;
                         [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];

                     }
                     completion:^(BOOL finished) {
                        
                         self.rootController=nil;
                         self.imagePickerController = nil;
                     }];
    
    
}


@end
