
#import <UIKit/UIKit.h>
//布局
#import "IS_CardLayout.h"
#import "IS_EditSetLayout.h"

typedef NS_ENUM(NSInteger, IS_ContentImageActionType) {

    IS_ContentImageActionTypeNone,
    IS_ContentImageActionTypeAdd,
    IS_ContentImageActionTypeDel,
    IS_ContentImageActionTypeDidSelect,
};
typedef NS_ENUM(NSInteger, IS_AddType) {
    IS_AddTypeTypeNone,
    IS_AddTypeTypeAuto,
    IS_AddTypeTypeByDrag,
    IS_AddTypeTypeByHand,
};

@protocol IS_CardCollectionViewDelegate <NSObject>

@optional
/**
 *  每个拖动结束
 */
- (void)IS_CardCollectionViewDidEndDecelerating:(id)itemData
                                    userinfo:(NSDictionary*)userinfo;

/**
 *  @brief  每个操作结束(增删改查)
 */
- (void)IS_CardCollectionViewDidEndOperation:(id)itemData
                                  ActionType:(IS_ContentImageActionType)type;


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
/**
 *  @brief  开始时候默认的模板们
 *
 */
-(void)addDefaultWithSenceName:(NSString*)sceneName;
#pragma mark - 响应模板点击->保存图片->换模板
- (void)collectionToChangeTemplate:(id)template_obj;
#pragma mark - 批量增加图片
- (void)insertAssetIntoEditView:(NSMutableArray*)image_array
              WithAssetURLArray:(NSMutableArray*)assetUrlArray;
#pragma mark - 数据的增删改查
/**
 *  @brief  增加页数
 *
 *  @param byHand 是否手动
 */
-(void)addCurrentItem:(IS_AddType)addType;
/**
 *  @brief  删除页数
 */
-(void)deleteCurrentItem;


@end
