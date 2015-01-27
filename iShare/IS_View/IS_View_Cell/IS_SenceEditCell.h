//
//  IS_SenceEditCell.h
//  iShare
//
//  Created by 伍松和 on 15/1/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IS_SenceCreateEditView.h"
#import "IS_SenceTemplateModel.h"
#import "UITableViewCell+JJ.h"

@interface IS_SenceEditCell : UICollectionViewCell

/**
 *  模板编辑视图的模板模型
 */
@property (nonatomic,strong)IS_SenceTemplateModel * senceTemplateModel;

@property (strong, nonatomic) IBOutlet IS_SenceCreateEditView * senceCreateEditView;


@end