#import "IS_BaseModel.h"
#define UPLOAD_IMAGE     @"UPLOAD_IMAGE"
#define SUB_VIEW_INFO    @"view_info"
#define FRAME_KEY        @"frame"
#define POINT_KEY        @"point"
#define HEIGHT_KEY       @"h"
#define WIDTH_KEY        @"w"
#define X_KEY            @"x"
#define Y_KEY            @"y"

#define IMAGE_URL_KEY    @"img_url"
#define IMAGE_INFO_KEY   @"img_info"
#define TEXT_KEY         @"text"
#define TEXT_INFO_KEY    @"text_info"
#define TRANSLATE_KEY    @"translate"
#define SCALE_KEY        @"scale"
#define ROTATION_KEY     @"rotation"


#define TYPE_KEY         @"type"
#define PLACE_IMAGE_NAME @"place_image"
#define PLACE_TEXT       @"place_text"
typedef NS_ENUM(NSInteger, IS_SubType) {
    
    IS_SubTypeImage, //图片
    IS_SubTypeText, //文字
    IS_SubTypeDecorate,//装饰
    
};
typedef NS_ENUM(NSInteger, IS_ShapeType) {
    
    IS_ShapeTypeLarge, // 大
    IS_ShapeTypeMiddle, //中
    IS_ShapeTypeSmall, //小
    
};
typedef NS_ENUM(NSInteger, IS_ImageUploadState) {

    IS_ImageUploadStateNone,
    IS_ImageUploadStateBegin,
    IS_ImageUploadStateing,
    IS_ImageUploadStateDone,
    IS_ImageUploadStateFailure
};
/**
 *  这是子模板中的数据:
    1.包括图片
    2.文字
 */
@interface IS_EditSubTemplateModel : IS_BaseModel


@property (nonatomic,assign) IS_ShapeType             shapeType;
/**
 *  类型
 */
@property (nonatomic,assign) IS_SubType               sub_type;
/**
 *  图片的尺寸
 */
@property (nonatomic,copy  ) NSString                 * sub_frame;
/**
 *  贝塞尔曲线
 */
@property (nonatomic,strong) UIBezierPath             * sub_bezierPath;
/**
 *   对应视图的tag
 */
@property (nonatomic,assign) NSInteger                sub_tag;



#pragma mark -图片数据
/**
 *   对应视图的frame
 */
@property (nonatomic,copy  ) NSString                 * img_frame;
/**
 *  图片数据
 */
@property (nonatomic,strong) UIImage                  * img;
/**
 *  图片数据路径,本地或者网络上的
 */
@property (nonatomic,copy  ) NSString                 * img_asset;
/**
 *  图片上传 URL
 */
@property (nonatomic,copy  ) NSString                 * img_url;
/**
 *   相片信息
 */
@property (nonatomic,strong) NSMutableDictionary      * img_info;


/**
 *  占位符图片
 */
@property (nonatomic,copy  ) NSString                 * img_place_name;

/**
 *  上传状态
 */
@property (nonatomic,assign) IS_ImageUploadState      img_upload_state;

#pragma mark -文字数据
/**
 *  占位文字
 */
@property (nonatomic,copy  ) NSString                 * text_place_string;
/**
 *  文字数据
 */
@property (nonatomic,copy  ) NSString                 * text;
/**
 *  文字信息： 1.字体等等
 */
@property (nonatomic,strong) NSDictionary             * text_info;


/**
 *  属于第几页模板
 */
@property (nonatomic,assign) NSInteger                page;




/**
 *  通过模板风格来构建N个子视图图
 */
+ (NSMutableArray *)configureSubTemplateModelIndex:(NSInteger)index
                                          subIndex:(NSInteger)subIndex
                                              page:(NSInteger)page
                                           isSence:(BOOL)isSence;
@end
