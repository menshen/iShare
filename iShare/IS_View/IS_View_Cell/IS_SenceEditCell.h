#import <UIKit/UIKit.h>
#import "IS_SenceCreateEditView.h"
#import "IS_SenceTemplateModel.h"
#import "UITableViewCell+JJ.h"



#define IS_SENCE_EDIT_CELL_ID @"IS_SenceEditCell_ID"
@interface IS_SenceEditCell : UICollectionViewCell

/**
 *  模板编辑视图的模板模型
 */
@property (nonatomic,strong)IS_SenceTemplateModel * senceTemplateModel;
@property (strong, nonatomic) IBOutlet IS_SenceCreateEditView * senceCreateEditView;
@property (strong, nonatomic)UIButton * close_btn;

@end
