//
//  IS_WebDetailView.m
//  iShare
//
//  Created by wusonghe on 15/3/25.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_WebDetailView.h"
@interface IS_WebDetailView()

@property (strong,nonatomic)UIView * coverView;
//@property (strong,nonatomic)
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *readNumLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end

@implementation IS_WebDetailView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    _imgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imgBtn.layer.cornerRadius = _imgBtn.width/2;
    _imgBtn.layer.masksToBounds = YES;
//    _imgBtn.layer.co
}
#pragma mark - 数据
-(void)setCaseModel:(IS_CaseModel *)caseModel{
    
    _caseModel = caseModel;
    //1.
    _titleLab.text = caseModel.title;
    //2.
    _detailLab.text = caseModel.detailTitle;
    
    //3.
    _timeLab.text = caseModel.cre_time;
    //4.
    _readNumLab.text = caseModel.uv;
    
    //5.
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:caseModel.share_img] options:SDWebImageDownloaderContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        CGRect newRect = CGRectMake(0, 0, _imgBtn.width, _imgBtn.width);
//        UIImage *newImage = [UIImage circularScaleAndCropImage:image frame:newRect];
////        [UIImage 
        [_imgBtn setImage:image forState:UIControlStateNormal];
    }];
}
- (IBAction)backBtnAction:(id)sender {
    [self.delegate IS_WebDetailViewDidBackAction:sender];
}
@end
