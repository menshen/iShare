#import <UIKit/UIKit.h>
#import "IS_CaseModel.h"



@interface IS_CaseCollectionCell : UICollectionViewCell




@property (strong,nonatomic)IS_CaseModel * caseModel;
@property (copy,nonatomic)CompleteResultBlock completeResultBlock;
- (void)addActionCompleteResultBlock:(CompleteResultBlock)completeResultBlock;
@end
