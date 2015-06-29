
#import "SH_PageViewController.h"
typedef void(^DidDismissBlock)(id result);
typedef void(^DidSelectBlock)(id result);
@interface IS_EditChoosePageController : SH_PageViewController
@property (copy,nonatomic)DidDismissBlock didDismissBlock;
@property (copy,nonatomic)DidSelectBlock  didSelectBlock;

- (void)addActionWithDismissBlock:(DidDismissBlock)didDismissBlock
                   DidSelectBlock:(DidSelectBlock)didSelectBlock;

- (void)showCollectionViewControllerSheetWithDismissBlock:(DidDismissBlock)didDismissBlock
                                           DidSelectBlock:(DidSelectBlock)didSelectBlock;

@end
