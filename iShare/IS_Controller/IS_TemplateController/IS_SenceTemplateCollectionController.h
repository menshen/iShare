//
//  IS_SenceTemplateCollectionController.h
//  iShare
//
//  Created by 伍松和 on 15/3/9.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "BaseViewController.h"
#import "IS_TempateCollectionCell.h"
#import "IS_CommonLayout.h"
#import "IS_SenceTemplatePanModel.h"

@interface IS_SenceTemplateCollectionController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  模板数据源
 */
@property (nonatomic,strong)NSMutableArray * template_dataSource;
@property (nonatomic ,strong)UICollectionView * collectionview;

@end