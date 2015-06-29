#import <UIKit/UIKit.h>
#import "IS_EditGirdCollectionView.h"
@protocol IS_SenceGirdControllerDelegate <NSObject>

-(void)IS_SenceGirdControllerDidUpdate:(id)itemData;

@end

@interface IS_SenceGirdController : UIViewController

@property (weak ,nonatomic)id<IS_SenceGirdControllerDelegate>delegate;
/**
 *  上一个控制器的数据源
 */
@property (strong,nonatomic) NSMutableArray * sence_array;
/**
 *  视图
 */
@property (strong,nonatomic)IS_EditGirdCollectionView * collectionView;


@property (strong,nonatomic)UIImageView* backgroundImageView;

@end
