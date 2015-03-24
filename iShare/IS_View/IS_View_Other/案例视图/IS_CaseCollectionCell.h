typedef NS_ENUM(NSInteger, IS_CaseCollectionType) {

    IS_CaseCollectionTypeHome,
    IS_CaseCollectionTypeMineShare,
};
#import <UIKit/UIKit.h>

@interface IS_CaseCollectionCell : UICollectionViewCell


@property (assign,nonatomic)IS_CaseCollectionType caseType;

@property (weak, nonatomic) IBOutlet UIButton *imgBtnView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *readNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *editStateIcon;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@end
