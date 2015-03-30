//
//  IS_ShareMusicCell.h
//  iShare
//
//  Created by 伍松和 on 15/3/10.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"
#define IS_ShareMusicCell_ID @"IS_ShareMusicCell"
@interface IS_ShareMusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *music_lab;
@property (weak, nonatomic) IBOutlet UIButton *music_play_btn;
@end
