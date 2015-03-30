//
//  IS_PopView.m
//  iShare
//
//  Created by 伍松和 on 15/3/16.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_PopView.h"
#import "IS_EditActionView.h"
@implementation IS_PopView


-(id)initWithCustomView:(UIView *)aView{
    
    if (self = [super initWithCustomView:aView]) {
        //
    }
    return self;

}
-(instancetype)initWithAView:(UIView*)aView{
    
    if (!aView) {
        NSString * nibName = NSStringFromClass( [IS_EditActionView class]);
        IS_EditActionView * contentView = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil][0];
        aView=contentView;

    }
    
    self.customView = aView;
    [self addSubview:self.customView];
    return self;
}
@end
