//
//  IS_Button.m
//  iShare
//
//  Created by 伍松和 on 15/3/19.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import "IS_Button.h"

@implementation IS_Button

-(instancetype)initWithFrame:(CGRect)frame
          ButtonPositionType:(ButtonPositionType)type{
    
    if (self=[super initWithFrame:frame]) {
        
        self.buttonPosition=type;
        
    }
    return self;
}
#pragma mark -动作
- (void)layoutSubviews
{
    
    
    [super layoutSubviews];
   
    switch (self.buttonPosition) {
        case ButtonPositionTypeNone:{
            [self buttonPositionTypeTitleLeft];
            break;
        }
        case ButtonPositionTypeBothCenter:
        {
            [self buttonPositionTypeBothCenter];
            break;
        }
            
        case ButtonPositionTypeTitleLeft:
        {
            [self buttonPositionTypeTitleLeft];
            break;
        }
            
            
        default:
            //
            break;
    }
    
}
-(void)buttonPositionTypeBothCenter{
    //0.image
    self.imageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-3);
 

    
    //1.title
    CGRect frame = [self titleLabel].frame;
    frame.origin.x = 0;
    frame.origin.y = self.imageView.bottom + 3;
    frame.size.width = self.frame.size.width;
    self.titleLabel.frame = frame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
}
-(void)buttonPositionTypeTitleLeft{
    
    self.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -8);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
}
@end
