#import <UIKit/UIKit.h>
#import "IS_EditContentView.h"
#import "IS_SenceTemplateModel.h"
#import "UITableViewCell+JJ.h"


@protocol IS_SceneEditCellDelegate <NSObject>

/*!
 *  按了删除按钮
 */
- (void)IS_SceneEditCellDidDeleteAction:(id)result;

@end

#define IS_SceneEditCell_ID @"IS_SceneEditCell"
@interface IS_SceneEditCell : UICollectionViewCell

/**
 *  模板编辑视图的模板模型
 */
@property (nonatomic,strong)IS_SenceTemplateModel * senceTemplateModel;
@property (weak,nonatomic)id<IS_SceneEditCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet IS_EditContentView * senceCreateEditView;
@property (strong, nonatomic)UIButton * close_btn;

@end
