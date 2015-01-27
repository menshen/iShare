//
//  IS_SenceTemplateModel.h
//  iShare
//
//  Created by 伍松和 on 15/1/14.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_BaseModel.h"

@interface IS_SenceTemplateModel : IS_BaseModel
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
@property (nonatomic,assign)NSInteger s_template_stype;
/**
 *  子模板编号
 */
@property (nonatomic,assign)NSInteger s_sub_template_stype;
/**
 *  模板图片数组
 */
@property (nonatomic,strong)NSMutableArray * s_img_array;
/**
 *  模板文字数组
 */
@property (nonatomic,strong)NSMutableArray * s_text_array;

/**
 *  是否当前模板
 */
@property (nonatomic,assign)BOOL s_isCurrent;

@end
