//
//  BZ_DisplayBarCell.h
//  BeautyWall
//
//  Created by 伍松和 on 15/3/17.
//  Copyright (c) 2015年 Wawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_ActivityShowCell_ID @"IS_ActivityShowCell"
@class IS_ActivityModel;
@interface IS_ActivityShowCell : UICollectionViewCell

@property (strong,nonatomic)IS_ActivityModel * activityModel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLab;
@end
