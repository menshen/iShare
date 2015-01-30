//
//  IS_SenceCreateCollectionView.h
//  iShare
//
//  Created by 伍松和 on 15/1/30.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IS_SenceTemplateModel;
@interface IS_SenceCreateCollectionView : UICollectionView

/**
 *  场景数组
 */
@property (nonatomic,strong)NSMutableArray * senceDataSource;

/**
 *  当前编辑中的模型
 */

@property (nonatomic,strong)IS_SenceTemplateModel * currentSenceTemplateModel;

/**
 *  当前单元格位置
 */
@property (nonatomic,strong)NSIndexPath * currentIndexPath;

/**
 *  增加一个变量->>滑动刷新
 */

@end
