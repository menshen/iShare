//
//  IS_EditMusicCell.h
//  iShare
//
//  Created by wusonghe on 15/3/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IS_MusicModel.h"
#define IS_EditMusicCell_ID @"IS_EditMusicCell"
@interface IS_EditMusicCell : UITableViewCell
@property (strong,nonatomic)IS_MusicModel * musicModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@end
