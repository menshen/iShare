
#import <UIKit/UIKit.h>
//布局
#import "IS_CardLayout.h"
#import "IS_EditSetLayout.h"
@protocol IS_CardCollectionViewDelegate <NSObject>

@optional

/**
 *  当点击图像事件后
 */
- (void)IS_CardCollectionViewDidSelectImageViewItem:(id)itemData
                                        userinfo:(NSDictionary*)userinfo;
/**
 *  每个拖动结束
 */
- (void)IS_CardCollectionViewDidEndDecelerating:(id)itemData
                                    userinfo:(NSDictionary*)userinfo;


@end

@interface IS_EditCardCollectionView : UICollectionView<UIGestureRecognizerDelegate>


@property (nonatomic,weak)id<IS_CardCollectionViewDelegate>collection_delegate;

/**
 *  场景数组
 */
@property (nonatomic,strong)NSMutableArray * senceDataSource;
/**
 *  当前单元格位置
 */
@property (nonatomic,strong)NSIndexPath * currentIndexPath;


#pragma mark - 默认

-(void)addDefaultWithSenceType:(NSInteger)SenceType
                    SubSenceType:(NSInteger)SubSenceType
                     ExistData:(NSMutableArray *)arrayM;


#pragma mark - 响应模板点击->保存图片->换模板
- (void)collectionToChangeTemplate:(id)template_obj;
#pragma mark - 批量增加图片
- (void)insertAssetIntoEditView:(NSMutableArray*)image_array
              WithAssetURLArray:(NSMutableArray*)assetUrlArray;
#pragma mark - 数据的增删改查
-(void)addItem;


@end
