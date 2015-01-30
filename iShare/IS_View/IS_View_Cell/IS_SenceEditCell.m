//
//  IS_SenceEditCell.m
//  iShare
//
//  Created by 伍松和 on 15/1/26.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_SenceEditCell.h"

@implementation IS_SenceEditCell

-(void)setSenceTemplateModel:(IS_SenceTemplateModel *)senceTemplateModel{

    _senceTemplateModel = senceTemplateModel;
    
    if (senceTemplateModel.s_template_style!=0) {
        self.senceCreateEditView.backgroundColor = [UIColor whiteColor];
        self.senceCreateEditView.senceTemplateModel=senceTemplateModel;
    }else{
        self.senceCreateEditView.backgroundColor = [UIColor lightGrayColor];
        self.senceCreateEditView.senceTemplateModel=nil;

    }    
    //1.
//

    

}

-(IS_SenceCreateEditView *)senceCreateEditView{
    
    if (!_senceCreateEditView) {
        _senceCreateEditView = [[IS_SenceCreateEditView alloc]initWithFrame:self.bounds];
        _senceCreateEditView.backgroundColor = [UIColor whiteColor];

    }
    return _senceCreateEditView;

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.senceCreateEditView];
    }
    return self;

}

@end
