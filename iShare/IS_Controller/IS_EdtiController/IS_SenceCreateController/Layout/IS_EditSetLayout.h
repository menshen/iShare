

#define ITEM_BASIC_WIDTH ScreenWidth/3.5
#import <UIKit/UIKit.h>

@interface IS_EditSetLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath   *hiddenIndexPath;
@property (strong, nonatomic) NSIndexPath   *fromIndexPath;
@property (strong, nonatomic) NSIndexPath   *toIndexPath;



@end
