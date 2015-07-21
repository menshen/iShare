typedef NS_ENUM(NSInteger, IS_CaseCollectionType) {
    
    IS_CaseCollectionTypeHome,
    IS_CaseCollectionTypeMineShare,
};
typedef NS_ENUM(NSInteger, IS_CaseStatusType) {

    IS_CaseStatusTypeNone=2,
    IS_CaseStatusTypeEditing=1
};
typedef NS_ENUM(NSInteger, IS_CasePrivateType) {
    
    IS_CasePrivateTypePublic=0,
    IS_CasePrivateTypePrivate=-1,
};

#import "IS_BaseModel.h"
#define HOT_KEY @"hot"

@interface IS_CaseModel : IS_BaseModel
/**
 *  @brief  标题
 */
@property (copy,nonatomic)NSString * title;
/*!
 *  描述
 */
@property (copy,nonatomic)NSString * detailTitle;

/**
 *  @brief  案例URL
 */
@property (copy,nonatomic)NSString * url;
/**
 *  @brief  案例ID
 */
@property (copy,nonatomic)NSString * enterid;
/**
 *  @brief  阅读量UV
 */
@property (copy,nonatomic)NSString * read_count;
/**
 *  @brief  用户量
 */
@property (copy,nonatomic)NSString * uv;
/**
 *  @brief  分享IMG_URL
 */
@property (copy,nonatomic)NSString * share_img;

/**
 *  @brief  临时图片
 */
@property (copy,nonatomic)NSString * img;

/**
 *  @brief  评论
 */
@property (strong,nonatomic)NSString * comment;
/**
 *  @brief  创建时间
 */
@property (copy,nonatomic)NSString * cre_time;
/*!
 *  类型
 */
@property (copy,nonatomic)NSString * activity_name;

/**
 *  @brief  音乐
 */
@property (strong,nonatomic)NSString * musicURl;
/**
 * 场景加+模板数组
 */
@property (nonatomic,strong)NSMutableArray  * templateArray;
/**
 *  @brief  状态
 */
@property (assign,nonatomic)IS_CaseStatusType  status;
/**
 *  @brief  案例类型 0.其他人的 1.自己的
 */
@property (assign,nonatomic)IS_CaseCollectionType caseType;

@property (assign,nonatomic)IS_CasePrivateType  hot;

@property (strong,nonatomic)NSString * nickname;

@property (strong,nonatomic)NSString * headimgurl;




@end
