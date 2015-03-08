

#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"
#import "IS_SenceTemplatePanModel.h"
#define IS_TempateCollectionCell_ID @"IS_TempateCollectionCell"
@interface IS_TempateCollectionCell : UICollectionViewCell
///模板数据
@property (nonatomic,strong)IS_SenceTemplatePanModel * senceTemplatePanModel;
@property (weak, nonatomic) IBOutlet UIImageView *sence_image_view;
@end
