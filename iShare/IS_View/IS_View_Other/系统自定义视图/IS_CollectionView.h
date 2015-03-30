#import <UIKit/UIKit.h>
#import "UIView+JJ.h"
#import "IS_ActionSheet.h"
@protocol IS_CollectionViewDelegate <NSObject>
/**
 *  点击活动后动作
 */
-(void)IS_CollectionViewDidSelectItem:(id)result;

@end

/**
 *  滑动状态控制
 */
typedef void(^IS_CollectionViewScrollStateAction)(id result);
@interface IS_CollectionView : IS_ActionSheet<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  数据源
 */
@property (strong,nonatomic)UICollectionView * collectionView;
@property (strong,nonatomic)UICollectionViewFlowLayout *commonLayout;
@property (strong,nonatomic)NSMutableArray * c_datasource;
@property (weak,nonatomic)id<IS_CollectionViewDelegate>c_Delegate;
@property (copy,nonatomic)IS_CollectionViewScrollStateAction scrollStateAction;
- (void)setupScrollStateAction:(IS_CollectionViewScrollStateAction)scrollStateAction;

/*!
 *  初始化CollectionView
 */
-(void)setupCollectionView;
/**
 *  缓存策略
 *
 *  @param className 类名字
 *  @param isNib     是否来自NIB
 *  @param isHeade   是否是头部
 */
- (void)setupCollectionViewRegisterClass:(NSString *)className
                                   isNib:(BOOL)isNib
                                isHeader:(BOOL)isHeade;
@end
