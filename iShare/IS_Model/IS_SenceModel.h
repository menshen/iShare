
/**
 *  把握整个场景
    1.保存整个场景数据: A.A1=B1+B2+B3+C1
    2.保存用过的图片数组
    3.
 */

#import "IS_BaseModel.h"

@interface IS_SenceModel : IS_BaseModel


/*!
 *  标题
 */
@property (copy,nonatomic)NSString * title;
/*!
 *  描述
 */
@property (copy,nonatomic)NSString * detailTitle;
/*!
 *  时间
 */
@property (copy,nonatomic)NSString * timeTitle;
/*!
 *  阅读量/UV
 */
@property (copy,nonatomic)NSString * readNum;
/*!
 *  头像URL
 */
@property (copy,nonatomic)NSString * headUrl;
/**
 * 场景加+模板数组
 */
@property (nonatomic,strong)NSMutableArray  * templateArray;
/**
 *  图片数组
 */
@property (nonatomic,strong)NSMutableArray * imgArray;



@end
