//
//  BZ_DisplayBarCell.m
//  BeautyWall
//
//  Created by 伍松和 on 15/3/17.
//  Copyright (c) 2015年 Wawa. All rights reserved.
//

#import "IS_CaseHotShowCell.h"
@interface IS_CaseHotShowCell()

@end

@implementation IS_CaseHotShowCell

- (void)awakeFromNib {
    // Initialization code
    _bottomImgView.image = [UIImage resizedImage:@"home_icon_bg_img"];
    
}

-(void)setCaseModel:(IS_CaseModel *)caseModel{
    _caseModel = caseModel;
    
    //1.
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:caseModel.share_img] placeholderImage:nil options:SDWebImageLowPriority |SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    //2.
    self.titleLab.text = caseModel.title;
    
    [self.readLab setTitle:caseModel.uv forState:UIControlStateNormal];
}
@end
