
#import "SH_PageViewController.h"
#import "IS_EditShowModel.h"
typedef void(^DidDismissBlock)(id result);
typedef void(^DidSelectBlock)(id result);
@interface IS_EditChoosePageController : SH_PageViewController
@property (copy,nonatomic)DidDismissBlock didDismissBlock;
@property (copy,nonatomic)DidSelectBlock  didSelectBlock;
@property (strong,nonatomic)IS_EditShowModel * editShowModel;


- (instancetype)initWithDidSelectBlock:(DidSelectBlock)didSelectBlock
                          DismissBlock:(DidDismissBlock)didDismissBlock;

@end
