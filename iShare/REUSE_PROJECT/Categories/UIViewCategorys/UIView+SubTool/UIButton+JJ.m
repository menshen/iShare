//
//  UIButton+JJ.m
//  易商
//
//  Created by 伍松和 on 14/10/29.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import "UIButton+JJ.h"
@implementation UIButton (JJ)

- (void)setBtnSelecteAction{

    //2.
    if (self.selected) {
        self.layer.borderWidth = 5;
        self.layer.borderColor = [[UIColor redColor]CGColor];

        
    }else{
        self.layer.borderWidth = 0;
        self.layer.borderColor = [[UIColor clearColor]CGColor];
    }

}

#pragma mark -动作

//-(void)setBT{
//    
//    [self associateValue:warningView withKey:&kWarningViewKey];
//    
//}
//-(UIView *)warningView{
//    
//    return [self associatedValueForKey:&kWarningViewKey];
//}

@end
