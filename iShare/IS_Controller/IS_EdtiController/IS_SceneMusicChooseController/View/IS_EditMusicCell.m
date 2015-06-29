//
//  IS_EditMusicCell.m
//  iShare
//
//  Created by wusonghe on 15/3/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_EditMusicCell.h"

@implementation IS_EditMusicCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle =UITableViewCellSelectionStyleNone;
//    self.backgroundView = nil;
//    self.backgroundColor = nil;
    self.selectedBackgroundView=nil;
}
-(void)setMusicModel:(IS_MusicModel *)musicModel{

    _musicModel = musicModel;
    
    self.titleLab.text = musicModel.src_name;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
//    NSLog(@"set cell %d Selected: %d", indexPath.row, selected);
    
//    self.selected = !selected;
    if (selected) {
        _titleLab.textColor =IS_SYSTEM_COLOR;
        [_actionBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
     
    }
    else {
        [_actionBtn setImage:[UIImage imageNamed:@"icon_stop"] forState:UIControlStateNormal];
        _titleLab.textColor =[UIColor lightGrayColor];

       
    }
}



@end
