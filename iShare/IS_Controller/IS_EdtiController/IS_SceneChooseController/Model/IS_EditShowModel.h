
#import "IS_BaseModel.h"
typedef NS_ENUM(NSUInteger, IS_EditTemplateStyle) {
    IS_EditTemplateStyleScene,
    IS_EditTemplateStyleNoWord,
    IS_EditTemplateStyleLessWord,
    IS_EditTemplateStyleMutilWord,
    IS_EditTemplateStyleDownloaded
};
typedef NS_ENUM(NSInteger, IS_EditShowLoadingState) {
    IS_EditShowLoadingStateNone,
    IS_EditShowLoadingStateDoing,
    IS_EditShowLoadingStateDone,
};
@interface IS_EditShowModel : IS_BaseModel
#define MORE_CLASS_KEY @"more_class"
#define A_CLASS_KEY @"a_class"

/**
 ID
 */
@property (nonatomic,copy) NSString                      *a_id;

@property (copy,nonatomic)NSString                       * more_class;

/**
 *  @brief  类型
 */
@property (nonatomic,copy) NSString                      *a_class;

/**
 *  @brief  描述
 */
@property (nonatomic,copy) NSString                      *words;





@property (assign,nonatomic)BOOL                        showSelected;

@property (assign,nonatomic)IS_EditShowLoadingState     loadingState;

@property (assign,nonatomic)IS_EditTemplateStyle        editTemplateStyle;

-(BOOL)isExist;

- (NSString *)getPicFamilyName;


- (NSString *)getPlaceImgaeName;


@end
