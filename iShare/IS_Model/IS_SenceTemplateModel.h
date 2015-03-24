
#define T_TYPE_KEY            @"type"    //标注模板当前状态
#define T_SUB_TYPE_KEY        @"sub_type"//下一页状态
#define T_CONTENT_KEY         @"content"
#define T_AID                 @"a_id"
#define T_MODULE_KEY          @"modules"

#define T_PEOPLE_TYPE_WEDDING @"wedding"
#define T_PEOPLE_TYPE_LOVERS  @"lovers"
#define T_PEOPLE_TYPE_PETS    @"pets"
#define T_PEOPLE_TYPE_PARENTS @"parents"
#define T_PEOPLE_TYPE_BESTIE  @"bestie"

typedef NS_ENUM(NSInteger, IS_SenceTemplateShape) {
    IS_SenceTemplateShapeCard,
    IS_SenceTemplateShapeGird,
    
};
#import "IS_BaseModel.h"
#import "NSObject+DBCatefgory.h"
#import "IS_SenceSubTemplateModel.h"

@interface IS_SenceTemplateModel : IS_BaseModel

@property (nonatomic,assign) IS_SenceTemplateShape       senceTemplateShape;
/**
 *  第几个
 */
@property (nonatomic,assign) NSInteger                   row_num;

/**
    是否场景
 */
@property (nonatomic,assign) BOOL                        is_sence;
/**
    ID
 */
@property (nonatomic,assign) NSInteger                   sence_Id;
/**
 *  模板风格
 */
@property (nonatomic,assign) NSInteger                   type;
/**
 *  子模板编号
 */
@property (nonatomic,assign) NSInteger                   sub_type;
/**
 *  模板子视图模型数组
 */
@property (nonatomic,strong) NSMutableArray              * subview_array;
/**
 *  模板图片数组
 */
@property (nonatomic,strong) NSMutableArray              * img_array;
/**
 *  模板图片数组
 */
@property (nonatomic,assign) NSInteger                   img_count;
/**
 *  模板文字数组
 */
@property (nonatomic,assign) NSInteger                   text_count;
/**
 *  当前被选中的图片
 */
@property (nonatomic,assign) NSInteger                   selected_tag;





@end
