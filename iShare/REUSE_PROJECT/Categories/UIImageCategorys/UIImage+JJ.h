//
//  UIImage+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/23.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+XHRounded.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
@interface UIImage (JJ)
/**
 *  可以自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)imgName;
#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

#pragma mark -得到截图
+ (UIImage *)getImageFromCurView:(UIView *)theView;
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;
+(UIImage*)getSubImage:(UIImage*)superImage inFrame:(CGRect)frame;

#pragma mark -缓存
+ (UIImage *)fastImageWithData:(NSData *)data;
+ (UIImage *)fastImageWithContentsOfFile:(NSString *)path;
+(UIImage*) drawText:(NSString*)text
             inImage:(UIImage*)image
             atPoint:(CGPoint)point;
+ (UIImage*)drawTextWithStroke:(NSString*)string;
/**
 *  旋转图片
 *
 */
+(UIImage *)makeImageRotateOriginImage:(UIImage*)src
                    UIImageOrientation:(UIImageOrientation)orientation;

+ (UIImage*)imageWithImageSimple:(UIImage*)image
                           scale:(CGFloat)scale;
#pragma mark  圆角
+ (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame;

/**
 *  旋转图片
 *
 */
+(UIImage *)rotateImage:(UIImage*)src
           angleDegrees:(CGFloat)angleDegrees;


#define SCALE_KEY @"scale"
#define RECT_KEY  @"rect"
/**
 *  @brief  处理滑动视图
 *
 *  @return <#return value description#>
 */
+ (NSDictionary *)dealImageData:(UIImage*)imageData
                    containView:(UIView*)containView;
@end
