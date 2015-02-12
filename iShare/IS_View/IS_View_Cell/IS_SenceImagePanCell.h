

#import <UIKit/UIKit.h>
#import "IS_SenceSubTemplateModel.h"

@interface IS_SenceImagePanCell : UITableViewCell

@property (nonatomic,strong)IS_SenceSubTemplateModel * senceImageModel;

@property (weak, nonatomic) IBOutlet UIButton *sence_close_btn;

/**
 *  图片视图
 */
@property (weak, nonatomic) IBOutlet UIButton *sencn_image_btn_view;
/**
 *  如果被选择了3次就,'...' 一次就 '.'
 */
@property (weak, nonatomic) IBOutlet UILabel *sence_image_selected_num_lab;
@end
