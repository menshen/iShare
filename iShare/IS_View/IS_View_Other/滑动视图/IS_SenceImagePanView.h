@protocol IS_SenceImagePanViewDelegate <NSObject>
@optional

/**
 *  当点击事件后
 */
- (void)IS_SenceImagePanViewDidSelectItem:(id)itemData
                                 userinfo:(NSDictionary*)userinfo;


@end


#import "IS_SencePanView.h"

@interface IS_SenceImagePanView : IS_SencePanView

/**
 *  代理
 */
@property (nonatomic,weak)id<IS_SenceImagePanViewDelegate>delegate;


///1.默认
#pragma mark - 初始化
- (void)addDefaultImgaeData:(NSMutableArray * )arrayM;

//2.增加其他
//2.增加其他
-(void)insertSenceImageArray:(NSArray*)imageArray
           WithAssetURLArray:(NSArray*)assetUrlArray;

//3.删除其他
-(void)deleteSenceImageForIndexPath:(NSIndexPath*)indexPath;

#pragma mark - 模板改变
-(void)templateDidChangeClearIndexPath:(id)itemData;

#pragma mark -点击大图->选中状态更新
-(void)bigImageDidActionImagePan:(id)itemData;
@end
