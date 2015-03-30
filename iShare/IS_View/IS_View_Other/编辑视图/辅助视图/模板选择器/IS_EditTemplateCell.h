

#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"
#import "IS_EditTemplateSelectModel.h"
#import "IS_CollectionViewCell.h"
#define IS_EditTemplateCell_ID @"IS_EditTemplateCell"
@interface IS_EditTemplateCell : IS_CollectionViewCell
///模板数据
@property (nonatomic,strong)IS_EditTemplateSelectModel * templatePanModel;
@end
