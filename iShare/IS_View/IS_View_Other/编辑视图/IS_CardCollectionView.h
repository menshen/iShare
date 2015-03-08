
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

/**
 *  捏合事件之后
 *
 */
- (void)IS_CardCollectionViewDidEndPinch:(id)itemData;

@end

@interface IS_CardCollectionView : UICollectionView<UIGestureRecognizerDelegate>


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

-(void)addDefaultSenceTemplateData:(NSMutableArray *)arrayM;


#pragma mark - 响应模板点击->保存图片->换模板

- (void)templateToCollectionView:(id)template_obj;
#pragma mark - 批量增加图片
- (void)insertAssetIntoEditView:(NSMutableArray*)image_array
              WithAssetURLArray:(NSMutableArray*)assetUrlArray;
#pragma mark - 点击缩略图时候，增加图片到编辑视图
-(void)insertAssetIntoEditViewDidthumbnailImageAction:(id)itemData
                                             userInfo:(NSDictionary*)userInfo;

@end
