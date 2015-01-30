
/**
 *  把握整个场景
    1.保存整个场景数据: A.A1=B1+B2+B3+C1
    2.保存用过的图片
 */

#import "IS_BaseModel.h"

@interface IS_SenceModel : IS_BaseModel
@property (nonatomic,strong)NSString * i_image;
@property (nonatomic,strong)NSString * i_name;
@property (nonatomic,strong)NSString * i_title;
@property (nonatomic,strong)NSString * i_detail;
@property (nonatomic,strong)NSString *  i_url;
@end
