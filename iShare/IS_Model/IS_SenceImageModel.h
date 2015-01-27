#import "IS_BaseModel.h"
@interface IS_SenceImageModel : IS_BaseModel
/**
 *  图片数据路径
 */
@property (nonatomic,strong)NSString * image_path;
/**
 *  图片被选次数
 */
@property (nonatomic,assign)NSInteger image_selected_num;
/**
 *  图片数据
 */
@property (nonatomic,strong) UIImage * imageData;

@end
