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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
//    NSLog(@"set cell %d Selected: %d", indexPath.row, selected);
    if (selected) {
        _titleLab.textColor =IS_SYSTEM_COLOR;
     
    }
    else {
        _titleLab.textColor =[UIColor lightGrayColor];

       
    }
}



@end
