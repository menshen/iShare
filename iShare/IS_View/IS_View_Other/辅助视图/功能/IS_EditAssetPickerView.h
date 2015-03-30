//
//  IS_ImageAssetPickerView.h
//  iShare
//
//  Created by 伍松和 on 15/3/16.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IS_ImageAssetPickerViewBlock)(id result);
@interface IS_EditAssetPickerView : UIView
@property (nonatomic, assign) BOOL showed;
@property (copy,nonatomic)IS_ImageAssetPickerViewBlock assetPickerViewBlock;


- (void)showAnimationAtContainerView:(UIView *)containerView
                assetPickerViewBlock:(IS_ImageAssetPickerViewBlock)assetPickerViewBlock;
- (void)disMiss;
@end
