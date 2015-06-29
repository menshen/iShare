#import "IS_BaseModel.h"
#import "IS_ImageModel.h"



#define EN_FONT @"Raleway-Thin"
//#define ZN_FONT @"SourceHanSansCN-ExtraLight"

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
/**
 *  @brief  视图ID
 */
@property (strong,nonatomic)NSString                   *view_id;



#pragma mark -图片数据

@property (strong,nonatomic)IS_ImageModel * imageModel;

/**
 *   对应视图的frame
 */
@property (nonatomic,copy  ) NSString                 * img_frame;

//
///**
// *  占位符图片
// */
//@property (nonatomic,copy  ) NSString                 * img_place_name;
///*
//*  mask图片
//*/
@property (nonatomic,copy  ) NSString                 * img_mask_name;
///**
// *  占位符图片
// */
//@property (nonatomic,copy  ) NSString                 * img_place_url;



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
 *  @brief  是否可以编辑
 */

@property (assign,nonatomic)BOOL                    isTextEdit;

@property (copy,nonatomic)NSString                  * text_action;


/**
 *  属于第几页模板
 */
@property (nonatomic,assign) NSInteger                page;




/**
 *  通过模板风格来构建N个子视图图
 */
+ (NSMutableArray *)configureSubTemplateModelWithAID:(NSString*)aid
                                                page:(NSInteger)page
                                             isSence:(BOOL)isSence;
@end
