//
//  IS_EditOperatingView.h
//  iShare
//
//  Created by 伍松和 on 15/3/19.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IS_BottomEditViewBtnBlock)(id result);
typedef NS_ENUM(NSInteger, IS_BottomEditViewButtonType) {
    
    IS_BottomEditViewButtonTypeTemplate,
    IS_BottomEditViewButtonTypeMenu,
    IS_BottomEditViewButtonTypeAdd,
    IS_BottomEditViewButtonTypeTrash,
    IS_BottomEditViewButtonTypeMusic,
    IS_BottomEditViewButtonTypeDone,

};
@interface IS_BottomEditView : UIImageView

@property (nonatomic ,copy)IS_BottomEditViewBtnBlock btnBlock;

-(instancetype)initWithFrame:(CGRect)frame
                    btnBlock:(IS_BottomEditViewBtnBlock)btnBlock;
@end
