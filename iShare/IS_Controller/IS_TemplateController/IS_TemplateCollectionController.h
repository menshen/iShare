//
//  IS_TemplateController.h
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

/**
 *  模板选择控制器
 */


@protocol IS_TemplateCollectionControllerDelegate <NSObject>
/**
 *  模板选择
 */
- (void)IS_TemplateCollectionControllerDidSelectItem:(id)result;

@end

#import <UIKit/UIKit.h>

@interface IS_TemplateCollectionController : UIViewController
///场景类型:无，婚礼,宠物等
@property (nonatomic,assign)NSInteger sence_type;
///场景子类型: 婚礼A，婚礼B....
@property (nonatomic,assign)NSInteger sence_sub_type;

@property (nonatomic,weak)id<IS_TemplateCollectionControllerDelegate>delegate;
///类型:多字 少字 纯图
//@property (nonatomic,assign)IS_TemplateStyle templateStyle;
@end
