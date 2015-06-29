
typedef NS_ENUM(NSInteger, IS_EditAssetPickerViewType) {
    IS_EditAssetPickerViewTypeOrigin,
    IS_EditAssetPickerViewTypeAsset,
};

#import <UIKit/UIKit.h>

typedef void(^IS_ImageAssetPickerViewBlock)(id result);
@interface IS_EditAssetPickerView : UIView
@property (nonatomic, assign) BOOL showed;
@property (copy,nonatomic)IS_ImageAssetPickerViewBlock assetPickerViewBlock;


- (void)showAnimationAtContainerView:(UIView *)containerView
                assetPickerViewBlock:(IS_ImageAssetPickerViewBlock)assetPickerViewBlock
                 assetPickerViewType:(IS_EditAssetPickerViewType)type;
- (void)disMiss;
@end
