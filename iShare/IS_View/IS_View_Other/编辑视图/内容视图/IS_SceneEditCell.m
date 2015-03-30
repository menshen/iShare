//
//  IS_SenceEditCell.m
//  iShare
//
//  Created by 伍松和 on 15/1/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SceneEditCell.h"

@interface IS_SceneEditCell()


@end

@implementation IS_SceneEditCell
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

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //0
        [self setupEditView];
        [self setupCloseBtn];
        
    }
    return self;

}
#pragma mark - 主要编辑视图
- (void)setupEditView{

    _senceCreateEditView = [[IS_EditContentView alloc]initWithFrame:CGRectZero];
    _senceCreateEditView.backgroundColor = [UIColor clearColor];
    [self addSubview:_senceCreateEditView];

}
#pragma mark - 删除按钮
- (void)setupCloseBtn{
    
    _close_btn = [[UIButton alloc]initWithFrame:CGRectMake(-5, -10, 20, 20)];
    [_close_btn setBackgroundImage:[UIImage imageNamed:@"IS_Edit_Close"] forState:UIControlStateNormal];
    [_close_btn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_close_btn];

}
- (void)closeBtnAction:(UIButton *)sender{
    
    [self.delegate IS_SceneEditCellDidDeleteAction:self];

}



@end
