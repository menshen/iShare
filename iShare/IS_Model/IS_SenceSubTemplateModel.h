#import "IS_BaseModel.h"
#define UPLOAD_IMAGE @"UPLOAD_IMAGE"
#define SUB_VIEW_INFO @"view_info"
#define FRAME_KEY @"frame"
#define HEIGHT_KEY @"h"
#define WIDTH_KEY @"w"
#define X_KEY @"x"
#define Y_KEY @"y"

#define TYPE_KEY @"type"
#define PLACE_IMAGE_NAME @"place_image"
#define PLACE_TEXT      @"place_text"
typedef NS_ENUM(NSInteger, IS_SenceSubTemplateType) {
    
    IS_SenceSubTemplateTypeImage, //图片
    IS_SenceSubTemplateTypeDecorate, //装饰
    IS_SenceSubTemplateTypeText, //文字
    
};
/**
 *  这是子模板中的数据:
    1.包括图片
    2.文字
 */
@interface IS_SenceSubTemplateModel : IS_BaseModel
/**
 *  类型
 */
@property (nonatomic,assign)IS_SenceSubTemplateType  sub_type;
/**
 *  图片的尺寸
 */
@property (nonatomic,copy)NSString * sub_frame;
/**
 *   对应视图的tag
 */
@property (nonatomic,assign)NSInteger  sub_tag;
/**
 *   对应视图的tag
 */
@property (nonatomic,copy)NSString * sub_image_frame;
/**
 *   对应视图的偏移
 */
@property (nonatomic,copy)NSString * sub_image_offset;

#pragma mark -图片数据
/**
 *  图片被选次数
 */
@property (nonatomic,assign)NSInteger image_selected_num;
/**
 *  图片数据
 */
@property (nonatomic,strong)UIImage * image_data;
/**
 *  图片数据路径,本地或者网络上的
 */
@property (nonatomic,copy)NSString * image_url;
/**
 *  占位符图片
 */
@property (nonatomic,copy)NSString * image_place_name;
/**
 *  是否被编辑过
 */
@property (nonatomic,assign)BOOL image_edited;
/**
 *  是否正在被选中
 */
@property (nonatomic,assign)BOOL image_selected;

/**
 *  图片使用情况:
        1. 例如 {
     A5:2
     B2:3
     B4:2
     }
     就是代表A5模板用了2次，B2用了3次
        2.一开始的时候,如果已经有数据编辑状态,就导入
        3.如果完全是新的就是空
 */
@property (nonatomic,strong)NSDictionary  * image_use_info;


#pragma mark -文字数据

/**
 *  文字数据
 */
@property (nonatomic,copy)NSString * text_string;

/**
 *  文字信息： 1.字体等等
 */
@property (nonatomic,strong)NSDictionary * text_info;

/**
 *  通过模板风格来构建N个子视图图
 */
+ (NSMutableArray *)configureSubTemplateModelWithStandardSize:(CGSize)size
                                                        Index:(NSInteger)index
                                                        sub_index:(NSInteger)sub_index;
@end
