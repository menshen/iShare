
#define TEMPLATE_STATE @"TEMPLATE_STATE" //标注模板当前状态
#define TEMPLATE_NEXT_PAGE @"TEMPLATE_NEXT_PAGE" //下一页状态
#define TEMPLATE_CURRENT_PAGE @"TEMPLATE_CURRENT_PAGE" //下一页状态





typedef NS_ENUM(NSInteger, IS_SenceTemplateShape) {
    IS_SenceTemplateShapeCard,
    IS_SenceTemplateShapeGird,
    
};
#import "IS_BaseModel.h"
#import "NSObject+DBCatefgory.h"
#import "IS_SenceSubTemplateModel.h"

@interface IS_SenceTemplateModel : IS_BaseModel
@property (nonatomic,assign)IS_SenceTemplateShape senceTemplateShape;

/**
 *  对应的略缩图
 */
@property (nonatomic,strong)NSString * s_img_name;
/**
    ID
 */
@property (nonatomic,assign)NSInteger s_Id;
/**
 *  模板风格
 */
@property (nonatomic,assign)NSInteger s_template_style;
/**
 *  子模板编号
 */
@property (nonatomic,assign)NSInteger s_sub_template_style;
/**
 *  模板子视图模型数组
 */
@property (nonatomic,strong)NSMutableArray * s_sub_view_array;
/**
 *  模板图片数组
 */
@property (nonatomic,assign)NSInteger img_count;
/**
 *  模板文字数组
 */
@property (nonatomic,assign)NSInteger text_count;
/**
 *  当前被选中的图片
 */
@property (nonatomic,assign)NSInteger s_selected_tag;



/**
 *  编辑状态 0.开始(直接插模板) 1.编辑中 2.编辑结束
 */
//@property (nonatomic,assign)IS_SenceTemplateEditState templateEditState;




@end
