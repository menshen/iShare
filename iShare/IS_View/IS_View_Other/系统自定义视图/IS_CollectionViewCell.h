
#import <UIKit/UIKit.h>

@interface IS_CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *imgView;
@property (strong, nonatomic)  UILabel *titleLab;
- (void)setupImgView;
- (void)setupTitleLab;

@end
