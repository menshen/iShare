
/**
 *  把握整个场景
    1.保存整个场景数据: A.A1=B1+B2+B3+C1
    2.保存用过的图片数组
    3.
 */

#import "IS_BaseModel.h"

@interface IS_SceneModel : IS_BaseModel

@property (copy,nonatomic)NSString * enterid;
/*!
 *  整个H5的URL
 */
@property (copy,nonatomic)NSString * sceneURL;
/*!
 *  标题
 */
@property (copy,nonatomic)NSString * shareTxt;
/*!
 *  描述
 */
@property (copy,nonatomic)NSString * shareDetailTxt;
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
@property (copy,nonatomic)NSString * shareImg;

/*!
 *  类型
 */
@property (copy,nonatomic)NSString * activity_name;
/**
 * 场景加+模板数组
 */
@property (nonatomic,strong)NSMutableArray  * templateArray;
/**
 *  图片数组
 */
@property (nonatomic,strong)NSMutableArray * imgArray;



@end
