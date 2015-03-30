#import <UIKit/UIKit.h>
#import "IS_EditContentView.h"
#import "IS_EditTemplateModel.h"
#import "UITableViewCell+JJ.h"


@protocol IS_EditCellDelegate <NSObject>
@optional
/*!
 *  按了删除按钮
 */
- (void)IS_EditCellDidDeleteAction:(id)result;
/*!
 *  改变场景
 *
 */
- (void)IS_EditCellDidChangeSceneAction:(id)result;

/*!
 *  点击了某一项
 */
- (void)IS_EditCellDidSelectItemAction:(id)result
                              userinfo:(id)userinfo;

/*!
 *  视图内数据改变
 *
 */
- (void)IS_EditCellDidDataChangeAction:(id)result
                              userinfo:(id)userinfo;

@end

#define IS_EditCardCell_ID @"IS_EditCardCell"
@interface IS_EditCardCell : UICollectionViewCell

/**
 *  模板编辑视图的模板模型
 */
@property (nonatomic,strong)IS_EditTemplateModel * senceTemplateModel;
@property (weak,nonatomic)id<IS_EditCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet IS_EditContentView * senceCreateEditView;
@property (strong, nonatomic)UIButton * close_btn;

@end
