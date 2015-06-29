


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
#import "IS_EditSubTemplateModel.h"
#import "IS_EditShowModel.h"
@interface IS_EditTemplateModel : IS_BaseModel

@property (copy,nonatomic)NSString                      * template_id;

/**
 ID
 */
@property (nonatomic,copy) NSString                      *a_id;


@property (copy,nonatomic)NSString                      * words;


@property (nonatomic,copy) NSString                      *a_class;



@property (copy,nonatomic)NSString                          *more_class;


//@property (assign,nonatomic)IS_EditTemplateStyle        editStyle;

/**
    是否场景
 */
@property (nonatomic,assign) BOOL                        isScene;
/**
 *  模板子视图模型数组
 */
@property (nonatomic,strong) NSMutableArray              *subview_array;


/**
 *  模板图片数组
 */
//@property (nonatomic,strong) NSMutableArray              *img_array;

@property (nonatomic,assign) IS_SenceTemplateShape       senceTemplateShape;



- (void)configureRowNum:(NSInteger)row;

- (NSMutableArray *)getImgArray;
-(NSMutableArray *)getImgWithImgDataArray;

@end
