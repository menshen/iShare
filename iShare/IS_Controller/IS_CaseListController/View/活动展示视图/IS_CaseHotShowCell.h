//
//  BZ_DisplayBarCell.h
//  BeautyWall
//
//  Created by 伍松和 on 15/3/17.
//  Copyright (c) 2015年 Wawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IS_CaseModel.h"
#define IS_CaseHotShowCell_ID @"IS_CaseHotShowCell"
//@class IS_ActivityModel;
@interface IS_CaseHotShowCell : UICollectionViewCell

@property (strong,nonatomic)IS_CaseModel * caseModel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLab;
@property (weak, nonatomic) IBOutlet UIView
*coverView;
@property (weak, nonatomic) IBOutlet UILabel *readLab;
@end
