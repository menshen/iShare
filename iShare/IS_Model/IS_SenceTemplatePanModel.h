//
//  IS_SenceTemplatePanModel.h
//  iShare
//
//  Created by 伍松和 on 15/1/31.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_BaseModel.h"

@interface IS_SenceTemplatePanModel : IS_BaseModel
/**
 ID
 */
@property (nonatomic,assign)NSInteger s_Id;
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
@property (nonatomic,assign)NSInteger s_template_style;
/**
 *  子模板编号
 */
@property (nonatomic,assign)NSInteger s_sub_template_style;
/**
 *  缩略图是否被选中
 */
@property (nonatomic,assign)BOOL is_selected;

@property (nonatomic ,assign)NSInteger img_count;
@end
