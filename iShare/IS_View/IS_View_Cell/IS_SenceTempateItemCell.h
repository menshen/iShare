

#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"
#import "IS_SenceTemplatePanModel.h"

@interface IS_SenceTempateItemCell : UITableViewCell
///模板数据
@property (nonatomic,strong)IS_SenceTemplatePanModel * senceTemplatePanModel;
@property (weak, nonatomic) IBOutlet UIImageView *sence_image_view;
@property (weak, nonatomic) IBOutlet UILabel *sence_title_lab;
@end
