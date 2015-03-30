

#import <UIKit/UIKit.h>
#import "UITableViewCell+JJ.h"
#import "IS_SenceTemplatePanModel.h"
#import "IS_CollectionViewCell.h"
#define IS_TempateCollectionCell_ID @"IS_TempateCollectionCell"
@interface IS_TempateCollectionCell : IS_CollectionViewCell
///模板数据
@property (nonatomic,strong)IS_SenceTemplatePanModel * senceTemplatePanModel;
@end
