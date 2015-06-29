//
//  IS_ImageAssetPickerView.m
//  iShare

#import "IS_EditAssetPickerView.h"
#import "UzysAssetsPickerController.h"
#import "ZYQAssetPickerController.h"
#import "KVNProgress.h"
#import "UIWindow+JJ.h"
@interface IS_EditAssetPickerView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>


@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) UIWindow *actionsheetWindow;
@property (nonatomic, strong) UIWindow *oldKeyWindow;

/**
 *  图片选择器
 */
@property (nonatomic,strong)UIImagePickerController * imagePickerController;
@property (strong,nonatomic)ZYQAssetPickerController * zyqAssetPickerController;

@property (nonatomic,strong)UIViewController * rootController;


@end
@implementation IS_EditAssetPickerView

-(UIImagePickerController *)imagePickerController{

    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
    
}

-(ZYQAssetPickerController *)zyqAssetPickerController{

    if (!_zyqAssetPickerController) {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 5;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        _zyqAssetPickerController = picker;
    }
   
    return _zyqAssetPickerController;
}
-(UIViewController *)rootController{
    
    if (!_rootController) {
        _rootController = [[UIViewController alloc]init];
    }
    return _rootController;
}
#pragma mark - 显示

- (void)showAnimationAtContainerView:(UIView *)containerView
                assetPickerViewBlock:(IS_ImageAssetPickerViewBlock)assetPickerViewBlock
                 assetPickerViewType:(IS_EditAssetPickerViewType)type{
    
    
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.assetPickerViewBlock = assetPickerViewBlock;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.opaque = NO;
    window.userInteractionEnabled =YES;
    window.windowLevel = UIWindowLevelStatusBar;
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
                         if (type ==IS_EditAssetPickerViewTypeOrigin) {
                             [self.rootController presentViewController:self.imagePickerController animated:YES completion:nil];
                         }
                         if (type == IS_EditAssetPickerViewTypeAsset) {
//                             self.assetsPickerController.delegate =self;
                             [self.rootController presentViewController:self.zyqAssetPickerController animated:YES completion:nil];
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
}

- (void)disMiss {

//    ActionSheetViewController *viewController =(ActionSheetViewController*)self.actionsheetWindow.rootViewController;

     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
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
                         if (self.imagePickerController) {
                             [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
                             self.rootController=nil;

                             self.imagePickerController = nil;

                         }
                       
                         if (self.zyqAssetPickerController) {
                             [self.zyqAssetPickerController dismissViewControllerAnimated:YES completion:nil];
                             self.rootController=nil;
                             self.zyqAssetPickerController= nil;
                         }

                     }
                     completion:^(BOOL finished) {
                        
                       
                     }];
    
    
}


-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
   
    
        [self disMiss];

    
        NSMutableArray * arrayM = [NSMutableArray array];
        NSMutableArray * assetURLM=[NSMutableArray array];
        ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc]init];
        
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([[obj valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
            {
                //           [arrayM addObject:image];
                //            [assetURLM addObject:representation.defaultRepresentation.url];
                
                ALAsset *representation = obj;
                [assetLibrary assetForURL:representation.defaultRepresentation.url resultBlock:^(ALAsset *asset) {
                    UIImage  *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                    NSData * imageData=UIImageJPEGRepresentation(image, 0.000000001);
                    [arrayM addObject:[UIImage imageWithData:imageData]];
                    [assetURLM addObject:representation.defaultRepresentation.url.absoluteString];
                    
                    if (arrayM.count==assets.count) {
                        if (self.assetPickerViewBlock) {
                            self.assetPickerViewBlock(arrayM);
                            [UIWindow dismissWithHUD];
                        }
                    }
                } failureBlock:nil];
                
                
                
            }
        }];
    
}


-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker{
    if (self.assetPickerViewBlock) {
        self.assetPickerViewBlock(nil);
        [self disMiss];
    }
}
#pragma mark - 普通图片选择器
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self disMiss];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    if (self.assetPickerViewBlock) {
        self.assetPickerViewBlock(image);
    }
    [self disMiss];
    
}

@end
