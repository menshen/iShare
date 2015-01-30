#import <UIKit/UIKit.h>
#import "IS_SenceTemplateModel.h"
#import "IS_SenceTemplatePanModel.h"
#import "EBCardCollectionViewLayout.h"
#import "IS_SenceEditTool.h"



@interface IS_SenceCreateView : UIView
/**
 *  整体滚动视图
 */
@property (nonatomic,strong)UICollectionView *senceCollectioneEditView;

/**
 *  场景数组
 */
@property (nonatomic,strong)NSMutableArray * senceTemplateArray;

/**
 *  当前编辑中的模型
 */

@property (nonatomic,strong)IS_SenceTemplateModel * currentSenceTemplateModel;

/**
 *  当前单元格位置
 */
@property (nonatomic,strong)NSIndexPath * currentIndexPath;

@end
