/*
 
    管理当前编辑的事务
     
     1.当前的模板
     2.模板被选中的图片
     3.模板当前图片子视图数量(包括空的)
 
 */

#import <Foundation/Foundation.h>
#import "IS_SenceTemplateModel.h"
@interface IS_SenceEditTool : NSObject

/**
 *  默认添加一系列场景(通常1-2个)
 */
+ (NSMutableArray*)appendSenceDefaultData;





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

@end
