//
//  IS_SenceEditCell.m
//  iShare
//
//  Created by 伍松和 on 15/1/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceEditCell.h"

@interface IS_SenceEditCell()


@end

@implementation IS_SenceEditCell
#pragma mark - 数据
-(void)setSenceTemplateModel:(IS_SenceTemplateModel *)senceTemplateModel{

    _senceTemplateModel = senceTemplateModel;
    
    //1,大视图 ,小视图
    CGRect frame = CGRectZero;
    if (self.senceTemplateModel.senceTemplateShape==IS_SenceTemplateShapeCard) {
        //a.尺寸

        frame  = CGRectMake(40, 0, IS_CARD_ITEM_WIDTH, IS_CARD_ITEM_HEIGHT);
        //b,
        self.close_btn.hidden=YES;
    }else{
//
        frame = CGRectMake(0, 0, IS_CARD_LITTER_ITEM_WIDTH, IS_CARD_LITTER_ITEM_HEIGHT);
        
        //b
        self.close_btn.hidden=NO;
    }
    self.senceCreateEditView.frame =frame;
    self.senceCreateEditView.layer.borderWidth=0.1;
    self.senceCreateEditView.layer.borderColor=[UIColor lightGrayColor].CGColor;


    //2.
    if (senceTemplateModel.type!=0) {
        self.senceCreateEditView.backgroundColor = [UIColor whiteColor];
        self.senceCreateEditView.senceTemplateModel=senceTemplateModel;
    }else{
        self.senceCreateEditView.backgroundColor = [UIColor whiteColor];
        self.senceCreateEditView.senceTemplateModel=nil;

    }    
    
    

}
#pragma mark - 子视图

-(IS_SenceCreateEditView *)senceCreateEditView{
    
    if (!_senceCreateEditView) {
      
        _senceCreateEditView = [[IS_SenceCreateEditView alloc]initWithFrame:CGRectZero];
        _senceCreateEditView.backgroundColor = [UIColor clearColor];

    }
    return _senceCreateEditView;

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //0
        [self addSubview:self.senceCreateEditView];
        
        
        //2.加一个 「X」
        [self addSubview:self.close_btn];
        
        
    }
    return self;

}
#pragma mark - 开始抖动
-(UIButton *)close_btn{
    
    if (!_close_btn) {
        _close_btn = [[UIButton alloc]initWithFrame:CGRectMake(-5, -10, 20, 20)];
        [_close_btn setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    }

    return _close_btn;
}


@end
