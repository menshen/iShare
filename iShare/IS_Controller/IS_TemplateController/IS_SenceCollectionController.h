
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, IS_SceneChooseType){
    IS_SceneChooseTypeCreate,
    IS_SceneChooseTypeChange
};

=
@interface IS_SenceCollectionController : UIViewController
-(void)appendDatasource:(NSMutableArray *)datasource;
/*!
 *  1.直接进入 2.换场景
 */
@property (assign,nonatomic)IS_SceneChooseType sceneChooseType;
@end
