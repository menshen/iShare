//
//  IS_SenceTemplatePanModel.h
//  iShare
//
//  Created by 伍松和 on 15/1/31.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_BaseModel.h"
typedef NS_ENUM(NSUInteger, IS_TemplateStyle) {
    IS_TemplateStyleLessWord,
    IS_TemplateStyleMutilWord,
    IS_TemplateStyleNoWord,
};
@interface IS_EditTemplateSelectModel : IS_BaseModel

/**
 *  对应的略缩图
 */
@property (nonatomic,strong)NSString * s_img_name;
/**
 *  模板名字
 */
@property (nonatomic,strong)NSString * s_name;
/**
 *  模板风格
 */
@property (nonatomic,assign)NSInteger type;
/**
 *  子模板编号
 */
@property (nonatomic,assign)NSInteger sub_type;
/**
 *  模板图片类型
 */
@property (nonatomic,assign)IS_TemplateStyle templateStyle;
/**
 *  缩略图是否被选中
 */
@property (nonatomic,assign)BOOL is_selected;
/*!
 *  图片数量
 */
@property (nonatomic ,assign)NSInteger img_count;
/*!
 *  是否为场景
 */
@property (assign ,nonatomic)BOOL isScene;

@end
