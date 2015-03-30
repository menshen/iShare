typedef NS_ENUM(NSInteger, IS_CaseCollectionType) {
    
    IS_CaseCollectionTypeHome,
    IS_CaseCollectionTypeMineShare,
};
typedef NS_ENUM(NSInteger, IS_CaseStatusType) {

    IS_CaseStatusTypeEditing,
    IS_CaseStatusTypeDone,
    IS_CaseStatusTypeDel,
};

#import "IS_BaseModel.h"
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
@property (copy,nonatomic)NSString * uv;

/**
 *  @brief  分享IMG_URL
 */
@property (copy,nonatomic)NSString * share_img;
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

@end
