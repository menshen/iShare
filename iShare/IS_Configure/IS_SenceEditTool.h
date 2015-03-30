/*
 
    管理当前编辑的事务
     
     1.当前的模板
     2.模板被选中的图片
     3.模板当前图片子视图数量(包括空的)
 
 */

#import <Foundation/Foundation.h>
#import "IS_EditTemplateModel.h"
#import "IS_CaseModel.h"

typedef void(^SenceModelCompleteBlock)(id results);

@interface IS_SenceEditTool : NSObject



#pragma mark - 把场景出去来
+ (IS_CaseModel *)getSenceModelWithID:(NSString*)sence_id;

#pragma mark - 保存
+ (void)saveSenceModelWithSenceID:(NSString*)senceID
                    TemplateArray:(NSMutableArray*)templateArray
             SubTemplateDataArray:(NSMutableArray*)subTemplateDataArray
                    CompleteBlock:(SenceModelCompleteBlock)CompleteBlock;


+ (UIImage*)getImagesDataFromAssetURLString:(NSString*)urlString;

///**
// *  当前的模板
// *
// *  @return 模板模型
// */
//+ (IS_SenceTemplateModel *)currentSenceTemplateModel:(NSIndexPath*)cur_indexPath;
//
///**
// *  当前选择的图片Button
// *
// *  @return 图片Button
// */
//+ (UIButton*)currentSelectImageButton;

#pragma mark - 根据数组组建贝塞尔曲线(1.普通直线 2.曲线 3.等等)
+ (UIBezierPath *)getBezierPathFromArray:(id)array
                                   WIDTH:(CGFloat)WIDTH
                                  HEIGHT:(CGFloat)HEIGHT
                                    type:(NSInteger)type;

@end
