//
//  UIColor+JJ.h
//  iShare
//
//  Created by 伍松和 on 15/3/5.
//  Copyright (c) 2015年 iShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JJ)
/**
 *  输出 UIColor对象
 *
 *  @param inColorString HexRGB:@"868686"
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
@end
