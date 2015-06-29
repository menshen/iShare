
#import "IS_CollectionViewController.h"
typedef NS_ENUM(NSInteger, IS_SceneChooseType){
    IS_SceneChooseTypeCreate,
    IS_SceneChooseTypeChange
};

@protocol IS_SceneCollectionControllerDelegate <NSObject>

- (void)IS_SceneCollectionControllerDidSceneChange:(id)result;

@end

@interface IS_SceneCollectionController : IS_CollectionViewController
-(void)appendDatasource:(NSMutableArray *)datasource;


/*!
 *  1.直接进入 2.换场景
 */
@property (assign,nonatomic)IS_SceneChooseType sceneChooseType;
/*!
 *  代理
 */
@property (assign,nonatomic)id<IS_SceneCollectionControllerDelegate>delegate;

@end
